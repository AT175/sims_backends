import { RolesGuard } from '../auth/roles.guard';
import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { PromotionService } from './promotion.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('academic/promotion')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class PromotionController {
  constructor(private readonly service: PromotionService) {}

  // Config
  @Get('config')
  async getConfig(@Request() req: any) {
    return this.service.getConfig(req.user.tenantId);
  }

  @Post('config')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin')
  async updateConfig(@Body() dto: any, @Request() req: any) {
    return this.service.updateConfig(req.user.tenantId, dto);
  }

  // Promotion list for a level
  @Get('list')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin', 'subject_hod')
  async getPromotionList(@Query('level') level: string, @Request() req: any) {
    return this.service.getPromotionList(level || 'SHS1', req.user.tenantId);
  }

  // Promote a single student
  @Post('promote/:studentId')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin')
  async promoteStudent(@Param('studentId') studentId: string, @Request() req: any) {
    return this.service.promoteStudent(studentId, req.user.tenantId, req.user.username);
  }

  // Promote all eligible in a level
  @Post('promote-all/:level')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin')
  async promoteAll(@Param('level') level: string, @Request() req: any) {
    return this.service.promoteAll(level, req.user.tenantId, req.user.username);
  }

  // Repeat a student
  @Post('repeat/:studentId')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin')
  async repeatStudent(@Param('studentId') studentId: string, @Request() req: any) {
    return this.service.repeatStudent(studentId, req.user.tenantId, req.user.username);
  }

  // Graduate a single student
  @Post('graduate/:studentId')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin')
  async graduateStudent(@Param('studentId') studentId: string, @Request() req: any) {
    return this.service.graduateStudent(studentId, req.user.tenantId, req.user.username);
  }

  // Graduate all eligible
  @Post('graduate-all')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin')
  async graduateAll(@Request() req: any) {
    return this.service.graduateAll(req.user.tenantId, req.user.username);
  }

  // Graduation list
  @Get('graduation-list')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin', 'subject_hod')
  async getGraduationList(@Request() req: any) {
    return this.service.getGraduationList(req.user.tenantId);
  }

  // Promotion history
  @Get('history')
  @Roles('headmaster', 'asst_headmaster_academic', 'system_admin')
  async getHistory(@Request() req: any) {
    return this.service.getHistory(req.user.tenantId);
  }
}
