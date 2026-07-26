import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AdminService } from './admin.service';

@Controller('admin')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class AdminController {
  constructor(private readonly service: AdminService) {}

  @Get('compliance')
  async getCompliance(@Request() req: any) {
    return this.service.getCompliance(req.user.tenantId);
  }

  @Get('facilities')
  async getFacilities(@Request() req: any) {
    return this.service.getFacilities(req.user.tenantId);
  }

  @Get('tasks')
  async getTasks(@Request() req: any) {
    return this.service.getTasks(req.user.tenantId);
  }

  @Get('announcements')
  async getAnnouncements(@Request() req: any) {
    return this.service.getAnnouncements(req.user.tenantId);
  }

  @Get('meetings')
  async getMeetings(@Request() req: any) {
    return this.service.getMeetings(req.user.tenantId);
  }
}
