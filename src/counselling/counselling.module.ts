import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CounsellingCase } from './counselling-case.entity';
import { CounsellingService } from './counselling.service';
import { CounsellingController } from './counselling.controller';

@Module({
  imports: [TypeOrmModule.forFeature([CounsellingCase])],
  providers: [CounsellingService],
  controllers: [CounsellingController],
})
export class CounsellingModule {}
