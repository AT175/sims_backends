import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PromotionConfig } from './promotion-config.entity';
import { PromotionRecord } from './promotion-record.entity';
import { ExamResult } from './exam-result.entity';
import { Student } from '../students/student.entity';

const SHS_LEVELS = ['SHS1', 'SHS2', 'SHS3'];
const GRADUATION_LEVEL = 'SHS3';

@Injectable()
export class PromotionService {
  constructor(
    @InjectRepository(PromotionConfig)
    private readonly configRepo: Repository<PromotionConfig>,
    @InjectRepository(PromotionRecord)
    private readonly recordRepo: Repository<PromotionRecord>,
    @InjectRepository(ExamResult)
    private readonly resultRepo: Repository<ExamResult>,
    @InjectRepository(Student)
    private readonly studentRepo: Repository<Student>,
  ) {}

  // ── Config ──
  async getConfig(tenantId: string): Promise<PromotionConfig> {
    let config = await this.configRepo.findOne({ where: { tenantId } });
    if (!config) {
      config = this.configRepo.create({ tenantId });
      config = await this.configRepo.save(config);
    }
    return config;
  }

  async updateConfig(tenantId: string, dto: Partial<PromotionConfig>): Promise<PromotionConfig> {
    let config = await this.getConfig(tenantId);
    Object.assign(config, dto);
    return this.configRepo.save(config);
  }

  // ── Student averages ──
  async getStudentAverages(level: string, tenantId: string): Promise<any[]> {
    const students = await this.studentRepo.find({
      where: { tenantId, deletedAt: null as any, status: 'active' as any },
    });

    const levelStudents = students.filter((s) => s.classSectionId === level);

    const results = await this.resultRepo.find({ where: { tenantId } });

    const studentAverages: any[] = [];
    for (const student of levelStudents) {
      const studentResults = results.filter((r) => r.admNo === student.admissionNumber);
      if (studentResults.length === 0) {
        studentAverages.push({
          studentId: student.id,
          admissionNumber: student.admissionNumber,
          studentName: `${student.firstName} ${student.lastName}`,
          currentLevel: student.classSectionId,
          overallAverage: 0,
          subjectCount: 0,
          hasResults: false,
        });
        continue;
      }
      const totalMarks = studentResults.reduce((sum, r) => sum + Number(r.marks), 0);
      const average = totalMarks / studentResults.length;
      studentAverages.push({
        studentId: student.id,
        admissionNumber: student.admissionNumber,
        studentName: `${student.firstName} ${student.lastName}`,
        currentLevel: student.classSectionId,
        overallAverage: Math.round(average * 100) / 100,
        subjectCount: studentResults.length,
        hasResults: true,
      });
    }

    return studentAverages.sort((a, b) => b.overallAverage - a.overallAverage);
  }

  // ── Promotion list ──
  async getPromotionList(level: string, tenantId: string): Promise<any> {
    const config = await this.getConfig(tenantId);
    if (!config.enabled) {
      return { enabled: false, students: [], promotionAverage: config.promotionAverage };
    }

    const students = await this.getStudentAverages(level, tenantId);
    const promotable = students.filter(
      (s) => s.hasResults && Number(s.overallAverage) >= Number(config.promotionAverage),
    );
    const repeatable = students.filter(
      (s) => s.hasResults && Number(s.overallAverage) < Number(config.promotionAverage),
    );

    return {
      enabled: true,
      level,
      promotionAverage: Number(config.promotionAverage),
      repeatAverage: Number(config.repeatAverage),
      promotable,
      repeatable,
      noResults: students.filter((s) => !s.hasResults),
    };
  }

  // ── Promote a single student ──
  async promoteStudent(studentId: string, tenantId: string, performedBy: string): Promise<any> {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new BadRequestException('Student not found');

    const currentLevel = student.classSectionId;
    if (!SHS_LEVELS.includes(currentLevel)) {
      throw new BadRequestException(`Invalid level: ${currentLevel}`);
    }

    const levelIdx = SHS_LEVELS.indexOf(currentLevel);
    const nextLevel = SHS_LEVELS[levelIdx + 1];
    if (!nextLevel) {
      throw new BadRequestException('Student is already at the highest level. Use graduation instead.');
    }

    const config = await this.getConfig(tenantId);
    const results = await this.resultRepo.find({ where: { tenantId, admNo: student.admissionNumber } });
    const totalMarks = results.reduce((sum, r) => sum + Number(r.marks), 0);
    const average = results.length > 0 ? totalMarks / results.length : 0;

    if (Number(average) < Number(config.promotionAverage)) {
      throw new BadRequestException(
        `Student average (${average.toFixed(2)}) is below promotion threshold (${config.promotionAverage})`,
      );
    }

    student.classSectionId = nextLevel;
    await this.studentRepo.save(student);

    const record = this.recordRepo.create({
      tenantId,
      studentId: student.id,
      admissionNumber: student.admissionNumber,
      studentName: `${student.firstName} ${student.lastName}`,
      fromLevel: currentLevel,
      toLevel: nextLevel,
      overallAverage: Math.round(average * 100) / 100,
      action: 'promoted',
      performedBy,
    });
    await this.recordRepo.save(record);

    return { student, record, message: `Promoted from ${currentLevel} to ${nextLevel}` };
  }

