import { RolesGuard } from '../auth/roles.guard';
import { Controller, Get, Post, Put, Body, Param, UseGuards, Request, ParseUUIDPipe } from '@nestjs/common';
import { CounsellingService } from './counselling.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CreateCounsellingCaseDto, UpdateCaseStatusDto } from './counselling.dto';

@Controller('counselling')
@UseGuards(JwtAuthGuard, RolesGuard)
export class CounsellingController {
  constructor(private readonly service: CounsellingService) {}

  @Get('cases')
  async getCases(@Request() req: any) { return this.service.getCases(req.user.tenantId); }

  @Post('cases')
  @Roles('headmaster', 'counselling', 'system_admin')
  async createCase(@Body() data: CreateCounsellingCaseDto, @Request() req: any) { return this.service.createCase(data, req.user.tenantId); }

  @Put('cases/:id/status')
  @Roles('headmaster', 'counselling', 'system_admin')
  async updateCaseStatus(@Param('id', ParseUUIDPipe) id: string, @Body() body: UpdateCaseStatusDto, @Request() req: any) {
    return this.service.updateCaseStatus(id, body.status, req.user.tenantId);
  }
}
