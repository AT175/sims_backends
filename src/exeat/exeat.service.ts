import { Injectable } from '@nestjs/common';

@Injectable()
export class ExeatService {
  async getRoot(tenantId: string): Promise<any[]> {
    return [];
  }
}
