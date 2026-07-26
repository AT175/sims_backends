import { Injectable } from '@nestjs/common';

@Injectable()
export class SafeSpaceService {
  async getIncidents(tenantId: string): Promise<any[]> {
    return [];
  }

  async getTraining(tenantId: string): Promise<any[]> {
    return [];
  }
}
