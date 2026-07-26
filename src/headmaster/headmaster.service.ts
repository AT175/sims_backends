import { Injectable } from '@nestjs/common';

@Injectable()
export class HeadmasterService {
  async getApprovals(tenantId: string): Promise<any[]> {
    return [];
  }

  async getBroadcasts(tenantId: string): Promise<any[]> {
    return [];
  }

  async getDisciplineCases(tenantId: string): Promise<any[]> {
    return [];
  }
}
