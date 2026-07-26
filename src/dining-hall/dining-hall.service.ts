import { Injectable } from '@nestjs/common';

@Injectable()
export class DiningHallService {
  async getMenuitems(tenantId: string): Promise<any[]> {
    return [];
  }

  async getMealattendance(tenantId: string): Promise<any[]> {
    return [];
  }

  async getSupplies(tenantId: string): Promise<any[]> {
    return [];
  }
}
