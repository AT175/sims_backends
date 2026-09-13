import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CareerProfileEntity } from './career-profile.entity';
import { Student } from '../students/student.entity';
import { ExamResult } from '../academic/exam-result.entity';
import { CareerService } from './career.service';
import { CareerController } from './career.controller';

@Module({
  imports: [TypeOrmModule.forFeature([CareerProfileEntity, Student, ExamResult])],
  providers: [CareerService],
  controllers: [CareerController],
  exports: [CareerService],
})
export class CareerModule {}
