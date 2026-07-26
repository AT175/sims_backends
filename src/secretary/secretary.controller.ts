import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { SecretaryService } from './secretary.service';

@Controller('secretary')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class SecretaryController {
  constructor(private readonly service: SecretaryService) {}

  @Get('appointments')
  async getAppointments(@Request() req: any) {
    return this.service.getAppointments(req.user.tenantId);
  }

  @Get('tasks')
  async getTasks(@Request() req: any) {
    return this.service.getTasks(req.user.tenantId);
  }
}
