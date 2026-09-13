import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { TutorService } from './tutor.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('tutor')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class TutorController {
  constructor(private readonly svc: TutorService) {}

  @Post('ask')
  @Roles('student', 'system_admin')
  async ask(@Body() body: { subject: string; question: string; sessionId?: string }, @Request() r: any) {
    return this.svc.askQuestion(r.user.id, r.user.tenantId, body.subject, body.question, body.sessionId);
  }

  @Get('weak-areas/:studentId')
  @Roles('student', 'parent', 'teacher', 'system_admin')
  async getWeakAreas(@Param('studentId') studentId: string, @Request() r: any) {
    return this.svc.getWeakAreas(studentId, r.user.tenantId);
  }

  @Get('history/:studentId')
  @Roles('student', 'parent', 'teacher', 'system_admin')
  async getHistory(@Param('studentId') studentId: string, @Request() r: any) {
    return this.svc.getSessionHistory(studentId, r.user.tenantId);
  }

  @Get('session/:sessionId')
  @Roles('student', 'parent', 'teacher', 'system_admin')
  async getSession(@Param('sessionId') sessionId: string, @Request() r: any) {
    return this.svc.getSession(sessionId, r.user.tenantId);
  }
}
