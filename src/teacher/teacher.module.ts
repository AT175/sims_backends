import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LessonPlanEntity } from './entities/lesson-plan.entity';
import { AssignmentEntity } from './entities/assignment.entity';
import { GradebookEntryEntity } from './entities/gradebook-entry.entity';
import { TeacherAttendanceEntity } from './entities/teacher-attendance.entity';
import { SyllabusTopicEntity } from './entities/syllabus-topic.entity';
import { LessonMaterialEntity } from './entities/lesson-material.entity';
import { AVRecordingEntity } from './entities/av-recording.entity';
import { LiveSessionEntity } from './entities/live-session.entity';
import { AnnouncementEntity } from './entities/announcement.entity';
import { QuestionBankEntity } from './entities/question-bank.entity';
import { QuizEntity } from './entities/quiz.entity';
import { ParentCommEntity } from './entities/parent-comm.entity';
import { BehaviorNoteEntity } from './entities/behavior-note.entity';
import { CalendarEventEntity } from './entities/calendar-event.entity';
import { SharedResourceEntity } from './entities/shared-resource.entity';
import { TeacherNotificationEntity } from './entities/teacher-notification.entity';
import { RemedialStudentEntity } from './entities/remedial-student.entity';
import { TeacherService } from './teacher.service';
import { TeacherController } from './teacher.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      LessonPlanEntity,
      AssignmentEntity,
      GradebookEntryEntity,
      TeacherAttendanceEntity,
      SyllabusTopicEntity,
      LessonMaterialEntity,
      AVRecordingEntity,
      LiveSessionEntity,
      AnnouncementEntity,
      QuestionBankEntity,
      QuizEntity,
      ParentCommEntity,
      BehaviorNoteEntity,
      CalendarEventEntity,
      SharedResourceEntity,
      TeacherNotificationEntity,
      RemedialStudentEntity,
    ]),
  ],
  providers: [TeacherService],
  controllers: [TeacherController],
})
export class TeacherModule {}
