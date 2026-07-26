import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like } from 'typeorm';
import { Request } from 'express';

import { LessonPlanEntity } from './entities/lesson-plan.entity';
import { AssignmentEntity } from './entities/assignment.entity';
import { GradebookEntryEntity } from './entities/gradebook-entry.entity';
import { TeacherAttendanceEntity } from './entities/teacher-attendance.entity';
import { SyllabusTopicEntity } from './entities/syllabus-topic.entity';
import { LessonMaterialEntity } from './entities/lesson-material.entity';
import { AVRecordingEntity } from './entities/av-recording.entity';
import { LiveSessionEntity } from './entities/live-session.entity';
import { AnnouncementEntity } from './entities/announcement.entity';
import { QuestionBankEntity } from './entities/question-bank.entity';
import { QuizEntity } from './entities/quiz.entity';
import { ParentCommEntity } from './entities/parent-comm.entity';
import { BehaviorNoteEntity } from './entities/behavior-note.entity';
import { CalendarEventEntity } from './entities/calendar-event.entity';
import { SharedResourceEntity } from './entities/shared-resource.entity';
import { TeacherNotificationEntity } from './entities/teacher-notification.entity';
import { RemedialStudentEntity } from './entities/remedial-student.entity';

import * as dto from './teacher.dto';

function todayISO() { return new Date().toISOString().slice(0, 10); }

@Injectable()
export class TeacherService {
  constructor(
    @InjectRepository(LessonPlanEntity) private lessonPlanRepo: Repository<LessonPlanEntity>,
    @InjectRepository(AssignmentEntity) private assignmentRepo: Repository<AssignmentEntity>,
    @InjectRepository(GradebookEntryEntity) private gradebookRepo: Repository<GradebookEntryEntity>,
    @InjectRepository(TeacherAttendanceEntity) private attendanceRepo: Repository<TeacherAttendanceEntity>,
    @InjectRepository(SyllabusTopicEntity) private syllabusRepo: Repository<SyllabusTopicEntity>,
    @InjectRepository(LessonMaterialEntity) private materialRepo: Repository<LessonMaterialEntity>,
    @InjectRepository(AVRecordingEntity) private avRepo: Repository<AVRecordingEntity>,
    @InjectRepository(LiveSessionEntity) private liveRepo: Repository<LiveSessionEntity>,
    @InjectRepository(AnnouncementEntity) private announcementRepo: Repository<AnnouncementEntity>,
    @InjectRepository(QuestionBankEntity) private questionRepo: Repository<QuestionBankEntity>,
    @InjectRepository(QuizEntity) private quizRepo: Repository<QuizEntity>,
    @InjectRepository(ParentCommEntity) private parentCommRepo: Repository<ParentCommEntity>,
    @InjectRepository(BehaviorNoteEntity) private behaviorRepo: Repository<BehaviorNoteEntity>,
    @InjectRepository(CalendarEventEntity) private calendarRepo: Repository<CalendarEventEntity>,
    @InjectRepository(SharedResourceEntity) private sharedResourceRepo: Repository<SharedResourceEntity>,
    @InjectRepository(TeacherNotificationEntity) private notificationRepo: Repository<TeacherNotificationEntity>,
    @InjectRepository(RemedialStudentEntity) private remedialRepo: Repository<RemedialStudentEntity>,
  ) {}

  private getTeacherId(req: Request): string { return (req.user as any)?.userId || 'unknown'; }

  // ── Lesson Plans ──
  async getLessonPlans(tenantId: string) { return this.lessonPlanRepo.find({ where: { tenantId }, order: { date: 'DESC' } }); }
  async createLessonPlan(d: dto.CreateLessonPlanDto, tenantId: string, teacherId: string) {
    return this.lessonPlanRepo.save(this.lessonPlanRepo.create({ ...d, tenantId, teacherId, status: 'Planned' }));
  }
  async updateLessonPlan(id: string, d: dto.UpdateLessonPlanDto, tenantId: string) {
    await this.lessonPlanRepo.update({ id, tenantId }, d as any);
    return this.lessonPlanRepo.findOneBy({ id, tenantId });
  }
  async deleteLessonPlan(id: string, tenantId: string) {
    await this.lessonPlanRepo.delete({ id, tenantId });
    return { message: 'Deleted' };
  }
  async markLessonTaught(id: string, reflection: string, tenantId: string) {
    await this.lessonPlanRepo.update({ id, tenantId }, { status: 'Taught', reflection });
    return this.lessonPlanRepo.findOneBy({ id, tenantId });
  }

