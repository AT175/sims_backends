import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PrayerRequest } from './prayer-request.entity';
import { SpiritualCounselling } from './spiritual-counselling.entity';
import { ChaplainService } from './chaplain.service';
import { ChaplainController } from './chaplain.controller';

@Module({
  imports: [TypeOrmModule.forFeature([PrayerRequest, SpiritualCounselling])],
  providers: [ChaplainService],
  controllers: [ChaplainController],
})
export class ChaplainModule {}
