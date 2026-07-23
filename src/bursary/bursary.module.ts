import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FeeRecord } from './fee-record.entity';
import { PaymentReceipt } from './payment-receipt.entity';
import { BursaryService } from './bursary.service';
import { BursaryController } from './bursary.controller';

@Module({
  imports: [TypeOrmModule.forFeature([FeeRecord, PaymentReceipt])],
  providers: [BursaryService],
  controllers: [BursaryController],
})
export class BursaryModule {}