  // ── Promote all eligible students in a level ──
  async promoteAll(level: string, tenantId: string, performedBy: string): Promise<any> {
    const config = await this.getConfig(tenantId);
    if (!config.enabled) throw new BadRequestException('Promotion is not enabled');

    const students = await this.getStudentAverages(level, tenantId);
    const promotable = students.filter(
      (s) => s.hasResults && Number(s.overallAverage) >= Number(config.promotionAverage),
    );

    const results: any[] = [];
    for (const s of promotable) {
      try {
        const result = await this.promoteStudent(s.studentId, tenantId, performedBy);
        results.push({ studentId: s.studentId, studentName: s.studentName, success: true, message: result.message });
      } catch (err: any) {
        results.push({ studentId: s.studentId, studentName: s.studentName, success: false, message: err.message });
      }
    }

    return { promoted: results.filter((r) => r.success).length, failed: results.filter((r) => !r.success).length, details: results };
  }

  // ── Repeat a student (keep in same level) ──
  async repeatStudent(studentId: string, tenantId: string, performedBy: string): Promise<any> {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new BadRequestException('Student not found');

    const currentLevel = student.classSectionId;

    const results = await this.resultRepo.find({ where: { tenantId, admNo: student.admissionNumber } });
    const totalMarks = results.reduce((sum, r) => sum + Number(r.marks), 0);
    const average = results.length > 0 ? totalMarks / results.length : 0;

    const record = this.recordRepo.create({
      tenantId,
      studentId: student.id,
      admissionNumber: student.admissionNumber,
      studentName: `${student.firstName} ${student.lastName}`,
      fromLevel: currentLevel,
      toLevel: currentLevel,
      overallAverage: Math.round(average * 100) / 100,
      action: 'repeated',
      performedBy,
    });
    await this.recordRepo.save(record);

    student.status = 'repeated';
    await this.studentRepo.save(student);

    return { student, record, message: `Student marked as repeating ${currentLevel}` };
  }

  // ── Graduate a student ──
  async graduateStudent(studentId: string, tenantId: string, performedBy: string): Promise<any> {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new BadRequestException('Student not found');

    if (student.classSectionId !== GRADUATION_LEVEL) {
      throw new BadRequestException(`Student must be in ${GRADUATION_LEVEL} to graduate. Current level: ${student.classSectionId}`);
    }

    const results = await this.resultRepo.find({ where: { tenantId, admNo: student.admissionNumber } });
    const totalMarks = results.reduce((sum, r) => sum + Number(r.marks), 0);
    const average = results.length > 0 ? totalMarks / results.length : 0;

    const record = this.recordRepo.create({
      tenantId,
      studentId: student.id,
      admissionNumber: student.admissionNumber,
      studentName: `${student.firstName} ${student.lastName}`,
      fromLevel: student.classSectionId,
      toLevel: 'Graduated',
      overallAverage: Math.round(average * 100) / 100,
      action: 'graduated',
      performedBy,
    });
    await this.recordRepo.save(record);

    student.status = 'graduated';
    await this.studentRepo.save(student);

    return { student, record, message: `Student ${student.firstName} ${student.lastName} has graduated` };
  }

  // ── Graduate all eligible ──
  async graduateAll(tenantId: string, performedBy: string): Promise<any> {
    const students = await this.studentRepo.find({
      where: { tenantId, deletedAt: null as any, status: 'active' as any, classSectionId: GRADUATION_LEVEL },
    });

    const results: any[] = [];
    for (const s of students) {
      try {
        const result = await this.graduateStudent(s.id, tenantId, performedBy);
        results.push({ studentId: s.id, studentName: `${s.firstName} ${s.lastName}`, success: true, message: result.message });
      } catch (err: any) {
        results.push({ studentId: s.id, studentName: `${s.firstName} ${s.lastName}`, success: false, message: err.message });
      }
    }

    return { graduated: results.filter((r) => r.success).length, failed: results.filter((r) => !r.success).length, details: results };
  }

  // ── Graduation list ──
  async getGraduationList(tenantId: string): Promise<any> {
    const students = await this.studentRepo.find({
      where: { tenantId, deletedAt: null as any, status: 'active' as any, classSectionId: GRADUATION_LEVEL },
    });

    const results = await this.resultRepo.find({ where: { tenantId } });

    const gradList: any[] = [];
    for (const student of students) {
      const studentResults = results.filter((r) => r.admNo === student.admissionNumber);
      const totalMarks = studentResults.reduce((sum, r) => sum + Number(r.marks), 0);
      const average = studentResults.length > 0 ? totalMarks / studentResults.length : 0;
      gradList.push({
        studentId: student.id,
        admissionNumber: student.admissionNumber,
        studentName: `${student.firstName} ${student.lastName}`,
        currentLevel: student.classSectionId,
        overallAverage: Math.round(average * 100) / 100,
        subjectCount: studentResults.length,
        hasResults: studentResults.length > 0,
      });
    }

    return gradList.sort((a, b) => b.overallAverage - a.overallAverage);
  }

  // ── Promotion history ──
  async getHistory(tenantId: string): Promise<PromotionRecord[]> {
    return this.recordRepo.find({
      where: { tenantId },
      order: { createdAt: 'DESC' },
    });
  }
}
