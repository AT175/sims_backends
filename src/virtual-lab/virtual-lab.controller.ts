import { Controller, Get, Post, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { VirtualLabService } from './virtual-lab.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('virtual-lab')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class VirtualLabController {
  constructor(private readonly svc: VirtualLabService) {}

  @Get('labs')
  async getLabs(@Query('classForm') classForm: string, @Query('subject') subject: string) {
    return this.svc.getLabs(classForm, subject);
  }

  @Get('labs/:labId')
  async getLab(@Param('labId') labId: string) {
    return this.svc.getLabById(labId);
  }

  @Post('progress')
  async recordProgress(@Body() body: any, @Request() r: any) {
    return this.svc.recordProgress(r.user.id, r.user.displayName, r.user.tenantId, body);
  }

  @Get('progress/:studentId')
  async getProgress(@Param('studentId') studentId: string, @Request() r: any) {
    return this.svc.getProgress(studentId, r.user.tenantId);
  }

  @Get('class-progress/:classForm')
  @Roles('teacher', 'headmaster', 'system_admin')
  async getClassProgress(@Param('classForm') classForm: string, @Request() r: any) {
    return this.svc.getClassProgress(r.user.tenantId, classForm);
  }
}
