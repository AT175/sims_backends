import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { WelfareService } from './welfare.service';

@Controller('welfare')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class WelfareController {
  constructor(private readonly service: WelfareService) {}

  @Get('ledger')
  async getLedger(@Request() req: any) {
    return this.service.getLedger(req.user.tenantId);
  }

  @Get('members')
  async getMembers(@Request() req: any) {
    return this.service.getMembers(req.user.tenantId);
  }

  @Get('support-requests')
  async getSupportRequests(@Request() req: any) {
    return this.service.getSupportRequests(req.user.tenantId);
  }
}
