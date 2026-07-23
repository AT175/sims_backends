import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  UseGuards,
  Request,
  ParseUUIDPipe,
} from '@nestjs/common';
import { StaffService } from './staff.service';
import { CreateStaffDto, CreateLeaveRequestDto, ReviewLeaveDto } from './staff.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('staff')
@UseGuards(JwtAuthGuard)
export class StaffController {
  constructor(private readonly service: StaffService) {}

  @Get()
  async getDirectory(@Request() req: any) {
    return this.service.getDirectory(req.user.tenantId);
  }

  @Post()
  @Roles('headmaster', 'asst_headmaster_admin', 'system_admin', 'registry')
  async createStaff(@Body() dto: CreateStaffDto, @Request() req: any) {
    return this.service.createStaff(dto, req.user.tenantId);
  }

  @Get('leave')
  async getLeaveRequests(@Request() req: any) {
    return this.service.getLeaveRequests(req.user.tenantId);
  }

  @Post('leave')
  async createLeaveRequest(@Body() dto: CreateLeaveRequestDto, @Request() req: any) {
    return this.service.createLeaveRequest(dto, req.user.tenantId);
  }

  @Put('leave/:id/review')
  @Roles('headmaster', 'asst_headmaster_admin', 'system_admin')
  async reviewLeaveRequest(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ReviewLeaveDto,
    @Request() req: any,
  ) {
    return this.service.reviewLeaveRequest(id, dto, req.user.displayName || 'Admin', req.user.tenantId);
  }
}
