import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PTAAnnouncement } from './pta-announcement.entity';
import { PTAMeeting } from './pta-meeting.entity';
import { PTAService } from './pta.service';
import { PTAController } from './pta.controller';

@Module({
  imports: [TypeOrmModule.forFeature([PTAAnnouncement, PTAMeeting])],
  providers: [PTAService],
  controllers: [PTAController],
})
export class PTAModule {}
