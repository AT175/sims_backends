import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CleaningTask } from './cleaning-task.entity';
import { MaintenanceIssue } from './maintenance-issue.entity';

@Injectable()
export class CleaningService {
  constructor(
    @InjectRepository(CleaningTask) private readonly taskRepo: Repository<CleaningTask>,
    @InjectRepository(MaintenanceIssue) private readonly issueRepo: Repository<MaintenanceIssue>,
  ) {}

  async getTasks(tenantId: string): Promise<CleaningTask[]> {
    return this.taskRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } });
  }
  async createTask(data: Partial<CleaningTask>, tenantId: string): Promise<CleaningTask> {
    return this.taskRepo.save(this.taskRepo.create({ ...data, tenantId }));
  }
  async toggleTaskDone(id: string, tenantId: string): Promise<CleaningTask | null> {
    const task = await this.taskRepo.findOne({ where: { id, tenantId } });
    if (!task) return null;
    task.done = !task.done;
    return this.taskRepo.save(task);
  }
  async getIssues(tenantId: string): Promise<MaintenanceIssue[]> {
    return this.issueRepo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }
  async createIssue(data: Partial<MaintenanceIssue>, tenantId: string): Promise<MaintenanceIssue> {
    return this.issueRepo.save(this.issueRepo.create({ ...data, status: 'Reported', tenantId }));
  }
}
