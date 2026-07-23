import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Requisition } from './requisition.entity';
import { RequisitionService } from './requisition.service';
import { RequisitionController } from './requisition.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Requisition])],
  providers: [RequisitionService],
  controllers: [RequisitionController],
})
export class RequisitionModule {}