  // ── Assignments ──
  async getAssignments(tenantId: string) { return this.assignmentRepo.find({ where: { tenantId }, order: { dateCreated: 'DESC' } }); }
  async createAssignment(d: dto.CreateAssignmentDto, tenantId: string, teacherId: string) {
    return this.assignmentRepo.save(this.assignmentRepo.create({ ...d, tenantId, teacherId, status: 'Draft', dateCreated: todayISO(), submissions: [], createdBy: teacherId }));
  }
  async publishAssignment(id: string, tenantId: string) {
    await this.assignmentRepo.update({ id, tenantId }, { status: 'Published' });
    return this.assignmentRepo.findOneBy({ id, tenantId });
  }
  async closeAssignment(id: string, tenantId: string) {
    await this.assignmentRepo.update({ id, tenantId }, { status: 'Closed' });
    return this.assignmentRepo.findOneBy({ id, tenantId });
  }
  async deleteAssignment(id: string, tenantId: string) { await this.assignmentRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }
  async gradeSubmission(id: string, d: dto.GradeSubmissionDto, tenantId: string) {
    const a = await this.assignmentRepo.findOneBy({ id, tenantId });
    if (!a) throw new NotFoundException();
    a.submissions = a.submissions.map((s: any) => s.id === d.submissionId ? { ...s, score: d.score, feedback: d.feedback || '', status: 'Graded' } : s);
    await this.assignmentRepo.save(a);
    return a;
  }
  async bulkGrade(id: string, d: dto.BulkGradeDto, tenantId: string) {
    const a = await this.assignmentRepo.findOneBy({ id, tenantId });
    if (!a) throw new NotFoundException();
    a.submissions = a.submissions.map((s: any) => {
      const g = d.grades.find((gr) => gr.submissionId === s.id);
      return g ? { ...s, score: g.score, feedback: g.feedback || '', status: 'Graded' } : s;
    });
    await this.assignmentRepo.save(a);
    return a;
  }
  async duplicateAssignment(id: string, newClassForm: string, tenantId: string, teacherId: string) {
    const orig = await this.assignmentRepo.findOneBy({ id, tenantId });
    if (!orig) throw new NotFoundException();
    const { ...rest } = orig;
    return this.assignmentRepo.save(this.assignmentRepo.create({ ...rest, id: undefined as any, classForm: newClassForm, dateCreated: todayISO(), status: 'Draft', submissions: [], teacherId }));
  }

