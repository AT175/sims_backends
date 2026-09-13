import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Student } from '../students/student.entity';
import { LessonRecapEntity } from '../teacher/entities/lesson-recap.entity';
import { FeeRecord } from '../bursary/fee-record.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { AttendanceRecord } from '../academic/attendance-record.entity';
import { VoiceService } from './voice.service';
import { VoiceController } from './voice.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Student, LessonRecapEntity, FeeRecord, ExamResult, AttendanceRecord])],
  providers: [VoiceService],
  controllers: [VoiceController],
  exports: [VoiceService],
})
export class VoiceModule {}
