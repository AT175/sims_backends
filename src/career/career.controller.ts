import { Controller, Get, Post, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { CareerService } from './career.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('career')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class CareerController {
  constructor(private readonly svc: CareerService) {}

  @Get('recommendations/:studentId')
  @Roles('student', 'parent', 'teacher', 'system_admin')
  async getRecommendations(@Param('studentId') studentId: string, @Request() r: any) {
    return this.svc.getRecommendations(studentId, r.user.tenantId);
  }

  @Get('opportunities')
  async getOpportunities(@Query('type') type: string) {
    return this.svc.getOpportunities(type);
  }

  @Get('paths')
  async getPaths(@Query('subjects') subjects: string) {
    return this.svc.getCareerPaths(subjects);
  }

  @Post('profile')
  @Roles('student', 'system_admin')
  async saveProfile(@Body() body: { studentId: string; interests: string[]; favoriteSubjects: string[]; preferredCareerPath?: string }, @Request() r: any) {
    return this.svc.saveProfile(body.studentId, r.user.tenantId, body);
  }

  @Post('save/:opportunityId')
  @Roles('student', 'system_admin')
  async saveOpportunity(@Param('opportunityId') opportunityId: string, @Body() body: { studentId: string }, @Request() r: any) {
    return this.svc.saveOpportunity(body.studentId, r.user.tenantId, opportunityId);
  }
}
