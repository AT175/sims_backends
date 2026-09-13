import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Student } from '../students/student.entity';
import { LessonRecapEntity } from '../teacher/entities/lesson-recap.entity';
import { FeeRecord } from '../bursary/fee-record.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { AttendanceRecord } from '../academic/attendance-record.entity';
import { LANGUAGES, TEMPLATES } from './translations';

@Injectable()
export class VoiceService {
  constructor(
    @InjectRepository(Student) private studentRepo: Repository<Student>,
    @InjectRepository(LessonRecapEntity) private recapRepo: Repository<LessonRecapEntity>,
    @InjectRepository(FeeRecord) private feeRepo: Repository<FeeRecord>,
    @InjectRepository(ExamResult) private examRepo: Repository<ExamResult>,
    @InjectRepository(AttendanceRecord) private attendanceRepo: Repository<AttendanceRecord>,
  ) {}

  getLanguages() {
    return LANGUAGES;
  }

  getTemplates() {
    return Object.keys(TEMPLATES);
  }

  private fillTemplate(template: string, data: Record<string, string>): string {
    return template.replace(/\{(\w+)\}/g, (_, key) => data[key] || '');
  }

  async getLocalizedMessage(template: string, language: string, studentId: string, tenantId: string) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const tmpl = TEMPLATES[template];
    if (!tmpl) throw new NotFoundException(`Template '${template}' not found`);
    const text = tmpl[language] || tmpl['English'];

    const data: Record<string, string> = {
      studentName: `${student.firstName} ${student.lastName}`,
      admissionNumber: student.admissionNumber,
    };

    if (template === 'lesson_recap') {
      const recaps = await this.recapRepo.find({
        where: { tenantId, classForm: student.classSectionId },
        order: { date: 'DESC' },
        take: 1,
      });
      if (recaps.length > 0) {
        const r = recaps[0];
        data.subject = r.subject;
        data.topic = r.topic;
        data.date = r.date;
        data.keyPoints = r.keyPoints || '';
        data.activitiesDone = r.activitiesDone || '';
        data.homework = r.homework || '';
        data.nextLessonPreview = r.nextLessonPreview || '';
      }
    } else if (template === 'fee_reminder') {
      const fees = await this.feeRepo.find({ where: { tenantId, admNo: student.admissionNumber, status: 'Owing' as any } });
      const total = fees.reduce((s, f) => s + Number(f.balance), 0);
      data.balance = total.toFixed(2);
    } else if (template === 'attendance_alert') {
      const records = await this.attendanceRepo.find({
        where: { tenantId, admNo: student.admissionNumber },
        order: { date: 'DESC' },
        take: 10,
      });
      const absences = records.filter((r) => r.status === 'Absent');
      data.dates = absences.map((a) => a.date).join(', ') || 'No recent absences';
    } else if (template === 'result_notification') {
      const results = await this.examRepo.find({
        where: { tenantId, admNo: student.admissionNumber },
        order: { createdAt: 'DESC' },
        take: 10,
      });
      data.term = results[0]?.term || 'Current Term';
      data.results = results.map((r) => `${r.subject}: ${r.marks}% (${r.grade || 'N/A'})`).join('\n');
    }

    return {
      language,
      template,
      text: this.fillTemplate(text, data),
      studentName: data.studentName,
    };
  }
}
