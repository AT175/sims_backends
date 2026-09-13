import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ForumQuestionEntity } from './forum-question.entity';
import { ForumAnswerEntity } from './forum-answer.entity';
import { StudyGroupEntity } from './study-group.entity';
import { StudyGroupMessageEntity } from './study-group-message.entity';

// Simple profanity filter
const BANNED_WORDS = ['stupid', 'idiot', 'fool', 'useless', 'hate', 'kill', 'fight', 'damn'];

function containsProfanity(text: string): boolean {
  const lower = text.toLowerCase();
  return BANNED_WORDS.some((w) => lower.includes(w));
}

@Injectable()
export class PeerService {
  constructor(
    @InjectRepository(ForumQuestionEntity) private questionRepo: Repository<ForumQuestionEntity>,
    @InjectRepository(ForumAnswerEntity) private answerRepo: Repository<ForumAnswerEntity>,
    @InjectRepository(StudyGroupEntity) private groupRepo: Repository<StudyGroupEntity>,
    @InjectRepository(StudyGroupMessageEntity) private messageRepo: Repository<StudyGroupMessageEntity>,
  ) {}

  // ── Q&A Forum ──────────────────────────────────────────────

  async askQuestion(studentId: string, studentName: string, tenantId: string, classForm: string, data: {
    subject: string;
    topic?: string;
    question: string;
    tags?: string[];
  }) {
    if (containsProfanity(data.question)) {
      throw new BadRequestException('Your question contains inappropriate language. Please rephrase.');
    }
    return this.questionRepo.save(this.questionRepo.create({
      tenantId, studentId, studentName, classForm,
      subject: data.subject,
      topic: data.topic || null,
      question: data.question,
      tags: data.tags || [],
    }));
  }

  async getQuestions(tenantId: string, filters?: { subject?: string; classForm?: string; tag?: string; status?: string }) {
    const where: any = { tenantId };
    if (filters?.subject) where.subject = filters.subject;
    if (filters?.classForm) where.classForm = filters.classForm;
    if (filters?.status) where.status = filters.status;

    let questions = await this.questionRepo.find({ where, order: { createdAt: 'DESC' as any } });

    if (filters?.tag) {
      questions = questions.filter((q) => q.tags.includes(filters.tag!));
    }

    return questions;
  }

  async getQuestion(questionId: string, tenantId: string) {
    const question = await this.questionRepo.findOne({ where: { id: questionId, tenantId } });
    if (!question) throw new NotFoundException('Question not found');
    question.viewCount += 1;
    await this.questionRepo.save(question);
    const answers = await this.answerRepo.find({ where: { tenantId, questionId }, order: { createdAt: 'DESC' as any } });
    return { question, answers };
  }

  async answerQuestion(questionId: string, studentId: string, studentName: string, tenantId: string, content: string) {
    if (containsProfanity(content)) {
      throw new BadRequestException('Your answer contains inappropriate language. Please rephrase.');
    }
    const question = await this.questionRepo.findOne({ where: { id: questionId, tenantId } });
    if (!question) throw new NotFoundException('Question not found');

    const answer = await this.answerRepo.save(this.answerRepo.create({
      tenantId, questionId, studentId, studentName, content,
    }));

    question.answerCount += 1;
    if (question.status === 'open') question.status = 'answered';
    await this.questionRepo.save(question);

    return answer;
  }

  async upvoteQuestion(questionId: string, tenantId: string) {
    const q = await this.questionRepo.findOne({ where: { id: questionId, tenantId } });
    if (!q) throw new NotFoundException('Question not found');
    q.upvotes += 1;
    return this.questionRepo.save(q);
  }

  async upvoteAnswer(answerId: string, tenantId: string) {
    const a = await this.answerRepo.findOne({ where: { id: answerId, tenantId } });
    if (!a) throw new NotFoundException('Answer not found');
    a.upvotes += 1;
    return this.answerRepo.save(a);
  }

  async acceptAnswer(questionId: string, answerId: string, tenantId: string) {
    const q = await this.questionRepo.findOne({ where: { id: questionId, tenantId } });
    if (!q) throw new NotFoundException('Question not found');
    const a = await this.answerRepo.findOne({ where: { id: answerId, tenantId } });
    if (!a) throw new NotFoundException('Answer not found');

    a.isAccepted = true;
    q.status = 'closed';
    await this.answerRepo.save(a);
    return this.questionRepo.save(q);
  }

  async flagQuestion(questionId: string, tenantId: string) {
    const q = await this.questionRepo.findOne({ where: { id: questionId, tenantId } });
    if (!q) throw new NotFoundException('Question not found');
    q.status = 'flagged';
    return this.questionRepo.save(q);
  }

  async pinQuestion(questionId: string, tenantId: string) {
    const q = await this.questionRepo.findOne({ where: { id: questionId, tenantId } });
    if (!q) throw new NotFoundException('Question not found');
    q.pinned = !q.pinned;
    return this.questionRepo.save(q);
  }

  async getLeaderboard(tenantId: string) {
    const answers = await this.answerRepo.find({ where: { tenantId } });
    const leaderboard: Record<string, { name: string; answers: number; upvotes: number; accepted: number }> = {};
    for (const a of answers) {
      if (!leaderboard[a.studentId]) leaderboard[a.studentId] = { name: a.studentName, answers: 0, upvotes: 0, accepted: 0 };
      leaderboard[a.studentId].answers++;
      leaderboard[a.studentId].upvotes += a.upvotes;
      if (a.isAccepted) leaderboard[a.studentId].accepted++;
    }
    return Object.entries(leaderboard).map(([id, data]) => ({ studentId: id, ...data }))
      .sort((a, b) => (b.upvotes + b.accepted * 5) - (a.upvotes + a.accepted * 5))
      .slice(0, 20);
  }

  // ── Study Groups ───────────────────────────────────────────

  async createStudyGroup(studentId: string, studentName: string, tenantId: string, data: {
    name: string;
    subject: string;
    description?: string;
    classForm?: string;
  }) {
    return this.groupRepo.save(this.groupRepo.create({
      tenantId,
      name: data.name,
      subject: data.subject,
      description: data.description || null,
      createdBy: studentId,
      createdByName: studentName,
      members: [studentId],
      classForm: data.classForm || null,
    }));
  }

  async getStudyGroups(tenantId: string, subject?: string) {
    const where: any = { tenantId };
    if (subject) where.subject = subject;
    return this.groupRepo.find({ where, order: { createdAt: 'DESC' as any } });
  }

  async joinStudyGroup(groupId: string, studentId: string, tenantId: string) {
    const group = await this.groupRepo.findOne({ where: { id: groupId, tenantId } });
    if (!group) throw new NotFoundException('Study group not found');
    if (!group.members.includes(studentId)) {
      group.members.push(studentId);
    }
    return this.groupRepo.save(group);
  }

  async postGroupMessage(groupId: string, studentId: string, studentName: string, tenantId: string, content: string) {
    if (containsProfanity(content)) {
      throw new BadRequestException('Your message contains inappropriate language. Please rephrase.');
    }
    const group = await this.groupRepo.findOne({ where: { id: groupId, tenantId } });
    if (!group) throw new NotFoundException('Study group not found');
    if (!group.members.includes(studentId)) {
      throw new BadRequestException('You must join the group before posting messages.');
    }
    return this.messageRepo.save(this.messageRepo.create({
      tenantId, groupId, studentId, studentName, content,
    }));
  }

  async getGroupMessages(groupId: string, tenantId: string) {
    return this.messageRepo.find({ where: { tenantId, groupId }, order: { createdAt: 'ASC' as any } });
  }
}
