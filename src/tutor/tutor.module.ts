import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TutorSessionEntity } from './tutor-session.entity';
import { Student } from '../students/student.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { TutorService } from './tutor.service';
import { TutorController } from './tutor.controller';

@Module({
  imports: [TypeOrmModule.forFeature([TutorSessionEntity, Student, ExamResult])],
  providers: [TutorService],
  controllers: [TutorController],
  exports: [TutorService],
})
export class TutorModule {}
