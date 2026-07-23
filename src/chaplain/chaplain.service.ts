import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PrayerRequest } from './prayer-request.entity';
import { SpiritualCounselling } from './spiritual-counselling.entity';

@Injectable()
export class ChaplainService {
  constructor(
    @InjectRepository(PrayerRequest) private readonly prayerRepo: Repository<PrayerRequest>,
    @InjectRepository(SpiritualCounselling) private readonly counsellingRepo: Repository<SpiritualCounselling>,
  ) {}

  async getPrayerRequests(tenantId: string): Promise<PrayerRequest[]> {
    return this.prayerRepo.find({ where: { tenantId }, order: { dateSubmitted: 'DESC' } });
  }
  async createPrayerRequest(data: Partial<PrayerRequest>, tenantId: string): Promise<PrayerRequest> {
    return this.prayerRepo.save(this.prayerRepo.create({ ...data, status: 'Open', tenantId }));
  }
  async getCounselling(tenantId: string): Promise<SpiritualCounselling[]> {
    return this.counsellingRepo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }
  async createCounselling(data: Partial<SpiritualCounselling>, tenantId: string): Promise<SpiritualCounselling> {
    return this.counsellingRepo.save(this.counsellingRepo.create({ ...data, status: 'Open', tenantId }));
  }
}
