import { Controller, Get, Post, Param, Query, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { DropoutPredictionService } from './dropout-prediction.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('analytics/dropout')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class DropoutPredictionController {
  constructor(private readonly svc: DropoutPredictionService) {}

  @Get('alerts')
  @Roles('headmaster', 'system_admin', 'counsellor')
  async getAlerts(@Query('risk') risk: string, @Request() r: any) {
    return this.svc.getAlerts(r.user.tenantId, risk);
  }

  @Get('student/:studentId')
  @Roles('headmaster', 'system_admin', 'counsellor', 'teacher')
  async getStudentRisk(@Param('studentId') studentId: string, @Request() r: any) {
    return this.svc.getStudentRiskProfile(studentId, r.user.tenantId);
  }

  @Post('run')
  @Roles('headmaster', 'system_admin')
  async runPrediction(@Request() r: any) {
    return this.svc.runPredictionForAll(r.user.tenantId);
  }

  @Post('resolve/:alertId')
  @Roles('headmaster', 'system_admin', 'counsellor')
  async resolveAlert(@Param('alertId') alertId: string, @Request() r: any) {
    return this.svc.resolveAlert(alertId, r.user.tenantId);
  }
}
