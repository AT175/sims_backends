import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { SecurityIncident } from './security-incident.entity';
import { GateLog } from './gate-log.entity';

@Injectable()
export class SecurityService {
  constructor(
    @InjectRepository(SecurityIncident) private readonly incidentRepo: Repository<SecurityIncident>,
    @InjectRepository(GateLog) private readonly gateRepo: Repository<GateLog>,
  ) {}

  async getIncidents(tenantId: string): Promise<SecurityIncident[]> {
    return this.incidentRepo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }
  async createIncident(data: Partial<SecurityIncident>, tenantId: string): Promise<SecurityIncident> {
    const incidentId = `INC-${Date.now()}`;
    return this.incidentRepo.save(this.incidentRepo.create({ ...data, incidentId, status: 'Reported', tenantId }));
  }
  async getGateLogs(tenantId: string): Promise<GateLog[]> {
    return this.gateRepo.find({ where: { tenantId }, order: { date: 'DESC', time: 'DESC' } });
  }
  async createGateLog(data: Partial<GateLog>, tenantId: string): Promise<GateLog> {
    return this.gateRepo.save(this.gateRepo.create({ ...data, tenantId }));
  }
}
