import { RolesGuard } from '../auth/roles.guard';
import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { SecurityService } from './security.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CreateIncidentDto, CreateGateLogDto } from './security.dto';

@Controller('security')
@UseGuards(JwtAuthGuard, RolesGuard)
export class SecurityController {
  constructor(private readonly service: SecurityService) {}

  @Get('incidents')
  async getIncidents(@Request() req: any) { return this.service.getIncidents(req.user.tenantId); }

  @Post('incidents')
  @Roles('headmaster', 'security', 'system_admin')
  async createIncident(@Body() data: CreateIncidentDto, @Request() req: any) { return this.service.createIncident(data, req.user.tenantId); }

  @Get('gate-logs')
  async getGateLogs(@Request() req: any) { return this.service.getGateLogs(req.user.tenantId); }

  @Post('gate-logs')
  @Roles('headmaster', 'security', 'system_admin')
  async createGateLog(@Body() data: CreateGateLogDto, @Request() req: any) { return this.service.createGateLog(data, req.user.tenantId); }
}
