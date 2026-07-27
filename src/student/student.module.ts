import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HealthRecord } from './entities/health-record.entity';
import { StudentFeedback } from './entities/student-feedback.entity';
import { AssignmentSubmission } from './entities/assignment-submission.entity';
import { StudentAttendance } from './entities/student-attendance.entity';
import { StudentResult } from './entities/student-result.entity';
import { StudentMaterial } from './entities/student-material.entity';
import { StudentClass } from './entities/student-class.entity';
import { StudentMessage } from './entities/student-message.entity';
import { Student } from '../students/student.entity';
import { ExeatRecord } from '../boarding/exeat-record.entity';
import { RollCallEntry } from '../boarding/roll-call-entry.entity';
import { BoardingDisciplineLog } from '../boarding/discipline-log.entity';
import { LessonMaterialEntity } from '../teacher/entities/lesson-material.entity';
import { AnnouncementEntity } from '../teacher/entities/announcement.entity';
import { LiveSessionEntity } from '../teacher/entities/live-session.entity';
import { AVRecordingEntity } from '../teacher/entities/av-recording.entity';
import { SharedResourceEntity } from '../teacher/entities/shared-resource.entity';
import { QuizEntity } from '../teacher/entities/quiz.entity';
import { StudentService } from './student.service';
import { StudentController } from './student.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      HealthRecord,
      StudentFeedback,
      AssignmentSubmission,
      StudentAttendance,
      StudentResult,
      StudentMaterial,
      StudentClass,
      StudentMessage,
      Student,
      ExeatRecord,
      RollCallEntry,
      BoardingDisciplineLog,
      LessonMaterialEntity,
      AnnouncementEntity,
      LiveSessionEntity,
      AVRecordingEntity,
      SharedResourceEntity,
      QuizEntity,
    ]),
  ],
  providers: [StudentService],
  controllers: [StudentController],
  exports: [StudentService],
})
export class StudentModule {}
