import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { SrcService } from './src.service';

@Controller('src')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class SrcController {
  constructor(private readonly service: SrcService) {}

  @Get('announcements')
  async getAnnouncements(@Request() req: any) {
    return this.service.getAnnouncements(req.user.tenantId);
  }

  @Get('events')
  async getEvents(@Request() req: any) {
    return this.service.getEvents(req.user.tenantId);
  }

  @Get('feedback')
  async getFeedback(@Request() req: any) {
    return this.service.getFeedback(req.user.tenantId);
  }

  @Get('grievances')
  async getGrievances(@Request() req: any) {
    return this.service.getGrievances(req.user.tenantId);
  }

  @Get('initiatives')
  async getInitiatives(@Request() req: any) {
    return this.service.getInitiatives(req.user.tenantId);
  }

  @Get('prefects')
  async getPrefects(@Request() req: any) {
    return this.service.getPrefects(req.user.tenantId);
  }

  @Get('transactions')
  async getTransactions(@Request() req: any) {
    return this.service.getTransactions(req.user.tenantId);
  }
}
