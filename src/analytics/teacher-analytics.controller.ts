import { Controller, Get, Query, Request, UseGuards } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { TeacherAnalyticsService } from './teacher-analytics.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('analytics/teacher')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class TeacherAnalyticsController {
  constructor(private readonly svc: TeacherAnalyticsService) {}

  @Get('performance')
  async getPerformance(@Query('teacherId') teacherId: string, @Query('term') term: string, @Request() r: any) {
    return this.svc.getTeacherPerformance(r.user.tenantId, teacherId, term);
  }

  @Get('rankings')
  @Roles('headmaster', 'system_admin')
  async getRankings(@Query('term') term: string, @Request() r: any) {
    return this.svc.getTeacherRankings(r.user.tenantId, term);
  }

  @Get('subject/:subject')
  @Roles('headmaster', 'system_admin', 'teacher')
  async getSubjectPerformance(subject: string, @Request() r: any) {
    return this.svc.getSubjectPerformance(r.user.tenantId, subject);
  }

  @Get('insights')
  @Roles('headmaster', 'system_admin')
  async getInsights(@Request() r: any) {
    return this.svc.getInsights(r.user.tenantId);
  }
}
