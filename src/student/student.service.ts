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
import { Student } from '../students/student.entity';
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
    @InjectRepository(Student) private studentRepo: Repository<Student>,
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
}
