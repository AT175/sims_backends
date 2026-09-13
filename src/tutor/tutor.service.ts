import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TutorSessionEntity } from './tutor-session.entity';
import { Student } from '../students/student.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { GES_CURRICULUM } from '../teacher/ges-curriculum-data';

export interface ChatMessage {
  role: 'user' | 'tutor';
  content: string;
  timestamp: string;
}

@Injectable()
export class TutorService {
  constructor(
    @InjectRepository(TutorSessionEntity) private sessionRepo: Repository<TutorSessionEntity>,
    @InjectRepository(Student) private studentRepo: Repository<Student>,
    @InjectRepository(ExamResult) private examRepo: Repository<ExamResult>,
  ) {}

  async askQuestion(studentId: string, tenantId: string, subject: string, question: string, sessionId?: string) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const classForm = student.classSectionId;
    const messages: ChatMessage[] = [];

    if (sessionId) {
      const session = await this.sessionRepo.findOne({ where: { id: sessionId, tenantId } });
      if (session) {
        messages.push(...JSON.parse(session.messages));
      }
    }

    // Add user message
    messages.push({ role: 'user', content: question, timestamp: new Date().toISOString() });

    // Generate response
    const answer = this.generateResponse(classForm, subject, question, student);
    messages.push({ role: 'tutor', content: answer, timestamp: new Date().toISOString() });

    // Save session
    let session: TutorSessionEntity | null = null;
    if (sessionId) {
      session = await this.sessionRepo.findOne({ where: { id: sessionId, tenantId } });
      if (session) {
        session.messages = JSON.stringify(messages);
        session.subject = subject;
        session.topic = this.extractTopic(question);
        session = await this.sessionRepo.save(session);
      }
    }
    if (!session) {
      session = await this.sessionRepo.save(this.sessionRepo.create({
        tenantId, studentId,
        studentName: `${student.firstName} ${student.lastName}`,
        classForm,
        subject,
        topic: this.extractTopic(question),
        messages: JSON.stringify(messages),
      }));
    }

