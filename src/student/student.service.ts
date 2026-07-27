import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { HealthRecord } from './entities/health-record.entity';
import { StudentFeedback } from './entities/student-feedback.entity';
import { AssignmentSubmission } from './entities/assignment-submission.entity';
import { StudentAttendance } from './entities/student-attendance.entity';
import { StudentResult } from './entities/student-result.entity';
import { StudentMaterial } from './entities/student-material.entity';
import { StudentClass } from './entities/student-class.entity';
import { StudentMessage } from './entities/student-message.entity';
import { Student } from '../students/student.entity';
import { ExeatRecord } from '../boarding/exeat-record.entity';
import { RollCallEntry } from '../boarding/roll-call-entry.entity';
import { BoardingDisciplineLog } from '../boarding/discipline-log.entity';
import { LessonMaterialEntity } from '../teacher/entities/lesson-material.entity';
import { AnnouncementEntity } from '../teacher/entities/announcement.entity';
import { LiveSessionEntity } from '../teacher/entities/live-session.entity';
import { AVRecordingEntity } from '../teacher/entities/av-recording.entity';
import { SharedResourceEntity } from '../teacher/entities/shared-resource.entity';
import { QuizEntity } from '../teacher/entities/quiz.entity';
import * as dto from './student.dto';

@Injectable()
export class StudentService {
  constructor(
    @InjectRepository(HealthRecord) private healthRepo: Repository<HealthRecord>,
    @InjectRepository(StudentFeedback) private feedbackRepo: Repository<StudentFeedback>,
    @InjectRepository(AssignmentSubmission) private submissionRepo: Repository<AssignmentSubmission>,
    @InjectRepository(StudentAttendance) private attendanceRepo: Repository<StudentAttendance>,
    @InjectRepository(StudentResult) private resultRepo: Repository<StudentResult>,
    @InjectRepository(StudentMaterial) private materialRepo: Repository<StudentMaterial>,
    @InjectRepository(StudentClass) private classRepo: Repository<StudentClass>,
    @InjectRepository(StudentMessage) private messageRepo: Repository<StudentMessage>,
    @InjectRepository(Student) private studentRepo: Repository<Student>,
    @InjectRepository(ExeatRecord) private exeatRepo: Repository<ExeatRecord>,
    @InjectRepository(RollCallEntry) private rollCallRepo: Repository<RollCallEntry>,
    @InjectRepository(BoardingDisciplineLog) private disciplineRepo: Repository<BoardingDisciplineLog>,
    @InjectRepository(LessonMaterialEntity) private teacherMaterialRepo: Repository<LessonMaterialEntity>,
    @InjectRepository(AnnouncementEntity) private announcementRepo: Repository<AnnouncementEntity>,
    @InjectRepository(LiveSessionEntity) private liveSessionRepo: Repository<LiveSessionEntity>,
    @InjectRepository(AVRecordingEntity) private avRecordingRepo: Repository<AVRecordingEntity>,
    @InjectRepository(SharedResourceEntity) private sharedResourceRepo: Repository<SharedResourceEntity>,
    @InjectRepository(QuizEntity) private quizRepo: Repository<QuizEntity>,
  ) {}

