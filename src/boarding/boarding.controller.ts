import {
  Controller, Get, Post, Put, Body, Param, Query, UseGuards, Request, ParseUUIDPipe,
} from '@nestjs/common';
import { BoardingService } from './boarding.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CreateExeatDto, UpdateExeatStatusDto, CreateRollCallDto, CreateDisciplineLogDto } from './boarding.dto';

@Controller('boarding')
@UseGuards(JwtAuthGuard)
export class BoardingController {
  constructor(private readonly service: BoardingService) {}

  @Get('exeats')
  async getExeats(@Request() req: any) {
    return this.service.getExeats(req.user.tenantId);
  }

  @Post('exeats')
  @Roles('headmaster', 'asst_headmaster_domestic', 'senior_housemaster', 'senior_housemistress', 'housemaster', 'housemistress', 'system_admin', 'registry')
  async createExeat(@Body() data: CreateExeatDto, @Request() req: any) {
    return this.service.createExeat(data, req.user.tenantId);
  }

  @Put('exeats/:id/status')
  @Roles('headmaster', 'asst_headmaster_domestic', 'senior_housemaster', 'senior_housemistress', 'system_admin')
  async updateExeatStatus(@Param('id', ParseUUIDPipe) id: string, @Body() body: UpdateExeatStatusDto, @Request() req: any) {
    return this.service.updateExeatStatus(id, body.status, req.user.displayName || 'Admin', req.user.tenantId);
  }

  @Get('roll-call')
  async getRollCalls(@Query('house') house: string, @Request() req: any) {
    return this.service.getRollCalls(house, req.user.tenantId);
  }

  @Post('roll-call')
  @Roles('headmaster', 'asst_headmaster_domestic', 'senior_housemaster', 'senior_housemistress', 'housemaster', 'housemistress', 'system_admin')
  async createRollCall(@Body() data: CreateRollCallDto, @Request() req: any) {
    return this.service.createRollCall(data, req.user.tenantId);
  }

  @Get('discipline')
  async getDisciplineLogs(@Request() req: any) {
    return this.service.getDisciplineLogs(req.user.tenantId);
  }

  @Post('discipline')
  @Roles('headmaster', 'asst_headmaster_domestic', 'senior_housemaster', 'senior_housemistress', 'housemaster', 'housemistress', 'system_admin')
  async createDisciplineLog(@Body() data: CreateDisciplineLogDto, @Request() req: any) {
    return this.service.createDisciplineLog(data, req.user.tenantId);
  }
}
