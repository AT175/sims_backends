import { Injectable } from '@nestjs/common';

@Injectable()
export class SecretaryService {
  async getAppointments(tenantId: string): Promise<any[]> {
    return [];
  }

  async getTasks(tenantId: string): Promise<any[]> {
    return [];
  }
}
