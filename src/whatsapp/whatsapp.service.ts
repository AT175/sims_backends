import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Student } from '../students/student.entity';
import { LessonRecapEntity } from '../teacher/entities/lesson-recap.entity';
import { FeeRecord } from '../bursary/fee-record.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { AttendanceRecord } from '../academic/attendance-record.entity';

function normalizePhone(phone: string): string {
  // Remove spaces, dashes, leading 0; add Ghana country code 233
  let p = phone.replace(/[\s-]/g, '');
  if (p.startsWith('0')) p = '233' + p.slice(1);
  else if (p.startsWith('+')) p = p.slice(1);
  else if (!p.startsWith('233') && p.length === 9) p = '233' + p;
  return p;
}

function waLink(phone: string, message: string): string {
  const p = normalizePhone(phone);
  return `https://wa.me/${p}?text=${encodeURIComponent(message)}`;
}

@Injectable()
export class WhatsappService {
  constructor(
    @InjectRepository(Student) private studentRepo: Repository<Student>,
    @InjectRepository(LessonRecapEntity) private recapRepo: Repository<LessonRecapEntity>,
    @InjectRepository(FeeRecord) private feeRepo: Repository<FeeRecord>,
    @InjectRepository(ExamResult) private examRepo: Repository<ExamResult>,
    @InjectRepository(AttendanceRecord) private attendanceRepo: Repository<AttendanceRecord>,
  ) {}

  async getRecapLink(studentId: string, tenantId: string) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const recaps = await this.recapRepo.find({
      where: { tenantId, classForm: student.classSectionId },
      order: { date: 'DESC' },
      take: 3,
    });

    if (recaps.length === 0) return { link: null, message: 'No lesson recaps available.' };

    let msg = `*Daily Lesson Recap — ${student.firstName} ${student.lastName}*\n`;
    msg += `School: ${tenantId}\n\n`;
    for (const r of recaps) {
      msg += `📚 *${r.subject}: ${r.topic}*\n`;
      msg += `📅 ${r.date} | Week ${r.week} | ${r.term}\n`;
      if (r.keyPoints) msg += `🔑 Key Points: ${r.keyPoints}\n`;
      if (r.activitiesDone) msg += `🎯 Activities: ${r.activitiesDone}\n`;
      if (r.homework) msg += `📝 Homework: ${r.homework}\n`;
      if (r.nextLessonPreview) msg += `➡️ Next: ${r.nextLessonPreview}\n`;
      msg += `\n`;
    }

    return { link: waLink(student.guardianPhone, msg), message: msg, student: { name: `${student.firstName} ${student.lastName}`, guardianPhone: student.guardianPhone } };
  }

  async getFeeReminderLink(studentId: string, tenantId: string) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const fees = await this.feeRepo.find({ where: { tenantId, admNo: student.admissionNumber, status: 'Owing' as any } });
    if (fees.length === 0) return { link: null, message: 'No outstanding fees.' };

    let msg = `*Fee Reminder — ${student.firstName} ${student.lastName}*\n`;
    msg += `Admission No: ${student.admissionNumber}\n\n`;
    let total = 0;
    for (const f of fees) {
      msg += `💳 ${f.feeType} (${f.term}): Balance GHS ${f.balance}\n`;
      total += Number(f.balance);
    }
    msg += `\n*Total Outstanding: GHS ${total.toFixed(2)}*\n`;
    msg += `Please make payment at your earliest convenience.\n`;
    msg += `Thank you.`;

    return { link: waLink(student.guardianPhone, msg), message: msg, totalOutstanding: total };
  }

  async getAttendanceAlertLink(studentId: string, tenantId: string) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const records = await this.attendanceRepo.find({
      where: { tenantId, admNo: student.admissionNumber },
      order: { date: 'DESC' },
      take: 10,
    });
    const absences = records.filter((r) => r.status === 'Absent');

    if (absences.length === 0) return { link: null, message: 'No recent absences.' };

    let msg = `*Attendance Alert — ${student.firstName} ${student.lastName}*\n`;
    msg += `Your child has been absent on the following dates:\n\n`;
    for (const a of absences) {
      msg += `❌ ${a.date} — ${a.remarks || 'No reason provided'}\n`;
    }
    msg += `\nPlease contact the school if there are any issues.`;

    return { link: waLink(student.guardianPhone, msg), message: msg, absenceCount: absences.length };
  }

  async getResultLink(studentId: string, tenantId: string, term?: string) {
    const student = await this.studentRepo.findOne({ where: { id: studentId, tenantId } });
    if (!student) throw new NotFoundException('Student not found');

    const where: any = { tenantId, admNo: student.admissionNumber };
    if (term) where.term = term;
    const results = await this.examRepo.find({ where, order: { createdAt: 'DESC' } });

    if (results.length === 0) return { link: null, message: 'No results available.' };

    let msg = `*Exam Results — ${student.firstName} ${student.lastName}*\n`;
    msg += `Term: ${results[0].term}\n\n`;
    for (const r of results) {
      msg += `📖 ${r.subject}: ${r.marks}% — Grade ${r.grade || 'N/A'}\n`;
    }
    msg += `\nPlease review these results with your child.`;

    return { link: waLink(student.guardianPhone, msg), message: msg };
  }

  async getBulkFeeReminderLinks(tenantId: string) {
    const fees = await this.feeRepo.find({ where: { tenantId, status: 'Owing' as any } });
    const studentMap = new Map<string, { name: string; phone: string; balance: number }>();

    for (const f of fees) {
      const student = await this.studentRepo.findOne({ where: { tenantId, admissionNumber: f.admNo } });
      if (!student) continue;
      const existing = studentMap.get(f.admNo);
      if (existing) {
        existing.balance += Number(f.balance);
      } else {
        studentMap.set(f.admNo, {
          name: `${student.firstName} ${student.lastName}`,
          phone: student.guardianPhone,
          balance: Number(f.balance),
        });
      }
    }

    const links = Array.from(studentMap.entries()).map(([admNo, data]) => {
      const msg = `*Fee Reminder — ${data.name}*\nAdmission No: ${admNo}\nOutstanding Balance: GHS ${data.balance.toFixed(2)}\n\nPlease make payment to avoid disruption of your child's education.\nThank you.`;
      return { admNo, name: data.name, link: waLink(data.phone, msg), balance: data.balance };
    });

    return { links, totalStudents: links.length, totalOutstanding: links.reduce((s, l) => s + l.balance, 0) };
  }
}
