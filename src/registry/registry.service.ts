import { Injectable } from '@nestjs/common';

@Injectable()
export class RegistryService {
  async getStudents(tenantId: string): Promise<any[]> {
    return [];
  }

  async getAdmissions(tenantId: string): Promise<any[]> {
    return [];
  }

  async getPlacements(tenantId: string): Promise<any[]> {
    return [];
  }
}
