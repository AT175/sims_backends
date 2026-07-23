import { Controller, Get, Post, Put, Body, Param, UseGuards, Request, ParseUUIDPipe } from '@nestjs/common';
import { CleaningService } from './cleaning.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CreateCleaningTaskDto, CreateMaintenanceIssueDto } from './cleaning.dto';

@Controller('cleaning')
@UseGuards(JwtAuthGuard)
export class CleaningController {
  constructor(private readonly service: CleaningService) {}

  @Get('tasks')
  async getTasks(@Request() req: any) { return this.service.getTasks(req.user.tenantId); }

  @Post('tasks')
  @Roles('headmaster', 'cleaning', 'system_admin')
  async createTask(@Body() data: CreateCleaningTaskDto, @Request() req: any) { return this.service.createTask(data, req.user.tenantId); }

  @Put('tasks/:id/toggle')
  async toggleTaskDone(@Param('id', ParseUUIDPipe) id: string, @Request() req: any) {
    return this.service.toggleTaskDone(id, req.user.tenantId);
  }

  @Get('issues')
  async getIssues(@Request() req: any) { return this.service.getIssues(req.user.tenantId); }

  @Post('issues')
  @Roles('headmaster', 'cleaning', 'system_admin')
  async createIssue(@Body() data: CreateMaintenanceIssueDto, @Request() req: any) { return this.service.createIssue(data, req.user.tenantId); }
}