  // ── Gradebook ──
  async getGradebook(tenantId: string, classForm?: string, subject?: string) {
    const where: any = { tenantId };
    if (classForm) where.classForm = classForm;
    if (subject) where.subject = subject;
    return this.gradebookRepo.find({ where });
  }
  async createGradebook(d: dto.CreateGradebookDto, tenantId: string) {
    return this.gradebookRepo.save(this.gradebookRepo.create({ ...d, tenantId }));
  }
  async deleteGradebook(id: string, tenantId: string) { await this.gradebookRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Attendance ──
  async getAttendance(tenantId: string, classForm?: string, date?: string) {
    const where: any = { tenantId };
    if (classForm) where.classForm = classForm;
    if (date) where.date = date;
    return this.attendanceRepo.find({ where, order: { date: 'DESC' } });
  }
  async createAttendance(d: dto.CreateAttendanceDto, tenantId: string) {
    return this.attendanceRepo.save(this.attendanceRepo.create({ ...d, tenantId }));
  }
  async bulkAttendance(d: dto.BulkAttendanceDto, tenantId: string) {
    const records = d.records.map((r) => this.attendanceRepo.create({ ...r, tenantId }));
    return this.attendanceRepo.save(records);
  }

  // ── Syllabus ──
  async getSyllabus(tenantId: string, subject?: string, classForm?: string) {
    const where: any = { tenantId };
    if (subject) where.subject = subject;
    if (classForm) where.classForm = classForm;
    return this.syllabusRepo.find({ where, order: { week: 'ASC' } });
  }
  async createSyllabus(d: dto.CreateSyllabusDto, tenantId: string) {
    return this.syllabusRepo.save(this.syllabusRepo.create({ ...d, tenantId, status: 'Not Started' }));
  }
  async updateSyllabus(id: string, d: dto.UpdateSyllabusDto, tenantId: string) {
    await this.syllabusRepo.update({ id, tenantId }, d as any);
    return this.syllabusRepo.findOneBy({ id, tenantId });
  }
  async deleteSyllabus(id: string, tenantId: string) { await this.syllabusRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Materials ──
  async getMaterials(tenantId: string) { return this.materialRepo.find({ where: { tenantId }, order: { dateUploaded: 'DESC' } }); }
  async createMaterial(d: dto.CreateMaterialDto, tenantId: string, uploadedBy: string) {
    return this.materialRepo.save(this.materialRepo.create({ ...d, tenantId, uploadedBy, dateUploaded: todayISO() }));
  }
  async deleteMaterial(id: string, tenantId: string) { await this.materialRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── AV Recordings ──
  async getAV(tenantId: string) { return this.avRepo.find({ where: { tenantId }, order: { dateRecorded: 'DESC' } }); }
  async createAV(d: dto.CreateAVDto, tenantId: string, recordedBy: string) {
    return this.avRepo.save(this.avRepo.create({ ...d, tenantId, recordedBy, dateRecorded: todayISO() }));
  }
  async deleteAV(id: string, tenantId: string) { await this.avRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Live Sessions ──
  async getLiveSessions(tenantId: string) { return this.liveRepo.find({ where: { tenantId }, order: { scheduledTime: 'DESC' } }); }
  async createLiveSession(d: dto.CreateLiveSessionDto, tenantId: string) {
    return this.liveRepo.save(this.liveRepo.create({ ...d, tenantId, status: 'Scheduled', startedBy: '', participants: 0 }));
  }
  async startLiveSession(id: string, startedBy: string, tenantId: string) {
    await this.liveRepo.update({ id, tenantId }, { status: 'Live', startedBy });
    return this.liveRepo.findOneBy({ id, tenantId });
  }
  async endLiveSession(id: string, tenantId: string) {
    await this.liveRepo.update({ id, tenantId }, { status: 'Ended' });
    return this.liveRepo.findOneBy({ id, tenantId });
  }
  async cancelLiveSession(id: string, tenantId: string) {
    await this.liveRepo.update({ id, tenantId }, { status: 'Cancelled' });
    return this.liveRepo.findOneBy({ id, tenantId });
  }

  // ── Announcements ──
  async getAnnouncements(tenantId: string) { return this.announcementRepo.find({ where: { tenantId }, order: { date: 'DESC' } }); }
  async createAnnouncement(d: dto.CreateAnnouncementDto, tenantId: string, postedBy: string) {
    return this.announcementRepo.save(this.announcementRepo.create({ ...d, tenantId, postedBy, date: todayISO() }));
  }
  async deleteAnnouncement(id: string, tenantId: string) { await this.announcementRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Question Bank ──
  async getQuestions(tenantId: string) { return this.questionRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } }); }
  async createQuestion(d: dto.CreateQuestionDto, tenantId: string) {
    const tags = d.tags ? d.tags.split(',').map((t) => t.trim()).filter(Boolean) : [];
    return this.questionRepo.save(this.questionRepo.create({ ...d, tags, tenantId }));
  }
  async deleteQuestion(id: string, tenantId: string) { await this.questionRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Quizzes ──
  async getQuizzes(tenantId: string) { return this.quizRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } }); }
  async createQuiz(d: dto.CreateQuizDto, tenantId: string) {
    return this.quizRepo.save(this.quizRepo.create({ ...d, tenantId, status: 'Draft', totalMarks: 0, createdAt: todayISO() }));
  }
  async publishQuiz(id: string, tenantId: string) {
    await this.quizRepo.update({ id, tenantId }, { status: 'Published' });
    return this.quizRepo.findOneBy({ id, tenantId });
  }
  async closeQuiz(id: string, tenantId: string) {
    await this.quizRepo.update({ id, tenantId }, { status: 'Closed' });
    return this.quizRepo.findOneBy({ id, tenantId });
  }
  async deleteQuiz(id: string, tenantId: string) { await this.quizRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Parent Comms ──
  async getParentComms(tenantId: string) { return this.parentCommRepo.find({ where: { tenantId }, order: { date: 'DESC' } }); }
  async createParentComm(d: dto.CreateParentCommDto, tenantId: string) {
    return this.parentCommRepo.save(this.parentCommRepo.create({ ...d, tenantId, date: todayISO() }));
  }
  async deleteParentComm(id: string, tenantId: string) { await this.parentCommRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Behavior Notes ──
  async getBehaviorNotes(tenantId: string) { return this.behaviorRepo.find({ where: { tenantId }, order: { date: 'DESC' } }); }
  async createBehaviorNote(d: dto.CreateBehaviorNoteDto, tenantId: string, reportedBy: string) {
    return this.behaviorRepo.save(this.behaviorRepo.create({ ...d, tenantId, reportedBy }));
  }
  async deleteBehaviorNote(id: string, tenantId: string) { await this.behaviorRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Calendar Events ──
  async getCalendarEvents(tenantId: string, year?: number, month?: number) {
    const where: any = { tenantId };
    if (year !== undefined && month !== undefined) {
      const prefix = `${year}-${String(month + 1).padStart(2, '0')}`;
      return this.calendarRepo.find({ where: { tenantId, date: Like(`${prefix}%`) }, order: { date: 'ASC' } });
    }
    return this.calendarRepo.find({ where, order: { date: 'ASC' } });
  }
  async createCalendarEvent(d: dto.CreateCalendarEventDto, tenantId: string) {
    return this.calendarRepo.save(this.calendarRepo.create({ ...d, tenantId }));
  }
  async deleteCalendarEvent(id: string, tenantId: string) { await this.calendarRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Shared Resources ──
  async getSharedResources(tenantId: string) { return this.sharedResourceRepo.find({ where: { tenantId }, order: { sharedDate: 'DESC' } }); }
  async createSharedResource(d: dto.CreateSharedResourceDto, tenantId: string, sharedBy: string) {
    return this.sharedResourceRepo.save(this.sharedResourceRepo.create({ ...d, tenantId, sharedBy, sharedDate: todayISO() }));
  }
  async deleteSharedResource(id: string, tenantId: string) { await this.sharedResourceRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Notifications ──
  async getNotifications(tenantId: string) { return this.notificationRepo.find({ where: { tenantId }, order: { date: 'DESC' } }); }
  async markNotificationRead(id: string, tenantId: string) {
    await this.notificationRepo.update({ id, tenantId }, { read: true });
    return { message: 'Read' };
  }
  async markAllNotificationsRead(tenantId: string) {
    await this.notificationRepo.update({ tenantId }, { read: true });
    return { message: 'All read' };
  }

  // ── Remedial ──
  async getRemedial(tenantId: string) { return this.remedialRepo.find({ where: { tenantId }, order: { dateStarted: 'DESC' } }); }
  async createRemedial(d: dto.CreateRemedialDto, tenantId: string) {
    return this.remedialRepo.save(this.remedialRepo.create({ ...d, tenantId, dateStarted: todayISO(), progress: 'Just Started' }));
  }
  async updateRemedial(id: string, d: dto.UpdateRemedialDto, tenantId: string) {
    await this.remedialRepo.update({ id, tenantId }, d as any);
    return this.remedialRepo.findOneBy({ id, tenantId });
  }
  async deleteRemedial(id: string, tenantId: string) { await this.remedialRepo.delete({ id, tenantId }); return { message: 'Deleted' }; }

  // ── Analytics ──
  async getClassAnalytics(tenantId: string, classForm: string, subject: string) {
    const entries = await this.gradebookRepo.find({ where: { tenantId, classForm, subject } });
    if (entries.length === 0) return { average: 0, max: 0, min: 0, passRate: 0, gradeDistribution: {}, atRiskStudents: [], topPerformers: [] };
    const pct = entries.map((e) => (e.total / e.totalMax) * 100);
    const average = Math.round(pct.reduce((a, b) => a + b, 0) / entries.length);
    const max = Math.round(Math.max(...pct));
    const min = Math.round(Math.min(...pct));
    const passRate = Math.round((pct.filter((p) => p >= 50).length / entries.length) * 100);
    const gradeDistribution: Record<string, number> = {};
    entries.forEach((e) => { gradeDistribution[e.grade] = (gradeDistribution[e.grade] || 0) + 1; });
    const atRiskStudents = entries.filter((e) => (e.total / e.totalMax) * 100 < 50).map((e) => ({ id: e.id, studentName: e.studentName, admNo: e.admNo, total: e.total, totalMax: e.totalMax, grade: e.grade }));
    const topPerformers = [...entries].sort((a, b) => b.total - a.total).slice(0, 3).map((e) => ({ id: e.id, studentName: e.studentName, admNo: e.admNo, total: e.total, totalMax: e.totalMax, grade: e.grade }));
    return { average, max, min, passRate, gradeDistribution, atRiskStudents, topPerformers };
  }

  async getAttendanceAnalytics(tenantId: string, classForm: string) {
    const records = await this.attendanceRepo.find({ where: { tenantId, classForm } });
    const studentMap: Record<string, { studentName: string; admNo: string; present: number; absent: number; late: number; excused: number }> = {};
    records.forEach((r) => {
      const key = r.admNo;
      if (!studentMap[key]) studentMap[key] = { studentName: r.studentName, admNo: r.admNo, present: 0, absent: 0, late: 0, excused: 0 };
      if (r.status === 'Present') studentMap[key].present++;
      else if (r.status === 'Absent') studentMap[key].absent++;
      else if (r.status === 'Late') studentMap[key].late++;
      else if (r.status === 'Excused') studentMap[key].excused++;
    });
    const perStudent = Object.values(studentMap).map((s) => {
      const total = s.present + s.absent + s.late + s.excused;
      return { ...s, rate: total > 0 ? Math.round((s.present / total) * 100) : 0 };
    });
    const frequentAbsentees = perStudent.filter((s) => s.absent >= 3);
    return { perStudent, patterns: { frequentAbsentees } };
  }

  // ── Student Profile ──
  async getStudentProfile(tenantId: string, admNo: string) {
    const gradebook = await this.gradebookRepo.find({ where: { tenantId, admNo } });
    const attendance = await this.attendanceRepo.find({ where: { tenantId, admNo } });
    const behavior = await this.behaviorRepo.find({ where: { tenantId, admNo } });
    const parentComms = await this.parentCommRepo.find({ where: { tenantId, admNo } });
    const remedial = await this.remedialRepo.findOne({ where: { tenantId, admNo } });
    const assignments = await this.assignmentRepo.find({ where: { tenantId } });
    const assignmentSubs = assignments.map((a) => {
      const sub = (a.submissions as any[]).find((s) => s.admNo === admNo);
      return { assignment: a, submission: sub || null };
    }).filter((x) => x.submission);
    return { grades: gradebook, attendance, behavior, parentComms, remedial, assignments: assignmentSubs };
  }

  // ── AI Lesson Plan ──
  async generateAILessonPlan(d: dto.AILessonPlanDto) {
    // Built-in generator (no external AI API configured)
    return {
      objectives: `By the end of the lesson, students should be able to understand and apply concepts related to ${d.topic} in ${d.subject}.`,
      teachingMethods: d.teachingStyle || 'Direct instruction with guided practice, group work, and interactive discussion',
      resources: 'Textbook, whiteboard, markers, prepared worksheets, projector (if available)',
      activities: `1. Introduction: Review previous lesson and introduce ${d.topic}\n2. Direct instruction: Explain key concepts with examples\n3. Guided practice: Work through examples together\n4. Independent practice: Students work on exercises\n5. Review and summary`,
      assessment: 'Oral questioning during lesson, exit ticket with 2-3 questions on the topic',
      homework: `Exercise problems on ${d.topic} from textbook`,
      introduction: `Begin with a real-world connection to ${d.topic}. Ask students what they already know. State the lesson objectives clearly.`,
      mainActivity: `Step-by-step explanation of ${d.topic} with worked examples. Break down complex concepts into manageable parts. Use the ${d.teachingStyle || 'direct instruction'} approach.`,
      conclusion: 'Summarize key points. Ask students to share one thing they learned. Preview the next lesson topic.',
      differentiation: 'Provide additional support for struggling students through simplified examples. Challenge advanced students with extension problems.',
    };
  }
}
