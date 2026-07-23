import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PTAAnnouncement } from './pta-announcement.entity';
import { PTAMeeting } from './pta-meeting.entity';

@Injectable()
export class PTAService {
  constructor(
    @InjectRepository(PTAAnnouncement) private readonly announcementRepo: Repository<PTAAnnouncement>,
    @InjectRepository(PTAMeeting) private readonly meetingRepo: Repository<PTAMeeting>,
  ) {}

  async getAnnouncements(tenantId: string): Promise<PTAAnnouncement[]> {
    return this.announcementRepo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }
  async createAnnouncement(data: Partial<PTAAnnouncement>, tenantId: string): Promise<PTAAnnouncement> {
    return this.announcementRepo.save(this.announcementRepo.create({ ...data, tenantId }));
  }
  async getMeetings(tenantId: string): Promise<PTAMeeting[]> {
    return this.meetingRepo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }
  async createMeeting(data: Partial<PTAMeeting>, tenantId: string): Promise<PTAMeeting> {
    return this.meetingRepo.save(this.meetingRepo.create({ ...data, tenantId }));
  }
  async updateRSVP(id: string, rsvp: string, tenantId: string): Promise<PTAMeeting | null> {
    const meeting = await this.meetingRepo.findOne({ where: { id, tenantId } });
    if (!meeting) return null;
    meeting.rsvp = rsvp;
    return this.meetingRepo.save(meeting);
  }
}
