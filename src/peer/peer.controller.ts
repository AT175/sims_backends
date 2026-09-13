import { Controller, Get, Post, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { PeerService } from './peer.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('peer')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class PeerController {
  constructor(private readonly svc: PeerService) {}

  // ── Q&A Forum ──────────────────────────────────────────────

  @Post('questions')
  @Roles('student', 'system_admin')
  async askQuestion(@Body() body: any, @Request() r: any) {
    return this.svc.askQuestion(r.user.id, r.user.displayName, r.user.tenantId, r.user.schoolLevel || 'basic6', body);
  }

  @Get('questions')
  @Roles('student', 'teacher', 'headmaster', 'system_admin')
  async getQuestions(@Query('subject') subject: string, @Query('classForm') classForm: string, @Query('tag') tag: string, @Query('status') status: string, @Request() r: any) {
    return this.svc.getQuestions(r.user.tenantId, { subject, classForm, tag, status });
  }

  @Get('questions/:id')
  async getQuestion(@Param('id') id: string, @Request() r: any) {
    return this.svc.getQuestion(id, r.user.tenantId);
  }

  @Post('questions/:id/answers')
  @Roles('student', 'system_admin')
  async answerQuestion(@Param('id') id: string, @Body() body: { content: string }, @Request() r: any) {
    return this.svc.answerQuestion(id, r.user.id, r.user.displayName, r.user.tenantId, body.content);
  }

  @Post('questions/:id/upvote')
  async upvoteQuestion(@Param('id') id: string, @Request() r: any) {
    return this.svc.upvoteQuestion(id, r.user.tenantId);
  }

  @Post('answers/:id/upvote')
  async upvoteAnswer(@Param('id') id: string, @Request() r: any) {
    return this.svc.upvoteAnswer(id, r.user.tenantId);
  }

  @Post('questions/:questionId/accept/:answerId')
  @Roles('student', 'system_admin')
  async acceptAnswer(@Param('questionId') questionId: string, @Param('answerId') answerId: string, @Request() r: any) {
    return this.svc.acceptAnswer(questionId, answerId, r.user.tenantId);
  }

  @Post('questions/:id/flag')
  @Roles('student', 'teacher', 'system_admin')
  async flagQuestion(@Param('id') id: string, @Request() r: any) {
    return this.svc.flagQuestion(id, r.user.tenantId);
  }

  @Post('questions/:id/pin')
  @Roles('teacher', 'headmaster', 'system_admin')
  async pinQuestion(@Param('id') id: string, @Request() r: any) {
    return this.svc.pinQuestion(id, r.user.tenantId);
  }

  @Get('leaderboard')
  async getLeaderboard(@Request() r: any) {
    return this.svc.getLeaderboard(r.user.tenantId);
  }

  // ── Study Groups ───────────────────────────────────────────

  @Post('groups')
  @Roles('student', 'teacher', 'system_admin')
  async createGroup(@Body() body: any, @Request() r: any) {
    return this.svc.createStudyGroup(r.user.id, r.user.displayName, r.user.tenantId, body);
  }

  @Get('groups')
  async getGroups(@Query('subject') subject: string, @Request() r: any) {
    return this.svc.getStudyGroups(r.user.tenantId, subject);
  }

  @Post('groups/:id/join')
  @Roles('student', 'system_admin')
  async joinGroup(@Param('id') id: string, @Request() r: any) {
    return this.svc.joinStudyGroup(id, r.user.id, r.user.tenantId);
  }

  @Post('groups/:id/messages')
  @Roles('student', 'system_admin')
  async postMessage(@Param('id') id: string, @Body() body: { content: string }, @Request() r: any) {
    return this.svc.postGroupMessage(id, r.user.id, r.user.displayName, r.user.tenantId, body.content);
  }

  @Get('groups/:id/messages')
  async getMessages(@Param('id') id: string, @Request() r: any) {
    return this.svc.getGroupMessages(id, r.user.tenantId);
  }
}
