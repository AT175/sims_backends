import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RegistryService } from './registry.service';

@Controller('registry')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class RegistryController {
  constructor(private readonly service: RegistryService) {}

  @Get('students')
  async getStudents(@Request() req: any) {
    return this.service.getStudents(req.user.tenantId);
  }

  @Get('admissions')
  async getAdmissions(@Request() req: any) {
    return this.service.getAdmissions(req.user.tenantId);
  }

  @Get('placements')
  async getPlacements(@Request() req: any) {
    return this.service.getPlacements(req.user.tenantId);
  }
}
