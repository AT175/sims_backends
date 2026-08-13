import {
  Controller,
  Post,
  Get,
  Body,
  Query,
  UseGuards,
  Request,
  BadRequestException,
} from '@nestjs/common';
import { SyncService, PushRequest } from './sync.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('sync')
@UseGuards(JwtAuthGuard)
export class SyncController {
  constructor(private readonly syncService: SyncService) {}

  @Post('push')
  @Roles('system_admin', 'registry', 'headmaster')
  async push(
    @Body() body: PushRequest | PushRequest[],
    @Request() req: any,
  ) {
    const tenantId = req.user.tenantId;
    const items = Array.isArray(body) ? body : [body];
    const validOperations = ['create', 'update', 'delete'];
    const validEntities = ['student', 'admission', 'user'];
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
  @Roles('system_admin', 'registry', 'headmaster')
  async pull(
    @Query('table') table: string,
    @Query('since') since: string,
    @Request() req: any,
  ) {
    const tenantId = req.user.tenantId;
    const validTables = ['students', 'admissions', 'users'];
    if (!table || !validTables.includes(table)) {
      throw new BadRequestException(`Invalid table: ${table}`);
    }
    const sinceDate = since || '1970-01-01T00:00:00.000Z';
    if (isNaN(Date.parse(sinceDate))) {
      throw new BadRequestException('Invalid since date format');
    }
    return this.syncService.pull(table, sinceDate, tenantId);
  }
}