  private async getStudent(userId: string, tenantId: string): Promise<Student> {
    const student = await this.studentRepo.findOne({ where: { id: userId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');
    return student;
  }

  async getProfile(userId: string, tenantId: string) {
    const s = await this.getStudent(userId, tenantId);
    return {
      id: s.id,
      firstName: s.firstName,
      lastName: s.lastName,
      fullName: `${s.firstName} ${s.lastName}`,
      admissionNumber: s.admissionNumber,
      classSection: s.classSectionId,
      house: s.houseId,
      guardianName: s.guardianName,
      guardianPhone: s.guardianPhone,
      photoUrl: s.photoUrl,
      dateOfBirth: s.dateOfBirth,
      gender: s.gender,
      status: s.status,
    };
  }

  async getClasses(userId: string, tenantId: string) {
    return this.classRepo.find({ where: { studentId: userId, tenantId } });
  }

  async getMaterials(userId: string, tenantId: string) {
    return this.materialRepo.find({ where: { studentId: userId, tenantId } });
  }

  async getAssignments(userId: string, tenantId: string) {
    return this.submissionRepo.find({ where: { studentId: userId, tenantId } });
  }

  async submitAssignment(userId: string, tenantId: string, d: dto.SubmitAssignmentDto) {
    const student = await this.getStudent(userId, tenantId);
    const existing = await this.submissionRepo.findOne({
      where: { assignmentId: d.assignmentId, studentId: userId, tenantId },
    });
    if (existing) {
      existing.content = d.content ?? null;
      existing.fileUrl = d.fileUrl ?? null;
      existing.status = 'Submitted';
      existing.submittedAt = new Date();
      return this.submissionRepo.save(existing);
    }
    const sub = this.submissionRepo.create({
      assignmentId: d.assignmentId,
      studentId: userId,
      studentName: `${student.firstName} ${student.lastName}`,
      content: d.content ?? null,
      fileUrl: d.fileUrl ?? null,
      status: 'Submitted',
      submittedAt: new Date(),
      tenantId,
    } as any);
    return this.submissionRepo.save(sub);
  }

  async getResults(userId: string, tenantId: string) {
    return this.resultRepo.find({ where: { studentId: userId, tenantId } });
  }

  async getAttendance(userId: string, tenantId: string) {
    return this.attendanceRepo.find({ where: { studentId: userId, tenantId } });
  }

  async getHealthRecords(userId: string, tenantId: string) {
    return this.healthRepo.find({ where: { studentId: userId, tenantId } });
  }

  async getFeedback(userId: string, tenantId: string) {
    return this.feedbackRepo.find({ where: { studentId: userId, tenantId } });
  }

  async createFeedback(userId: string, tenantId: string, d: dto.CreateFeedbackDto) {
    const student = await this.getStudent(userId, tenantId);
    const fb = this.feedbackRepo.create({
      studentId: userId,
      studentName: `${student.firstName} ${student.lastName}`,
      subject: d.subject,
      body: d.body,
      routedTo: d.routedTo,
      date: new Date().toISOString().slice(0, 10),
      status: 'Submitted',
      tenantId,
    } as any);
    return this.feedbackRepo.save(fb);
  }

  async getFees(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    return { studentName: `${student.firstName} ${student.lastName}`, admissionNumber: student.admissionNumber };
  }

  async getLibrary(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    return { studentName: `${student.firstName} ${student.lastName}` };
  }

  // ── Exeat Requests ──
  async getMyExeats(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    return this.exeatRepo.find({
      where: { admissionNo: student.admissionNumber, tenantId },
      order: { createdAt: 'DESC' },
    });
  }

  async requestExeat(userId: string, tenantId: string, d: dto.RequestExeatDto) {
    const student = await this.getStudent(userId, tenantId);
    const exeatNo = `EXE-${Date.now()}`;
    const record = this.exeatRepo.create({
      exeatNo,
      date: new Date().toISOString().slice(0, 10),
      studentName: `${student.firstName} ${student.lastName}`,
      admissionNo: student.admissionNumber,
      house: student.houseId,
      class: student.classSectionId,
      reason: d.reason,
      reasonDetail: d.reasonDetail || '',
      destination: d.destination || null,
      departureDate: d.departureDate,
      returnDate: d.returnDate,
      guardianName: student.guardianName,
      guardianPhone: student.guardianPhone,
      transportMode: d.transportMode || null,
      status: 'Pending',
      issuedBy: `${student.firstName} ${student.lastName}`,
      tenantId,
    });
    return this.exeatRepo.save(record);
  }

  // ── Teacher Content (filtered by student's class) ──
  async getTeacherAnnouncements(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    const all = await this.announcementRepo.find({
      where: { tenantId },
      order: { createdAt: 'DESC' },
    });
    return all.filter((a) => a.classForm === student.classSectionId || a.classForm === 'All' || a.classForm === 'General');
  }

  async getTeacherMaterials(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    const all = await this.teacherMaterialRepo.find({
      where: { tenantId },
      order: { createdAt: 'DESC' },
    });
    return all.filter((m) => m.classForm === student.classSectionId || m.classForm === 'All' || m.classForm === 'General');
  }

  async getLiveSessions(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    const all = await this.liveSessionRepo.find({
      where: { tenantId },
      order: { createdAt: 'DESC' },
    });
    return all.filter((s) => s.classForm === student.classSectionId || s.classForm === 'All' || s.classForm === 'General');
  }

  async getAVRecordings(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    const all = await this.avRecordingRepo.find({
      where: { tenantId },
      order: { createdAt: 'DESC' },
    });
    return all.filter((r) => r.classForm === student.classSectionId || r.classForm === 'All' || r.classForm === 'General');
  }

  async getSharedResources(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    const all = await this.sharedResourceRepo.find({
      where: { tenantId },
      order: { createdAt: 'DESC' },
    });
    return all.filter((r) => r.classForm === student.classSectionId || r.classForm === 'All' || r.classForm === 'General');
  }

  async getQuizzes(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    const all = await this.quizRepo.find({
      where: { tenantId, status: 'Published' },
      order: { createdAt: 'DESC' },
    });
    return all.filter((q) => q.classForm === student.classSectionId || q.classForm === 'All' || q.classForm === 'General');
  }

  // ── House Info ──
  async getHouseRollCalls(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    if (!student.houseId) return [];
    return this.rollCallRepo.find({
      where: { house: student.houseId, tenantId },
      order: { date: 'DESC' },
      take: 20,
    });
  }

  async getHouseDiscipline(userId: string, tenantId: string) {
    const student = await this.getStudent(userId, tenantId);
    if (!student.houseId) return [];
    const all = await this.disciplineRepo.find({
      where: { tenantId },
      order: { date: 'DESC' },
    });
    return all.filter((d) => d.house === student.houseId || d.studentName === `${student.firstName} ${student.lastName}`).slice(0, 20);
  }

  // ── Student Messages (to parent/teacher/admin) ──
  async getMessages(userId: string, tenantId: string) {
    return this.messageRepo.find({
      where: { studentId: userId, tenantId },
      order: { createdAt: 'DESC' },
    });
  }

  async createMessage(userId: string, tenantId: string, d: dto.CreateStudentMessageDto) {
    const student = await this.getStudent(userId, tenantId);
    const msg = this.messageRepo.create({
      studentId: userId,
      studentName: `${student.firstName} ${student.lastName}`,
      admissionNo: student.admissionNumber,
      recipientType: d.recipientType,
      recipientName: d.recipientName || (d.recipientType === 'parent' ? student.guardianName : ''),
      subject: d.subject,
      body: d.body,
      status: 'Sent',
      tenantId,
    } as any);
    return this.messageRepo.save(msg);
  }
}
