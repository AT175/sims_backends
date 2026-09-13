import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SyncService } from './sync.service';
import { SyncController } from './sync.controller';
import { TenantsModule } from '../tenants/tenants.module';
import { Student } from '../students/student.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { AttendanceRecord } from '../academic/attendance-record.entity';
import { FeeRecord } from '../bursary/fee-record.entity';
import { LessonPlanEntity } from '../teacher/entities/lesson-plan.entity';
import { AssignmentEntity } from '../teacher/entities/assignment.entity';
import { LessonRecapEntity } from '../teacher/entities/lesson-recap.entity';
import { GradebookEntryEntity } from '../teacher/entities/gradebook-entry.entity';
import { BehaviorNoteEntity } from '../teacher/entities/behavior-note.entity';
import { CounsellingCase } from '../counselling/counselling-case.entity';

@Module({
  imports: [
    TenantsModule,
    TypeOrmModule.forFeature([
      Student, ExamResult, AttendanceRecord, FeeRecord,
      LessonPlanEntity, AssignmentEntity, LessonRecapEntity,
      GradebookEntryEntity, BehaviorNoteEntity, CounsellingCase,
    ]),
  ],
  providers: [SyncService],
  controllers: [SyncController],
  exports: [SyncService],
})
export class SyncModule {}
