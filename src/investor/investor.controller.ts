import { Controller, Get, Post, Body, Param, Put, Delete, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { InvestorService } from './investor.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('investor')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class InvestorController {
  constructor(private readonly svc: InvestorService) {}

  // ── Investor-facing endpoints (investor role) ──────────────

  @Get('portfolio')
  @Roles('investor', 'system_admin')
  async getPortfolio(@Request() r: any) {
    return this.svc.getInvestorPortfolio(r.user.id);
  }

  @Get('platform-overview')
  @Roles('investor', 'system_admin')
  async getPlatformOverview() {
    return this.svc.getPlatformOverview();
  }

  @Get('revenue-trends')
  @Roles('investor', 'system_admin')
  async getRevenueTrends() {
    return this.svc.getRevenueTrends();
  }

  @Get('school-growth')
  @Roles('investor', 'system_admin')
  async getSchoolGrowth() {
    return this.svc.getSchoolGrowth();
  }

  @Get('school-breakdown')
  @Roles('investor', 'system_admin')
  async getSchoolBreakdown() {
    return this.svc.getSchoolBreakdown();
  }

  @Get('terms')
  async getTerms() {
    return this.svc.getInvestmentTerms();
  }

  // ── Admin-only endpoints (system_admin) ────────────────────

  @Get('all')
  @Roles('system_admin')
  async getAllInvestors() {
    return this.svc.getAllInvestors();
  }

  @Post()
  @Roles('system_admin')
  async createInvestor(@Body() body: any) {
    return this.svc.createInvestor(body);
  }

  @Put(':id')
  @Roles('system_admin')
  async updateInvestor(@Param('id') id: string, @Body() body: any) {
    return this.svc.updateInvestor(id, body);
  }

  @Delete(':id')
  @Roles('system_admin')
  async deleteInvestor(@Param('id') id: string) {
    return this.svc.deleteInvestor(id);
  }
}
