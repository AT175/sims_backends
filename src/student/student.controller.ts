import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { StudentService } from './student.service';
import * as dto from './student.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';

@Controller('student')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class StudentController {
  constructor(private readonly svc: StudentService) {}

  @Get('profile')
  async getProfile(@Request() r: any) { return this.svc.getProfile(r.user.userId, r.user.tenantId); }

  @Get('classes')
  async getClasses(@Request() r: any) { return this.svc.getClasses(r.user.userId, r.user.tenantId); }

  @Get('materials')
  async getMaterials(@Request() r: any) { return this.svc.getMaterials(r.user.userId, r.user.tenantId); }

  @Get('assignments')
  async getAssignments(@Request() r: any) { return this.svc.getAssignments(r.user.userId, r.user.tenantId); }

  @Post('assignments/submit')
  async submitAssignment(@Body() d: dto.SubmitAssignmentDto, @Request() r: any) {
    return this.svc.submitAssignment(r.user.userId, r.user.tenantId, d);
  }

  @Get('results')
  async getResults(@Request() r: any) { return this.svc.getResults(r.user.userId, r.user.tenantId); }

  @Get('attendance')
  async getAttendance(@Request() r: any) { return this.svc.getAttendance(r.user.userId, r.user.tenantId); }

  @Get('health')
  async getHealth(@Request() r: any) { return this.svc.getHealthRecords(r.user.userId, r.user.tenantId); }

  @Get('feedback')
  async getFeedback(@Request() r: any) { return this.svc.getFeedback(r.user.userId, r.user.tenantId); }

  @Post('feedback')
  async createFeedback(@Body() d: dto.CreateFeedbackDto, @Request() r: any) {
    return this.svc.createFeedback(r.user.userId, r.user.tenantId, d);
  }

  @Get('fees')
  async getFees(@Request() r: any) { return this.svc.getFees(r.user.userId, r.user.tenantId); }

  @Get('library')
  async getLibrary(@Request() r: any) { return this.svc.getLibrary(r.user.userId, r.user.tenantId); }
}
