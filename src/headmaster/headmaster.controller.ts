import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { HeadmasterService } from './headmaster.service';

@Controller('headmaster')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class HeadmasterController {
  constructor(private readonly service: HeadmasterService) {}

  @Get('approvals')
  async getApprovals(@Request() req: any) {
    return this.service.getApprovals(req.user.tenantId);
  }

  @Get('broadcasts')
  async getBroadcasts(@Request() req: any) {
    return this.service.getBroadcasts(req.user.tenantId);
  }

  @Get('discipline-cases')
  async getDisciplineCases(@Request() req: any) {
    return this.service.getDisciplineCases(req.user.tenantId);
  }
}
