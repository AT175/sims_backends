import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ExeatRecord } from './exeat-record.entity';
import { RollCallEntry } from './roll-call-entry.entity';
import { BoardingDisciplineLog } from './discipline-log.entity';

@Injectable()
export class BoardingService {
  constructor(
    @InjectRepository(ExeatRecord) private readonly exeatRepo: Repository<ExeatRecord>,
    @InjectRepository(RollCallEntry) private readonly rollCallRepo: Repository<RollCallEntry>,
    @InjectRepository(BoardingDisciplineLog) private readonly disciplineRepo: Repository<BoardingDisciplineLog>,
  ) {}

  // Exeat
  async getExeats(tenantId: string): Promise<ExeatRecord[]> {
    return this.exeatRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } });
  }

  async createExeat(data: Partial<ExeatRecord>, tenantId: string): Promise<ExeatRecord> {
    const exeatNo = `EXE-${Date.now()}`;
    const record = this.exeatRepo.create({ ...data, exeatNo, status: 'Pending', tenantId });
    return this.exeatRepo.save(record);
  }

  async updateExeatStatus(id: string, status: string, approvedBy: string, tenantId: string): Promise<ExeatRecord> {
    const record = await this.exeatRepo.findOne({ where: { id, tenantId } });
    if (!record) throw new NotFoundException('Exeat not found');
    record.status = status;
    if (status === 'Approved' || status === 'Rejected') {
      record.approvedBy = approvedBy;
      record.approvedDate = new Date().toISOString().slice(0, 10);
    }
    return this.exeatRepo.save(record);
  }

  // Roll Call
  async getRollCalls(house: string | undefined, tenantId: string): Promise<RollCallEntry[]> {
    const where: any = { tenantId };
    if (house) where.house = house;
    return this.rollCallRepo.find({ where, order: { date: 'DESC' } });
  }

  async createRollCall(data: Partial<RollCallEntry>, tenantId: string): Promise<RollCallEntry> {
    const record = this.rollCallRepo.create({ ...data, tenantId });
    return this.rollCallRepo.save(record);
  }

  // Discipline
  async getDisciplineLogs(tenantId: string): Promise<BoardingDisciplineLog[]> {
    return this.disciplineRepo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }

  async createDisciplineLog(data: Partial<BoardingDisciplineLog>, tenantId: string): Promise<BoardingDisciplineLog> {
    const record = this.disciplineRepo.create({ ...data, tenantId });
    return this.disciplineRepo.save(record);
  }
}
