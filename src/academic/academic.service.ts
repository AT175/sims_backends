import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TimetableEntry } from './timetable-entry.entity';
import { ExamResult } from './exam-result.entity';
import { AttendanceRecord } from './attendance-record.entity';
import { CreateTimetableEntryDto, CreateExamResultDto, CreateAttendanceDto } from './academic.dto';

@Injectable()
export class AcademicService {
  constructor(
    @InjectRepository(TimetableEntry)
    private readonly timetableRepo: Repository<TimetableEntry>,
    @InjectRepository(ExamResult)
    private readonly resultRepo: Repository<ExamResult>,
    @InjectRepository(AttendanceRecord)
    private readonly attendanceRepo: Repository<AttendanceRecord>,
  ) {}

  // Timetable
  async getTimetable(classSection: string | undefined, tenantId: string): Promise<TimetableEntry[]> {
    const where: any = { tenantId };
    if (classSection) where.classSection = classSection;
    return this.timetableRepo.find({ where, order: { day: 'ASC', startTime: 'ASC' } });
  }

  async createTimetableEntry(dto: CreateTimetableEntryDto, tenantId: string): Promise<TimetableEntry> {
    const entry = this.timetableRepo.create({ ...dto, tenantId });
    return this.timetableRepo.save(entry);
  }

  // Exam Results
  async getResults(studentName: string | undefined, term: string | undefined, tenantId: string): Promise<ExamResult[]> {
    const where: any = { tenantId };
    if (studentName) where.studentName = studentName;
    if (term) where.term = term;
    return this.resultRepo.find({ where, order: { createdAt: 'DESC' } });
  }

  async createResult(dto: CreateExamResultDto, tenantId: string): Promise<ExamResult> {
    const entry = this.resultRepo.create({ ...dto, tenantId });
    return this.resultRepo.save(entry);
  }

  // Attendance
  async getAttendance(studentName: string | undefined, date: string | undefined, tenantId: string): Promise<AttendanceRecord[]> {
    const where: any = { tenantId };
    if (studentName) where.studentName = studentName;
    if (date) where.date = date;
    return this.attendanceRepo.find({ where, order: { date: 'DESC' } });
  }

  async createAttendance(dto: CreateAttendanceDto, tenantId: string): Promise<AttendanceRecord> {
    const entry = this.attendanceRepo.create({ ...dto, tenantId });
    return this.attendanceRepo.save(entry);
  }
}
