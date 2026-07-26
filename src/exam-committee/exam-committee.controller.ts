import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ExamCommitteeService } from './exam-committee.service';

@Controller('exam-committee')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class ExamCommitteeController {
  constructor(private readonly service: ExamCommitteeService) {}

  @Get('schedules')
  async getSchedules(@Request() req: any) {
    return this.service.getSchedules(req.user.tenantId);
  }

  @Get('results')
  async getResults(@Request() req: any) {
    return this.service.getResults(req.user.tenantId);
  }
}
