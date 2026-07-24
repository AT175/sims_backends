import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Tenant } from './tenant.entity';

@Injectable()
export class TenantsService {
  constructor(
    @InjectRepository(Tenant)
    private readonly tenantRepo: Repository<Tenant>,
  ) {}

  async findAll(): Promise<Tenant[]> {
    return this.tenantRepo.find({ order: { createdAt: 'ASC' } });
  }

  async findOne(id: string): Promise<Tenant> {
    const tenant = await this.tenantRepo.findOne({ where: { id } });
    if (!tenant) {
      throw new NotFoundException('Tenant not found');
    }
    return tenant;
  }

  async findByKey(tenantKey: string): Promise<Tenant | null> {
    return this.tenantRepo.findOne({ where: { tenantKey } });
  }

  async create(data: {
    tenantKey: string;
    schoolName: string;
    schoolCode?: string;
    region?: string;
    district?: string;
    address?: string;
    phone?: string;
    email?: string;
    maxStudents?: number;
    maxStaff?: number;
    subscriptionPlan?: string;
    subscriptionExpiry?: string;
    enabledModules?: string[];
  }): Promise<Tenant> {
    const existing = await this.tenantRepo.findOne({ where: { tenantKey: data.tenantKey } });
    if (existing) {
      throw new BadRequestException('Tenant key already exists');
    }

    const tenant = this.tenantRepo.create({
      tenantKey: data.tenantKey,
      schoolName: data.schoolName,
      schoolCode: data.schoolCode ?? null,
      region: data.region ?? null,
      district: data.district ?? null,
      address: data.address ?? null,
      phone: data.phone ?? null,
      email: data.email ?? null,
      maxStudents: data.maxStudents ?? 2000,
      maxStaff: data.maxStaff ?? 150,
      subscriptionPlan: data.subscriptionPlan ?? 'Standard',
      subscriptionExpiry: data.subscriptionExpiry ?? null,
      enabledModules: data.enabledModules ?? [],
    });
    return this.tenantRepo.save(tenant);
  }

  async update(id: string, data: Partial<{
    schoolName: string;
    schoolCode: string;
    region: string;
    district: string;
    address: string;
    phone: string;
    email: string;
    logoUrl: string;
    academicYear: string;
    term: string;
    maxStudents: number;
    maxStaff: number;
    subscriptionPlan: string;
    subscriptionExpiry: string;
    enabledModules: string[];
    active: boolean;
  }>): Promise<Tenant> {
    const tenant = await this.findOne(id);
    Object.assign(tenant, data);
    return this.tenantRepo.save(tenant);
  }

  async remove(id: string): Promise<{ message: string }> {
    const tenant = await this.findOne(id);
    await this.tenantRepo.remove(tenant);
    return { message: 'Tenant deleted' };
  }
}
