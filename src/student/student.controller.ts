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
  async getProfile(@Request() r: any) { return this.svc.getProfile(r.user.id, r.user.tenantId); }

  @Get('classes')
  async getClasses(@Request() r: any) { return this.svc.getClasses(r.user.id, r.user.tenantId); }

  @Get('materials')
  async getMaterials(@Request() r: any) { return this.svc.getMaterials(r.user.id, r.user.tenantId); }

  @Get('assignments')
  async getAssignments(@Request() r: any) { return this.svc.getAssignments(r.user.id, r.user.tenantId); }

  @Post('assignments/submit')
  async submitAssignment(@Body() d: dto.SubmitAssignmentDto, @Request() r: any) {
    return this.svc.submitAssignment(r.user.id, r.user.tenantId, d);
  }

  @Get('results')
  async getResults(@Request() r: any) { return this.svc.getResults(r.user.id, r.user.tenantId); }

  @Get('attendance')
  async getAttendance(@Request() r: any) { return this.svc.getAttendance(r.user.id, r.user.tenantId); }

  @Get('health')
  async getHealth(@Request() r: any) { return this.svc.getHealthRecords(r.user.id, r.user.tenantId); }

  @Get('feedback')
  async getFeedback(@Request() r: any) { return this.svc.getFeedback(r.user.id, r.user.tenantId); }

  @Post('feedback')
  async createFeedback(@Body() d: dto.CreateFeedbackDto, @Request() r: any) {
    return this.svc.createFeedback(r.user.id, r.user.tenantId, d);
  }

  @Get('fees')
  async getFees(@Request() r: any) { return this.svc.getFees(r.user.id, r.user.tenantId); }

  @Get('library')
  async getLibrary(@Request() r: any) { return this.svc.getLibrary(r.user.id, r.user.tenantId); }

  // ── Exeat Requests ──
  @Get('exeats')
  async getMyExeats(@Request() r: any) { return this.svc.getMyExeats(r.user.id, r.user.tenantId); }

  @Post('exeats')
  async requestExeat(@Body() d: dto.RequestExeatDto, @Request() r: any) {
    return this.svc.requestExeat(r.user.id, r.user.tenantId, d);
  }

  // ── Teacher Content ──
  @Get('announcements')
  async getAnnouncements(@Request() r: any) { return this.svc.getTeacherAnnouncements(r.user.id, r.user.tenantId); }

  @Get('teacher-materials')
  async getTeacherMaterials(@Request() r: any) { return this.svc.getTeacherMaterials(r.user.id, r.user.tenantId); }

  @Get('live-sessions')
  async getLiveSessions(@Request() r: any) { return this.svc.getLiveSessions(r.user.id, r.user.tenantId); }

  @Get('av-recordings')
  async getAVRecordings(@Request() r: any) { return this.svc.getAVRecordings(r.user.id, r.user.tenantId); }

  @Get('shared-resources')
  async getSharedResources(@Request() r: any) { return this.svc.getSharedResources(r.user.id, r.user.tenantId); }

  @Get('quizzes')
  async getQuizzes(@Request() r: any) { return this.svc.getQuizzes(r.user.id, r.user.tenantId); }

  // ── House Info ──
  @Get('house/roll-calls')
  async getHouseRollCalls(@Request() r: any) { return this.svc.getHouseRollCalls(r.user.id, r.user.tenantId); }

  @Get('house/discipline')
  async getHouseDiscipline(@Request() r: any) { return this.svc.getHouseDiscipline(r.user.id, r.user.tenantId); }

  // ── Messages ──
  @Get('messages')
  async getMessages(@Request() r: any) { return this.svc.getMessages(r.user.id, r.user.tenantId); }

  @Post('messages')
  async createMessage(@Body() d: dto.CreateStudentMessageDto, @Request() r: any) {
    return this.svc.createMessage(r.user.id, r.user.tenantId, d);
  }
}
