import { Injectable } from '@nestjs/common';

@Injectable()
export class ExamCommitteeService {
  async getSchedules(tenantId: string): Promise<any[]> {
    return [];
  }

  async getResults(tenantId: string): Promise<any[]> {
    return [];
  }
}
