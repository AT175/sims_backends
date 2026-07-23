import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Requisition } from './requisition.entity';

@Injectable()
export class RequisitionService {
  constructor(
    @InjectRepository(Requisition) private readonly repo: Repository<Requisition>,
  ) {}

  async getAll(tenantId: string): Promise<Requisition[]> {
    return this.repo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }
  async getByDepartment(department: string, tenantId: string): Promise<Requisition[]> {
    return this.repo.find({ where: { tenantId, department }, order: { date: 'DESC' } });
  }
  async create(data: Partial<Requisition>, tenantId: string): Promise<Requisition> {
    return this.repo.save(this.repo.create({ ...data, status: 'Pending', tenantId }));
  }
  async updateStatus(id: string, status: string, tenantId: string): Promise<Requisition> {
    const req = await this.repo.findOne({ where: { id, tenantId } });
    if (!req) throw new NotFoundException('Requisition not found');
    req.status = status;
    return this.repo.save(req);
  }
}
