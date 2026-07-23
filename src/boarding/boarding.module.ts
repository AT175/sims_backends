import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ExeatRecord } from './exeat-record.entity';
import { RollCallEntry } from './roll-call-entry.entity';
import { BoardingDisciplineLog } from './discipline-log.entity';
import { BoardingService } from './boarding.service';
import { BoardingController } from './boarding.controller';

@Module({
  imports: [TypeOrmModule.forFeature([ExeatRecord, RollCallEntry, BoardingDisciplineLog])],
  providers: [BoardingService],
  controllers: [BoardingController],
})
export class BoardingModule {}
