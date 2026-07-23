import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SportsFixture } from './sports-fixture.entity';
import { SportsClub } from './sports-club.entity';

@Injectable()
export class SportsService {
  constructor(
    @InjectRepository(SportsFixture) private readonly fixtureRepo: Repository<SportsFixture>,
    @InjectRepository(SportsClub) private readonly clubRepo: Repository<SportsClub>,
  ) {}

  async getFixtures(tenantId: string): Promise<SportsFixture[]> {
    return this.fixtureRepo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }
  async createFixture(data: Partial<SportsFixture>, tenantId: string): Promise<SportsFixture> {
    return this.fixtureRepo.save(this.fixtureRepo.create({ ...data, tenantId }));
  }
  async getClubs(tenantId: string): Promise<SportsClub[]> {
    return this.clubRepo.find({ where: { tenantId }, order: { name: 'ASC' } });
  }
  async createClub(data: Partial<SportsClub>, tenantId: string): Promise<SportsClub> {
    return this.clubRepo.save(this.clubRepo.create({ ...data, tenantId }));
  }
}
