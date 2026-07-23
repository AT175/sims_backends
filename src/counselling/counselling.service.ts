import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CounsellingCase } from './counselling-case.entity';

@Injectable()
export class CounsellingService {
  constructor(
    @InjectRepository(CounsellingCase) private readonly caseRepo: Repository<CounsellingCase>,
  ) {}

  async getCases(tenantId: string): Promise<CounsellingCase[]> {
    return this.caseRepo.find({ where: { tenantId }, order: { openedDate: 'DESC' } });
  }
  async createCase(data: Partial<CounsellingCase>, tenantId: string): Promise<CounsellingCase> {
    const caseId = `CASE-${Date.now()}`;
    return this.caseRepo.save(this.caseRepo.create({ ...data, caseId, status: 'Active', tenantId }));
  }
  async updateCaseStatus(id: string, status: string, tenantId: string): Promise<CounsellingCase | null> {
    const c = await this.caseRepo.findOne({ where: { id, tenantId } });
    if (!c) return null;
    c.status = status;
    return this.caseRepo.save(c);
  }
}
