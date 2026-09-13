import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LabProgressEntity } from './lab-progress.entity';
import { VirtualLabService } from './virtual-lab.service';
import { VirtualLabController } from './virtual-lab.controller';

@Module({
  imports: [TypeOrmModule.forFeature([LabProgressEntity])],
  providers: [VirtualLabService],
  controllers: [VirtualLabController],
  exports: [VirtualLabService],
})
export class VirtualLabModule {}
