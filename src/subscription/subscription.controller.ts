import { Controller, Get, Post, Body, Request, UseGuards, Query } from '@nestjs/common';
import { IsString, IsOptional, IsNumber } from 'class-validator';
import { SubscriptionService } from './subscription.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

class UpgradeDto {
  @IsString()
  paymentMethod: string;

  @IsString()
  paymentReference: string;
}

class ExtendDto {
  @IsNumber()
  days: number;
}

@Controller('subscriptions')
@UseGuards(JwtAuthGuard, RolesGuard)
export class SubscriptionController {
  constructor(private readonly service: SubscriptionService) {}

  @Get('me')
  async getMySubscription(@Request() req: any) {
    const sub = await this.service.getMySubscription(req.user.id, req.user.tenantId);
    return sub || { status: 'none', plan: 'none', message: 'No subscription found' };
  }

  @Post('upgrade')
  async upgrade(@Request() req: any, @Body() dto: UpgradeDto) {
    return this.service.upgradeToAnnual(req.user.id, req.user.tenantId, dto);
  }

  @Get()
  @Roles('headmaster', 'system_admin', 'bursary', 'subscription_payment')
  async getAll(@Request() req: any) {
    return this.service.getAllSubscriptions(req.user.tenantId);
  }

  @Get('stats')
  @Roles('headmaster', 'system_admin', 'bursary', 'subscription_payment')
  async getStats(@Request() req: any) {
    return this.service.getStats(req.user.tenantId);
  }

  @Post('extend')
  @Roles('headmaster', 'system_admin', 'subscription_payment')
  async extend(@Body() dto: ExtendDto, @Query('userId') userId: string, @Request() req: any) {
    if (!userId) throw new Error('userId query parameter is required');
    return this.service.manuallyExtend(userId, req.user.tenantId, dto.days);
  }

  @Post('cancel')
  @Roles('headmaster', 'system_admin', 'subscription_payment')
  async cancel(@Query('userId') userId: string, @Request() req: any) {
    if (!userId) throw new Error('userId query parameter is required');
    return this.service.cancelSubscription(userId, req.user.tenantId);
  }

  @Get('check')
  async checkAccess(@Request() req: any) {
    const hasAccess = await this.service.hasActiveAccess(req.user.id, req.user.tenantId);
    return { hasAccess };
  }
}
