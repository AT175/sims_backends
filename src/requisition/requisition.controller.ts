import { Controller, Get, Post, Put, Body, Param, Query, UseGuards, Request, ParseUUIDPipe } from '@nestjs/common';
import { RequisitionService } from './requisition.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CreateRequisitionDto, UpdateRequisitionStatusDto } from './requisition.dto';

@Controller('requisitions')
@UseGuards(JwtAuthGuard)
export class RequisitionController {
  constructor(private readonly service: RequisitionService) {}

  @Get()
  async getAll(@Query('department') department: string, @Request() req: any) {
    if (department) return this.service.getByDepartment(department, req.user.tenantId);
    return this.service.getAll(req.user.tenantId);
  }

  @Post()
  async create(@Body() data: CreateRequisitionDto, @Request() req: any) {
    return this.service.create(data, req.user.tenantId);
  }

  @Put(':id/status')
  @Roles('headmaster', 'stores', 'system_admin', 'asst_headmaster_domestic', 'senior_housemaster')
  async updateStatus(@Param('id', ParseUUIDPipe) id: string, @Body() body: UpdateRequisitionStatusDto, @Request() req: any) {
    return this.service.updateStatus(id, body.status, req.user.tenantId);
  }
}
