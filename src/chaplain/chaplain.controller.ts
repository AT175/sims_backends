import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { ChaplainService } from './chaplain.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CreatePrayerRequestDto, CreateSpiritualCounsellingDto } from './chaplain.dto';

@Controller('chaplain')
@UseGuards(JwtAuthGuard)
export class ChaplainController {
  constructor(private readonly service: ChaplainService) {}

  @Get('prayer-requests')
  async getPrayerRequests(@Request() req: any) { return this.service.getPrayerRequests(req.user.tenantId); }

  @Post('prayer-requests')
  @Roles('headmaster', 'chaplain', 'system_admin')
  async createPrayerRequest(@Body() data: CreatePrayerRequestDto, @Request() req: any) { return this.service.createPrayerRequest(data, req.user.tenantId); }

  @Get('counselling')
  async getCounselling(@Request() req: any) { return this.service.getCounselling(req.user.tenantId); }

  @Post('counselling')
  @Roles('headmaster', 'chaplain', 'system_admin')
  async createCounselling(@Body() data: CreateSpiritualCounsellingDto, @Request() req: any) { return this.service.createCounselling(data, req.user.tenantId); }
}
