import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AccessGrant } from './access-grant.entity';

export interface CreateGrantDto {
  userId: string;
  username: string;
  displayName: string;
  dashboardKey: string;
  dashboardLabel: string;
  allowedPages: string[] | 'all';
  grantedBy: string;
  tenantId: string;
}

@Injectable()
export class AccessControlService {
  constructor(
    @InjectRepository(AccessGrant)
    private readonly grantRepo: Repository<AccessGrant>,
  ) {}

  async createGrant(dto: CreateGrantDto): Promise<AccessGrant> {
    const existing = await this.grantRepo.findOne({
      where: { userId: dto.userId, dashboardKey: dto.dashboardKey, tenantId: dto.tenantId },
    });

    const allowedPagesStr = dto.allowedPages === 'all' ? 'all' : JSON.stringify(dto.allowedPages);

    if (existing) {
      existing.allowedPages = allowedPagesStr;
      existing.grantedBy = dto.grantedBy;
      existing.displayName = dto.displayName;
      existing.dashboardLabel = dto.dashboardLabel;
      return this.grantRepo.save(existing);
    }

    const grant = this.grantRepo.create({
      userId: dto.userId,
      username: dto.username,
      displayName: dto.displayName,
      dashboardKey: dto.dashboardKey,
      dashboardLabel: dto.dashboardLabel,
      allowedPages: allowedPagesStr,
      grantedBy: dto.grantedBy,
      tenantId: dto.tenantId,
    });
    return this.grantRepo.save(grant);
  }

  async getAllGrants(tenantId: string): Promise<AccessGrant[]> {
    return this.grantRepo.find({ where: { tenantId }, order: { grantedAt: 'DESC' } });
  }

  async deleteGrant(id: string, tenantId: string): Promise<{ message: string }> {
    const grant = await this.grantRepo.findOne({ where: { id, tenantId } });
    if (!grant) {
      throw new NotFoundException('Grant not found');
    }
    await this.grantRepo.remove(grant);
    return { message: 'Grant deleted' };
  }

  async getGrantsForUser(userId: string, tenantId: string): Promise<AccessGrant[]> {
    return this.grantRepo.find({ where: { userId, tenantId }, order: { grantedAt: 'DESC' } });
  }
}
