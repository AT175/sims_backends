import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SubscriptionEntity } from './subscription.entity';
import { SubscriptionService } from './subscription.service';
import { SubscriptionController } from './subscription.controller';
import { EarningEntity } from './earning.entity';
import { EarningConfigEntity } from './earning-config.entity';
import { EarningsService } from './earnings.service';
import { EarningsController } from './earnings.controller';

@Module({
  imports: [TypeOrmModule.forFeature([SubscriptionEntity, EarningEntity, EarningConfigEntity])],
  providers: [SubscriptionService, EarningsService],
  controllers: [SubscriptionController, EarningsController],
  exports: [SubscriptionService, EarningsService],
})
export class SubscriptionModule {}
