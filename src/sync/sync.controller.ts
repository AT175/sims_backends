import { RolesGuard } from '../auth/roles.guard';
import {
  Controller,
  Post,
  Get,
  Body,
  Query,
  Param,
  UseGuards,
  Request,
  BadRequestException,
} from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { SyncService, PushRequest } from './sync.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { TenantsService } from '../tenants/tenants.service';

@Controller('sync')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class SyncController {
  constructor(
    private readonly syncService: SyncService,
    private readonly tenantsService: TenantsService,
  ) {}

  @Post('push')
  @Roles('system_admin', 'registry', 'headmaster', 'teacher', 'bursary', 'accountant', 'asst_headmaster_academic', 'asst_headmaster_admin')
  async push(
    @Body() body: PushRequest | PushRequest[],
    @Request() req: any,
  ) {
    const tenantId = req.user.tenantId;
    const items = Array.isArray(body) ? body : [body];
    const validOperations = ['create', 'update', 'delete'];
    const validEntities = [
      'student', 'admission', 'user',
      'staff', 'attendance', 'exam_result', 'report_card',
      'timetable', 'exam', 'curriculum', 'transcript',
      'fee_payment', 'expenditure', 'lesson_material',
      'assignment', 'submission', 'assessment',
    ];
    for (const item of items) {
      if (!item.entityType || !validEntities.includes(item.entityType)) {
        throw new BadRequestException(`Invalid or unsupported entity type: ${item.entityType}`);
      }
      if (!item.operation || !validOperations.includes(item.operation)) {
        throw new BadRequestException(`Invalid operation: ${item.operation}`);
      }
      if (!item.entityId || !item.timestamp) {
        throw new BadRequestException('entityId and timestamp are required');
      }
    }
    const results = await this.syncService.push(items, tenantId);
    return { results };
  }

  @Get('pull')
  @Roles('system_admin', 'registry', 'headmaster', 'teacher', 'bursary', 'accountant', 'asst_headmaster_academic', 'asst_headmaster_admin')
  async pull(
    @Query('table') table: string,
    @Query('since') since: string,
    @Request() req: any,
  ) {
    const tenantId = req.user.tenantId;
    const validTables = [
      'students', 'admissions', 'users',
      'staff', 'attendance', 'exam_results', 'report_cards',
      'timetables', 'exams', 'curriculum', 'transcripts',
      'fee_payments', 'expenditure_entries',
      'lesson_materials', 'assignments', 'submissions', 'assessments',
    ];
    if (!table || !validTables.includes(table)) {
      throw new BadRequestException(`Invalid table: ${table}`);
    }
    const sinceDate = since || '1970-01-01T00:00:00.000Z';
    if (isNaN(Date.parse(sinceDate))) {
      throw new BadRequestException('Invalid since date format');
    }
    return this.syncService.pull(table, sinceDate, tenantId);
  }

  @Get('branding/:tenantKey')
  async pullBranding(
    @Param('tenantKey') tenantKey: string,
    @Query('since') since: string,
  ) {
    const branding = await this.tenantsService.getPublicBranding(tenantKey);
    const sinceDate = since || '1970-01-01T00:00:00.000Z';
    const brandingUpdated = new Date((branding as any).updatedAt || 0);
    if (brandingUpdated > new Date(sinceDate)) {
      return { updated: true, branding };
    }
    return { updated: false, branding: null };
  }

  @Get('status')
  async status(@Request() req: any) {
    const tenantId = req.user.tenantId;
    return this.syncService.getStatus(tenantId);
  }
}
