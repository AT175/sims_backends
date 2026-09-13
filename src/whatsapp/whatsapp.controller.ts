import { Controller, Get, Param, Query, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { WhatsappService } from './whatsapp.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('whatsapp')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class WhatsappController {
  constructor(private readonly svc: WhatsappService) {}

  @Get('recap/:studentId')
  @Roles('parent', 'headmaster', 'teacher', 'system_admin')
  async getRecapLink(@Param('studentId') studentId: string, @Request() r: any) {
    return this.svc.getRecapLink(studentId, r.user.tenantId);
  }

  @Get('fee-reminder/:studentId')
  @Roles('parent', 'headmaster', 'bursary', 'accountant', 'system_admin')
  async getFeeReminderLink(@Param('studentId') studentId: string, @Request() r: any) {
    return this.svc.getFeeReminderLink(studentId, r.user.tenantId);
  }

  @Get('attendance-alert/:studentId')
  @Roles('parent', 'headmaster', 'teacher', 'system_admin')
  async getAttendanceAlertLink(@Param('studentId') studentId: string, @Request() r: any) {
    return this.svc.getAttendanceAlertLink(studentId, r.user.tenantId);
  }

  @Get('result/:studentId')
  @Roles('parent', 'headmaster', 'teacher', 'system_admin')
  async getResultLink(@Param('studentId') studentId: string, @Query('term') term: string, @Request() r: any) {
    return this.svc.getResultLink(studentId, r.user.tenantId, term);
  }

  @Get('bulk-fee-reminders')
  @Roles('headmaster', 'bursary', 'accountant', 'system_admin')
  async getBulkFeeReminders(@Request() r: any) {
    return this.svc.getBulkFeeReminderLinks(r.user.tenantId);
  }
}
