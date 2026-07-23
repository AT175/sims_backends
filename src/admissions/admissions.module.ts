import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdmissionApplication } from './admission-application.entity';
import { AdmissionsService } from './admissions.service';
import { AdmissionsController } from './admissions.controller';

@Module({
  imports: [TypeOrmModule.forFeature([AdmissionApplication])],
  providers: [AdmissionsService],
  controllers: [AdmissionsController],
  exports: [AdmissionsService],
})
export class AdmissionsModule {}
