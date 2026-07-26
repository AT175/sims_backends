import { Injectable } from '@nestjs/common';

@Injectable()
export class GoverningBoardService {
  async getPolicies(tenantId: string): Promise<any[]> {
    return [];
  }

  async getBudgets(tenantId: string): Promise<any[]> {
    return [];
  }

  async getMinutes(tenantId: string): Promise<any[]> {
    return [];
  }
}