    return { sessionId: session.id, answer, messages };
  }

  private generateResponse(classForm: string, subject: string, question: string, student: any): string {
    const q = question.toLowerCase();
    const curriculum = this.findCurriculum(classForm, subject);

    // Check question type
    if (q.includes('what is') || q.includes('explain') || q.includes('define') || q.includes('meaning')) {
      return this.generateExplanation(classForm, subject, question, curriculum);
    }
    if (q.includes('example') || q.includes('examples')) {
      return this.generateExamples(classForm, subject, curriculum);
    }
    if (q.includes('practice') || q.includes('exercise') || q.includes('question') || q.includes('quiz')) {
      return this.generatePracticeQuestions(classForm, subject, curriculum);
    }
    if (q.includes('how') && (q.includes('solve') || q.includes('calculate') || q.includes('find'))) {
      return this.generateWorkedExample(classForm, subject, question, curriculum);
    }
    if (q.includes("don't understand") || q.includes("dont understand") || q.includes('confused') || q.includes('difficult')) {
      return this.generateSimplifiedExplanation(classForm, subject, curriculum, student);
    }
    if (q.includes('help') || q.includes('study') || q.includes('revise') || q.includes('review')) {
      return this.generateStudyPlan(classForm, subject, curriculum);
    }

    // Default: provide overview
    return this.generateOverview(classForm, subject, curriculum);
  }

  private findCurriculum(classForm: string, subject: string): any {
    const entry = GES_CURRICULUM.find((c) => c.key === classForm);
    if (!entry) return null;
    return entry.subjects.find((s: any) => s.name === subject || s.name.includes(subject));
  }

  private generateExplanation(classForm: string, subject: string, question: string, curriculum: any): string {
    const level = this.getLevel(classForm);
    const topic = this.extractTopic(question) || (curriculum?.weeks?.[0]?.subStrand) || 'this topic';

    let response = `Great question! Let me explain ${topic}.\n\n`;

    if (curriculum && curriculum.weeks) {
      const weekInfo = curriculum.weeks[0];
      response += `This topic is part of the ${curriculum.name} curriculum.\n`;
      response += `Strand: ${weekInfo?.strand || 'General'}\n`;
      response += `Sub-Strand: ${weekInfo?.subStrand || topic}\n`;
      response += `Indicator: ${weekInfo?.indicator || 'N/A'}\n\n`;
    }

    if (level === 'kg') {
      response += `${topic} is something we see and do every day! Let's learn about it together with pictures and songs.\n`;
    } else if (level === 'primary') {
      response += `${topic} means: a simple way to understand this is to think about things around you. `;
      response += `For example, when you count objects or share things with friends, you are using ${topic}.\n`;
    } else if (level === 'jhs') {
      response += `${topic} is an important concept in ${subject}. `;
      response += `It involves understanding the key principles and applying them to solve problems. `;
      response += `The main points to remember are:\n`;
      response += `1. Definition and meaning of ${topic}\n`;
      response += `2. Key characteristics and properties\n`;
      response += `3. How to apply ${topic} in solving problems\n`;
    } else if (level === 'shs') {
      response += `${topic} is a fundamental concept in ${subject} that requires analytical thinking. `;
      response += `Key aspects include:\n`;
      response += `1. Definition and theoretical framework\n`;
      response += `2. Mathematical or analytical formulation\n`;
      response += `3. Real-world applications and examples\n`;
      response += `4. Common misconceptions to avoid\n\n`;
      response += `At the SHS level, you should be able to not only define ${topic} but also analyse and evaluate its applications.\n`;
    }

    response += `\nWould you like me to give you some practice questions on this topic?`;
    return response;
  }

  private generateExamples(classForm: string, subject: string, curriculum: any): string {
    const topic = curriculum?.weeks?.[0]?.subStrand || 'this topic';
    let response = `Here are some examples of ${topic}:\n\n`;

    if (subject.toLowerCase().includes('math')) {
      response += `Example 1: If you have 5 oranges and buy 3 more, you now have 8 oranges. This shows addition.\n`;
      response += `Example 2: If you share 12 sweets equally among 4 friends, each gets 3 sweets. This is division.\n`;
      response += `Example 3: A shop sells rice at GHS 5 per bag. If you buy 4 bags, you pay GHS 20. This is multiplication.\n`;
    } else if (subject.toLowerCase().includes('science')) {
      response += `Example 1: When you boil water, it turns to steam — this is evaporation.\n`;
      response += `Example 2: Plants use sunlight to make food — this is photosynthesis.\n`;
      response += `Example 3: A magnet attracts iron nails — this is magnetism.\n`;
    } else if (subject.toLowerCase().includes('english')) {
      response += `Example 1: "The cat sat on the mat" — 'sat' is an action word (verb).\n`;
      response += `Example 2: "She is tall" — 'tall' describes her (adjective).\n`;
      response += `Example 3: "He ran quickly" — 'quickly' tells how he ran (adverb).\n`;
    } else {
      response += `Example 1: Think about how ${topic} applies to your daily life at home.\n`;
      response += `Example 2: Consider how ${topic} is used in your community.\n`;
      response += `Example 3: Look for ${topic} in the news or in stories you read.\n`;
    }

    response += `\nWould you like to try some practice questions?`;
    return response;
  }

  private generatePracticeQuestions(classForm: string, subject: string, curriculum: any): string {
    const topic = curriculum?.weeks?.[0]?.subStrand || 'this topic';
    let response = `Here are 3 practice questions on ${topic}:\n\n`;

    response += `Q1: What is ${topic}? (Recall level)\n`;
    response += `Answer: Write your own answer, then check your notes.\n\n`;

    response += `Q2: Give one example of ${topic} in everyday life. (Comprehension level)\n`;
    response += `Answer: Think of something you see at home or in school.\n\n`;

    response += `Q3: How would you explain ${topic} to a friend who doesn't understand it? (Application level)\n`;
    response += `Answer: Try teaching it — this helps you learn it better!\n\n`;

    response += `💡 Tip: Try to answer these without looking at your notes first. `;
    response += `If you get stuck, ask me to explain any of these questions!`;
    return response;
  }

  private generateWorkedExample(classForm: string, subject: string, question: string, curriculum: any): string {
    let response = `Let me work through this step by step:\n\n`;
    response += `Step 1: Identify what the question is asking.\n`;
    response += `Step 2: Write down the formula or method you need.\n`;
    response += `Step 3: Substitute the values given in the question.\n`;
    response += `Step 4: Calculate the answer carefully.\n`;
    response += `Step 5: Check your answer — does it make sense?\n\n`;

    if (subject.toLowerCase().includes('math') || subject.toLowerCase().includes('physics')) {
      response += `Example: If the question asks "Find x when 2x + 5 = 13":\n`;
      response += `Step 1: We need to find x.\n`;
      response += `Step 2: Method: subtract 5 from both sides, then divide by 2.\n`;
      response += `Step 3: 2x = 13 - 5 = 8\n`;
      response += `Step 4: x = 8 / 2 = 4\n`;
      response += `Step 5: Check: 2(4) + 5 = 13 ✓ Correct!\n`;
    }

    response += `\nWould you like more practice questions?`;
    return response;
  }

  private generateSimplifiedExplanation(classForm: string, subject: string, curriculum: any, student: any): string {
    const topic = curriculum?.weeks?.[0]?.subStrand || 'this topic';
    let response = `Don't worry! ${topic} can be tricky, but let's break it down simply.\n\n`;
    response += `Think of ${topic} like this:\n`;
    response += `• It's a way of understanding something in ${subject}.\n`;
    response += `• The simplest way to think about it is with everyday examples.\n`;
    response += `• Once you understand the basic idea, the harder parts become easier.\n\n`;
    response += `💡 Remember: Everyone finds some topics difficult at first. `;
    response += `The key is to practice a little bit every day. You can do it!\n\n`;
    response += `Would you like me to give you a very simple example to start with?`;
    return response;
  }

  private generateStudyPlan(classForm: string, subject: string, curriculum: any): string {
    const topic = curriculum?.weeks?.[0]?.subStrand || 'this topic';
    let response = `Here's a study plan for ${subject}:\n\n`;
    response += `Day 1: Read about ${topic} and write down key terms.\n`;
    response += `Day 2: Try 3 practice questions on ${topic}.\n`;
    response += `Day 3: Review your answers and find your mistakes.\n`;
    response += `Day 4: Try harder questions or ask me for help.\n`;
    response += `Day 5: Test yourself — can you explain ${topic} without looking at notes?\n\n`;
    response += `💡 Tip: Study for 30-45 minutes, then take a 10-minute break. `;
    response += `Your brain learns better with short, focused sessions!`;
    return response;
  }

  private generateOverview(classForm: string, subject: string, curriculum: any): string {
    const topic = curriculum?.weeks?.[0]?.subStrand || 'your subject';
    let response = `Hello! I'm your AI Tutor for ${subject}. I can help you with:\n\n`;
    response += `📚 Explaining topics from your lesson\n`;
    response += `✏️ Giving you practice questions\n`;
    response += `💡 Showing worked examples\n`;
    response += `🧠 Helping you understand difficult concepts\n`;
    response += `📅 Creating a study plan\n\n`;
    response += `This week's topic is: ${topic}\n\n`;
    response += `What would you like to learn about? You can ask me:\n`;
    response += `• "Explain ${topic}"\n`;
    response += `• "Give me practice questions"\n`;
    response += `• "I don't understand ${topic}"\n`;
    response += `• "Show me an example"`;
    return response;
  }

  private getLevel(classForm: string): string {
    if (classForm.startsWith('kg')) return 'kg';
    if (classForm.startsWith('basic') && parseInt(classForm.replace('basic', '')) <= 6) return 'primary';
    if (classForm.startsWith('basic')) return 'jhs';
    if (classForm.startsWith('shs')) return 'shs';
    return 'primary';
  }

  private extractTopic(question: string): string | null {
    // Try to extract a topic from the question
    const q = question.toLowerCase();
    const topicKeywords = q.match(/(?:about|explain|define|what is|what are|how (?:do|does|to))\s+(?:a |an |the )?([a-z\s]+)/i);
    if (topicKeywords && topicKeywords[1]) {
      return topicKeywords[1].trim().split(/\s+/).slice(0, 5).join(' ');
    }
    return null;
  }

  async getWeakAreas(studentId: string, tenantId: string) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const results = await this.examRepo.find({ where: { tenantId, admNo: student.admissionNumber } });
    const subjectScores: Record<string, number[]> = {};
    for (const r of results) {
      if (!subjectScores[r.subject]) subjectScores[r.subject] = [];
      subjectScores[r.subject].push(Number(r.marks));
    }

    const weakAreas = Object.entries(subjectScores).map(([subject, scores]) => {
      const avg = scores.reduce((s, x) => s + x, 0) / scores.length;
      return { subject, averageScore: avg.toFixed(1), isWeak: avg < 50, isCritical: avg < 40 };
    }).sort((a, b) => parseFloat(a.averageScore) - parseFloat(b.averageScore));

    return {
      studentName: `${student.firstName} ${student.lastName}`,
      weakAreas: weakAreas.filter((a) => a.isWeak),
      allAreas: weakAreas,
    };
  }

  async getSessionHistory(studentId: string, tenantId: string) {
    const sessions = await this.sessionRepo.find({
      where: { tenantId, studentId },
      order: { createdAt: 'DESC' },
      take: 20,
    });
    return sessions.map((s) => ({
      id: s.id,
      subject: s.subject,
      topic: s.topic,
      messageCount: JSON.parse(s.messages).length,
      createdAt: s.createdAt,
    }));
  }

  async getSession(sessionId: string, tenantId: string) {
    const session = await this.sessionRepo.findOne({ where: { id: sessionId, tenantId } });
    if (!session) throw new NotFoundException('Session not found');
    return { ...session, messages: JSON.parse(session.messages) };
  }
}
