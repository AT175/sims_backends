import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AdmissionApplication } from './admission-application.entity';
import { SubmitAdmissionDto, UpdateAdmissionStatusDto } from './admission.dto';

@Injectable()
export class AdmissionsService {
  constructor(
    @InjectRepository(AdmissionApplication)
    private readonly repo: Repository<AdmissionApplication>,
  ) {}

  async submit(dto: SubmitAdmissionDto, tenantId: string): Promise<AdmissionApplication> {
    const app = this.repo.create({
      ...dto,
      tenantId,
      status: 'received',
      documentsVerified: false,
    });
    return this.repo.save(app);
  }

  async findAll(tenantId: string): Promise<AdmissionApplication[]> {
    return this.repo.find({
      where: { tenantId },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string, tenantId: string): Promise<AdmissionApplication> {
    const app = await this.repo.findOne({ where: { id, tenantId } });
    if (!app) {
      throw new NotFoundException('Admission application not found');
    }
    return app;
  }

  async updateStatus(
    id: string,
    dto: UpdateAdmissionStatusDto,
    tenantId: string,
  ): Promise<AdmissionApplication> {
    const app = await this.findOne(id, tenantId);
    app.status = dto.status;
    if (dto.documentsVerified !== undefined) {
      app.documentsVerified = dto.documentsVerified === 'true';
    }
    return this.repo.save(app);
  }
}
