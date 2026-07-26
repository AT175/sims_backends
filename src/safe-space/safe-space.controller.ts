import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { SafeSpaceService } from './safe-space.service';

@Controller('safe-space')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class SafeSpaceController {
  constructor(private readonly service: SafeSpaceService) {}

  @Get('incidents')
  async getIncidents(@Request() req: any) {
    return this.service.getIncidents(req.user.tenantId);
  }

  @Get('training')
  async getTraining(@Request() req: any) {
    return this.service.getTraining(req.user.tenantId);
  }
}
