import { Module } from '@nestjs/common';
import { ExamCommitteeController } from './exam-committee.controller';
import { ExamCommitteeService } from './exam-committee.service';

@Module({ controllers: [ExamCommitteeController], providers: [ExamCommitteeService] })
export class ExamCommitteeModule {}
