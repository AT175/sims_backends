import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DropoutAlertEntity } from './dropout-alert.entity';
import { Student } from '../students/student.entity';
import { AttendanceRecord } from '../academic/attendance-record.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { FeeRecord } from '../bursary/fee-record.entity';
import { CounsellingCase } from '../counselling/counselling-case.entity';
import { LessonPlanEntity } from '../teacher/entities/lesson-plan.entity';
import { AssignmentEntity } from '../teacher/entities/assignment.entity';
import { QuizEntity } from '../teacher/entities/quiz.entity';
import { GradebookEntryEntity } from '../teacher/entities/gradebook-entry.entity';
import { TeacherAttendanceEntity } from '../teacher/entities/teacher-attendance.entity';
import { LessonRecapEntity } from '../teacher/entities/lesson-recap.entity';
import { DropoutPredictionService } from './dropout-prediction.service';
import { DropoutPredictionController } from './dropout-prediction.controller';
import { TeacherAnalyticsService } from './teacher-analytics.service';
import { TeacherAnalyticsController } from './teacher-analytics.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      DropoutAlertEntity, Student, AttendanceRecord, ExamResult, FeeRecord, CounsellingCase,
      LessonPlanEntity, AssignmentEntity, QuizEntity, GradebookEntryEntity,
      TeacherAttendanceEntity, LessonRecapEntity,
    ]),
  ],
  providers: [DropoutPredictionService, TeacherAnalyticsService],
  controllers: [DropoutPredictionController, TeacherAnalyticsController],
  exports: [DropoutPredictionService, TeacherAnalyticsService],
})
export class AnalyticsModule {}
