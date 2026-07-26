import { Injectable } from '@nestjs/common';

@Injectable()
export class AcademicBoardService {
  async getMeetings(tenantId: string): Promise<any[]> {
    return [];
  }

  async getPolicies(tenantId: string): Promise<any[]> {
    return [];
  }

  async getDeptreports(tenantId: string): Promise<any[]> {
    return [];
  }
}
