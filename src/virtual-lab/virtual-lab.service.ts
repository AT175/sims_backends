import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LabProgressEntity } from './lab-progress.entity';
import { PHET_LABS, CUSTOM_LABS } from './phet-catalog';

@Injectable()
export class VirtualLabService {
  constructor(
    @InjectRepository(LabProgressEntity) private progressRepo: Repository<LabProgressEntity>,
  ) {}

  getLabs(classForm?: string, subject?: string) {
    let phet = PHET_LABS;
    let custom = CUSTOM_LABS;
    if (classForm) {
      phet = phet.filter((l) => l.classForm.includes(classForm));
      custom = custom.filter((l) => l.classForm.includes(classForm));
    }
    if (subject) {
      phet = phet.filter((l) => l.subject === subject || l.subject.includes(subject));
      custom = custom.filter((l) => l.subject === subject || l.subject.includes(subject));
    }
    return {
      phetLabs: phet,
      customLabs: custom,
      total: phet.length + custom.length,
    };
  }

  getLabById(labId: string) {
    const phet = PHET_LABS.find((l) => l.id === labId);
    if (phet) return { ...phet, type: 'phet' };
    const custom = CUSTOM_LABS.find((l) => l.id === labId);
    if (custom) return { ...custom, type: 'custom' };
    throw new NotFoundException('Lab not found');
  }

  async recordProgress(studentId: string, studentName: string, tenantId: string, data: {
    labId: string;
    labTitle: string;
    subject: string;
    classForm?: string;
    completed?: boolean;
    score?: number;
    timeSpent?: number;
    observations?: string;
    reportContent?: string;
  }) {
    const existing = await this.progressRepo.findOne({ where: { tenantId, studentId, labId: data.labId } });
    if (existing) {
      existing.completed = data.completed ?? existing.completed;
      existing.score = data.score ?? existing.score;
      existing.timeSpent = (existing.timeSpent || 0) + (data.timeSpent || 0);
      existing.observations = data.observations ?? existing.observations;
      existing.reportContent = data.reportContent ?? existing.reportContent;
      return this.progressRepo.save(existing);
    }
    return this.progressRepo.save(this.progressRepo.create({
      tenantId, studentId, studentName,
      ...data,
    }));
  }

  async getProgress(studentId: string, tenantId: string) {
    const records = await this.progressRepo.find({ where: { tenantId, studentId }, order: { createdAt: 'DESC' } });
    return {
      totalLabs: records.length,
      completedLabs: records.filter((r) => r.completed).length,
      totalTimeSpent: records.reduce((s, r) => s + r.timeSpent, 0),
      labs: records,
    };
  }

  async getClassProgress(tenantId: string, classForm: string) {
    const records = await this.progressRepo.find({ where: { tenantId, classForm }, order: { createdAt: 'DESC' } });
    return records;
  }
}
