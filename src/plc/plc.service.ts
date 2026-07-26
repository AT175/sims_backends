import { Injectable } from '@nestjs/common';

@Injectable()
export class PlcService {
  async getMeetings(tenantId: string): Promise<any[]> {
    return [];
  }

  async getRequisitions(tenantId: string): Promise<any[]> {
    return [];
  }

  async getResources(tenantId: string): Promise<any[]> {
    return [];
  }
}
