import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdmissionApplication } from './admission-application.entity';
import { AdmissionsService } from './admissions.service';
import { AdmissionsController } from './admissions.controller';
import { User } from '../auth/user.entity';
import { SubscriptionModule } from '../subscription/subscription.module';

@Module({
  imports: [TypeOrmModule.forFeature([AdmissionApplication, User]), SubscriptionModule],
  providers: [AdmissionsService],
  controllers: [AdmissionsController],
  exports: [AdmissionsService],
})
export class AdmissionsModule {}
