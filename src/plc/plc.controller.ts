import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { PlcService } from './plc.service';

@Controller('plc')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class PlcController {
  constructor(private readonly service: PlcService) {}

  @Get('meetings')
  async getMeetings(@Request() req: any) {
    return this.service.getMeetings(req.user.tenantId);
  }

  @Get('requisitions')
  async getRequisitions(@Request() req: any) {
    return this.service.getRequisitions(req.user.tenantId);
  }

  @Get('resources')
  async getResources(@Request() req: any) {
    return this.service.getResources(req.user.tenantId);
  }
}
