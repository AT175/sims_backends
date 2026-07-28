import { Controller, Get, Post, Body, Query, Request, UseGuards } from '@nestjs/common';
import { IsString, IsNumber, IsBoolean, IsOptional } from 'class-validator';
import { EarningsService } from './earnings.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

class ClaimDto {
  @IsString()
  mobileMoneyNumber: string;
}

class DisburseDto {
  @IsString()
  reference: string;
}

class ConfigDto {
  @IsOptional() @IsNumber() ratePerAction?: number;
  @IsOptional() @IsNumber() maxActionsPerDay?: number;
  @IsOptional() @IsNumber() minPayoutThreshold?: number;
  @IsOptional() @IsString() currency?: string;
  @IsOptional() @IsBoolean() enabled?: boolean;
}

@Controller('earnings')
@UseGuards(JwtAuthGuard, RolesGuard)
export class EarningsController {
  constructor(private readonly service: EarningsService) {}

  @Get('me')
  async getMyEarnings(@Request() req: any) {
    return this.service.getMyEarnings(req.user.id, req.user.tenantId);
  }

  @Post('claim')
  async claim(@Request() req: any, @Body() dto: ClaimDto) {
    return this.service.claimEarnings(req.user.id, req.user.tenantId, dto.mobileMoneyNumber);
  }

  @Get('config')
  @Roles('headmaster', 'system_admin', 'subscription_payment', 'bursary')
  async getConfig(@Request() req: any) {
    return this.service.getConfig(req.user.tenantId);
  }

  @Post('config')
  @Roles('headmaster', 'system_admin', 'subscription_payment')
  async updateConfig(@Request() req: any, @Body() dto: ConfigDto) {
    return this.service.updateConfig(req.user.tenantId, dto);
  }

  @Get()
  @Roles('headmaster', 'system_admin', 'subscription_payment', 'bursary')
  async getAll(@Request() req: any) {
    return this.service.getAllEarnings(req.user.tenantId);
  }

  @Get('pending-payouts')
  @Roles('headmaster', 'system_admin', 'subscription_payment', 'bursary')
  async getPendingPayouts(@Request() req: any) {
    return this.service.getPendingPayouts(req.user.tenantId);
  }

  @Post('disburse')
  @Roles('headmaster', 'system_admin', 'subscription_payment')
  async disburse(@Body() dto: DisburseDto, @Query('payoutId') payoutId: string, @Request() req: any) {
    return this.service.disbursePayout(payoutId, req.user.id, dto.reference);
  }

  @Post('cancel-payout')
  @Roles('headmaster', 'system_admin', 'subscription_payment')
  async cancelPayout(@Query('payoutId') payoutId: string) {
    return this.service.cancelPayout(payoutId);
  }

  @Get('stats')
  @Roles('headmaster', 'system_admin', 'subscription_payment', 'bursary')
  async getStats(@Request() req: any) {
    return this.service.getStats(req.user.tenantId);
  }
}
