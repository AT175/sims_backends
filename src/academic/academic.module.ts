import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TimetableEntry } from './timetable-entry.entity';
import { ExamResult } from './exam-result.entity';
import { AttendanceRecord } from './attendance-record.entity';
import { AcademicService } from './academic.service';
import { AcademicController } from './academic.controller';

@Module({
  imports: [TypeOrmModule.forFeature([TimetableEntry, ExamResult, AttendanceRecord])],
  providers: [AcademicService],
  controllers: [AcademicController],
})
export class AcademicModule {}
