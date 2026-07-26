import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AcademicBoardService } from './academic-board.service';

@Controller('academic-board')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class AcademicBoardController {
  constructor(private readonly service: AcademicBoardService) {}

  @Get('meetings')
  async getMeetings(@Request() req: any) {
    return this.service.getMeetings(req.user.tenantId);
  }

  @Get('policies')
  async getPolicies(@Request() req: any) {
    return this.service.getPolicies(req.user.tenantId);
  }

  @Get('dept-reports')
  async getDeptreports(@Request() req: any) {
    return this.service.getDeptreports(req.user.tenantId);
  }
}
