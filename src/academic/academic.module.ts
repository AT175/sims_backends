import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TimetableEntry } from './timetable-entry.entity';
import { ExamResult } from './exam-result.entity';
import { AttendanceRecord } from './attendance-record.entity';
import { PromotionConfig } from './promotion-config.entity';
import { PromotionRecord } from './promotion-record.entity';
import { Student } from '../students/student.entity';
import { AcademicService } from './academic.service';
import { AcademicController } from './academic.controller';
import { PromotionService } from './promotion.service';
import { PromotionController } from './promotion.controller';

@Module({
  imports: [TypeOrmModule.forFeature([TimetableEntry, ExamResult, AttendanceRecord, PromotionConfig, PromotionRecord, Student])],
  providers: [AcademicService, PromotionService],
  controllers: [AcademicController, PromotionController],
})
export class AcademicModule {}
