import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLog } from './audit-log.entity';
import { EarningsService } from '../subscription/earnings.service';

export interface AuditEntry {
  userId: string;
  username?: string | null;
  action: string;
  resource?: string | null;
  details?: string | null;
  ipAddress?: string | null;
  userAgent?: string | null;
  success?: boolean;
  roles?: string[];
  tenantId?: string | null;
}

@Injectable()
export class AuditService {
  constructor(
    @InjectRepository(AuditLog)
    private readonly repo: Repository<AuditLog>,
    private readonly earningsService: EarningsService,
  ) {}

  async log(entry: AuditEntry) {
    const log = this.repo.create({
      ...entry,
      success: entry.success ?? true,
    });
    await this.repo.save(log);

    if (entry.tenantId && entry.roles && entry.success !== false) {
      try {
        await this.earningsService.recordAction(
          entry.userId,
          entry.tenantId,
          entry.roles,
          entry.action,
          entry.resource ?? null,
        );
      } catch {}
    }
  }

  async findRecent(userId: string, limit = 50): Promise<AuditLog[]> {
    return this.repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }
}
