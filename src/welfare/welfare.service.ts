import { Injectable } from '@nestjs/common';

@Injectable()
export class WelfareService {
  async getLedger(tenantId: string): Promise<any[]> {
    return [];
  }

  async getMembers(tenantId: string): Promise<any[]> {
    return [];
  }

  async getSupportRequests(tenantId: string): Promise<any[]> {
    return [];
  }
}
