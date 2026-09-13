import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { InvestorEntity } from './investor.entity';
import { Tenant } from '../tenants/tenant.entity';
import { User } from '../auth/user.entity';
import { SubscriptionEntity } from '../subscription/subscription.entity';
import { Student } from '../students/student.entity';
import { FeeRecord } from '../bursary/fee-record.entity';
import { InvestorService } from './investor.service';
import { InvestorController } from './investor.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      InvestorEntity, Tenant, User, SubscriptionEntity, Student, FeeRecord,
    ]),
  ],
  providers: [InvestorService],
  controllers: [InvestorController],
  exports: [InvestorService],
})
export class InvestorModule {}
