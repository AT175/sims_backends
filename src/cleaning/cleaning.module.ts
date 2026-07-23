import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CleaningTask } from './cleaning-task.entity';
import { MaintenanceIssue } from './maintenance-issue.entity';
import { CleaningService } from './cleaning.service';
import { CleaningController } from './cleaning.controller';

@Module({
  imports: [TypeOrmModule.forFeature([CleaningTask, MaintenanceIssue])],
  providers: [CleaningService],
  controllers: [CleaningController],
})
export class CleaningModule {}
