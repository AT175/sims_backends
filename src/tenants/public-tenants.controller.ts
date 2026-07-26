import { Controller, Get, Param } from '@nestjs/common';
import { TenantsService } from './tenants.service';

@Controller('public/tenants')
export class PublicTenantsController {
  constructor(private readonly tenantsService: TenantsService) {}

  @Get()
  async getAllPublicTenants() {
    return this.tenantsService.getAllPublicBranding();
  }

  @Get(':tenantKey')
  async getPublicBranding(@Param('tenantKey') tenantKey: string) {
    return this.tenantsService.getPublicBranding(tenantKey);
  }
}
