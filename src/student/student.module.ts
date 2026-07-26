import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { HealthRecord } from './entities/health-record.entity';
import { StudentFeedback } from './entities/student-feedback.entity';
import { AssignmentSubmission } from './entities/assignment-submission.entity';
import { StudentAttendance } from './entities/student-attendance.entity';
import { StudentResult } from './entities/student-result.entity';
import { StudentMaterial } from './entities/student-material.entity';
import { StudentClass } from './entities/student-class.entity';
import { Student } from '../students/student.entity';
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
      Student,
    ]),
  ],
  providers: [StudentService],
  controllers: [StudentController],
  exports: [StudentService],
})
export class StudentModule {}
