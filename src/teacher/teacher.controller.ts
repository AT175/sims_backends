import { Controller, Get, Post, Put, Delete, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { TeacherService } from './teacher.service';
import * as dto from './teacher.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('teacher')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class TeacherController {
  constructor(private readonly svc: TeacherService) {}

  private tId(req: any): string { return req.user.tenantId; }
  private uId(req: any): string { return req.user.userId || req.user.username || 'unknown'; }
  private uName(req: any): string { return req.user.displayName || req.user.username || 'Teacher'; }

  // ── Lesson Plans ──
  @Get('lesson-plans') async getLessonPlans(@Request() r: any) { return this.svc.getLessonPlans(this.tId(r)); }
  @Post('lesson-plans') @Roles('teacher') async createLessonPlan(@Body() d: dto.CreateLessonPlanDto, @Request() r: any) { return this.svc.createLessonPlan(d, this.tId(r), this.uId(r)); }
  @Put('lesson-plans/:id') async updateLessonPlan(@Param('id') id: string, @Body() d: dto.UpdateLessonPlanDto, @Request() r: any) { return this.svc.updateLessonPlan(id, d, this.tId(r)); }
  @Delete('lesson-plans/:id') async deleteLessonPlan(@Param('id') id: string, @Request() r: any) { return this.svc.deleteLessonPlan(id, this.tId(r)); }
  @Post('lesson-plans/:id/mark-taught') async markLessonTaught(@Param('id') id: string, @Body('reflection') reflection: string, @Request() r: any) { return this.svc.markLessonTaught(id, reflection, this.tId(r)); }

  // ── Assignments ──
  @Get('assignments') async getAssignments(@Request() r: any) { return this.svc.getAssignments(this.tId(r)); }
  @Post('assignments') @Roles('teacher') async createAssignment(@Body() d: dto.CreateAssignmentDto, @Request() r: any) { return this.svc.createAssignment(d, this.tId(r), this.uId(r)); }
  @Post('assignments/:id/publish') async publishAssignment(@Param('id') id: string, @Request() r: any) { return this.svc.publishAssignment(id, this.tId(r)); }
  @Post('assignments/:id/close') async closeAssignment(@Param('id') id: string, @Request() r: any) { return this.svc.closeAssignment(id, this.tId(r)); }
  @Delete('assignments/:id') async deleteAssignment(@Param('id') id: string, @Request() r: any) { return this.svc.deleteAssignment(id, this.tId(r)); }
  @Post('assignments/:id/grade') async gradeSubmission(@Param('id') id: string, @Body() d: dto.GradeSubmissionDto, @Request() r: any) { return this.svc.gradeSubmission(id, d, this.tId(r)); }
  @Post('assignments/:id/bulk-grade') async bulkGrade(@Param('id') id: string, @Body() d: dto.BulkGradeDto, @Request() r: any) { return this.svc.bulkGrade(id, d, this.tId(r)); }
  @Post('assignments/:id/duplicate') async duplicateAssignment(@Param('id') id: string, @Body('classForm') classForm: string, @Request() r: any) { return this.svc.duplicateAssignment(id, classForm, this.tId(r), this.uId(r)); }

  // ── Gradebook ──
  @Get('gradebook') async getGradebook(@Query('classForm') classForm: string, @Query('subject') subject: string, @Request() r: any) { return this.svc.getGradebook(this.tId(r), classForm, subject); }
  @Post('gradebook') async createGradebook(@Body() d: dto.CreateGradebookDto, @Request() r: any) { return this.svc.createGradebook(d, this.tId(r)); }
  @Delete('gradebook/:id') async deleteGradebook(@Param('id') id: string, @Request() r: any) { return this.svc.deleteGradebook(id, this.tId(r)); }

  // ── Attendance ──
  @Get('attendance') async getAttendance(@Query('classForm') classForm: string, @Query('date') date: string, @Request() r: any) { return this.svc.getAttendance(this.tId(r), classForm, date); }
  @Post('attendance') async createAttendance(@Body() d: dto.CreateAttendanceDto, @Request() r: any) { return this.svc.createAttendance(d, this.tId(r)); }
  @Post('attendance/bulk') async bulkAttendance(@Body() d: dto.BulkAttendanceDto, @Request() r: any) { return this.svc.bulkAttendance(d, this.tId(r)); }

  // ── Syllabus ──
  @Get('syllabus') async getSyllabus(@Query('subject') subject: string, @Query('classForm') classForm: string, @Request() r: any) { return this.svc.getSyllabus(this.tId(r), subject, classForm); }
  @Post('syllabus') async createSyllabus(@Body() d: dto.CreateSyllabusDto, @Request() r: any) { return this.svc.createSyllabus(d, this.tId(r)); }
  @Put('syllabus/:id') async updateSyllabus(@Param('id') id: string, @Body() d: dto.UpdateSyllabusDto, @Request() r: any) { return this.svc.updateSyllabus(id, d, this.tId(r)); }
  @Delete('syllabus/:id') async deleteSyllabus(@Param('id') id: string, @Request() r: any) { return this.svc.deleteSyllabus(id, this.tId(r)); }

  // ── Materials ──
  @Get('materials') async getMaterials(@Request() r: any) { return this.svc.getMaterials(this.tId(r)); }
  @Post('materials') async createMaterial(@Body() d: dto.CreateMaterialDto, @Request() r: any) { return this.svc.createMaterial(d, this.tId(r), this.uName(r)); }
  @Delete('materials/:id') async deleteMaterial(@Param('id') id: string, @Request() r: any) { return this.svc.deleteMaterial(id, this.tId(r)); }

  // ── AV Recordings ──
  @Get('av-recordings') async getAV(@Request() r: any) { return this.svc.getAV(this.tId(r)); }
  @Post('av-recordings') async createAV(@Body() d: dto.CreateAVDto, @Request() r: any) { return this.svc.createAV(d, this.tId(r), this.uName(r)); }
  @Delete('av-recordings/:id') async deleteAV(@Param('id') id: string, @Request() r: any) { return this.svc.deleteAV(id, this.tId(r)); }

  // ── Live Sessions ──
  @Get('live-sessions') async getLiveSessions(@Request() r: any) { return this.svc.getLiveSessions(this.tId(r)); }
  @Post('live-sessions') async createLiveSession(@Body() d: dto.CreateLiveSessionDto, @Request() r: any) { return this.svc.createLiveSession(d, this.tId(r)); }
  @Post('live-sessions/:id/start') async startLiveSession(@Param('id') id: string, @Request() r: any) { return this.svc.startLiveSession(id, this.uName(r), this.tId(r)); }
  @Post('live-sessions/:id/end') async endLiveSession(@Param('id') id: string, @Request() r: any) { return this.svc.endLiveSession(id, this.tId(r)); }
  @Post('live-sessions/:id/cancel') async cancelLiveSession(@Param('id') id: string, @Request() r: any) { return this.svc.cancelLiveSession(id, this.tId(r)); }

  // ── Announcements ──
  @Get('announcements') async getAnnouncements(@Request() r: any) { return this.svc.getAnnouncements(this.tId(r)); }
  @Post('announcements') async createAnnouncement(@Body() d: dto.CreateAnnouncementDto, @Request() r: any) { return this.svc.createAnnouncement(d, this.tId(r), this.uName(r)); }
  @Delete('announcements/:id') async deleteAnnouncement(@Param('id') id: string, @Request() r: any) { return this.svc.deleteAnnouncement(id, this.tId(r)); }

  // ── Question Bank ──
  @Get('questions') async getQuestions(@Request() r: any) { return this.svc.getQuestions(this.tId(r)); }
  @Post('questions') async createQuestion(@Body() d: dto.CreateQuestionDto, @Request() r: any) { return this.svc.createQuestion(d, this.tId(r)); }
  @Delete('questions/:id') async deleteQuestion(@Param('id') id: string, @Request() r: any) { return this.svc.deleteQuestion(id, this.tId(r)); }

  // ── Quizzes ──
  @Get('quizzes') async getQuizzes(@Request() r: any) { return this.svc.getQuizzes(this.tId(r)); }
  @Post('quizzes') async createQuiz(@Body() d: dto.CreateQuizDto, @Request() r: any) { return this.svc.createQuiz(d, this.tId(r)); }
  @Post('quizzes/:id/publish') async publishQuiz(@Param('id') id: string, @Request() r: any) { return this.svc.publishQuiz(id, this.tId(r)); }
  @Post('quizzes/:id/close') async closeQuiz(@Param('id') id: string, @Request() r: any) { return this.svc.closeQuiz(id, this.tId(r)); }
  @Delete('quizzes/:id') async deleteQuiz(@Param('id') id: string, @Request() r: any) { return this.svc.deleteQuiz(id, this.tId(r)); }

  // ── Parent Comms ──
  @Get('parent-comms') async getParentComms(@Request() r: any) { return this.svc.getParentComms(this.tId(r)); }
  @Post('parent-comms') async createParentComm(@Body() d: dto.CreateParentCommDto, @Request() r: any) { return this.svc.createParentComm(d, this.tId(r)); }
  @Delete('parent-comms/:id') async deleteParentComm(@Param('id') id: string, @Request() r: any) { return this.svc.deleteParentComm(id, this.tId(r)); }

  // ── Behavior Notes ──
  @Get('behavior-notes') async getBehaviorNotes(@Request() r: any) { return this.svc.getBehaviorNotes(this.tId(r)); }
  @Post('behavior-notes') async createBehaviorNote(@Body() d: dto.CreateBehaviorNoteDto, @Request() r: any) { return this.svc.createBehaviorNote(d, this.tId(r), this.uName(r)); }
  @Delete('behavior-notes/:id') async deleteBehaviorNote(@Param('id') id: string, @Request() r: any) { return this.svc.deleteBehaviorNote(id, this.tId(r)); }

  // ── Calendar Events ──
  @Get('calendar-events') async getCalendarEvents(@Query('year') year: number, @Query('month') month: number, @Request() r: any) { return this.svc.getCalendarEvents(this.tId(r), year ? Number(year) : undefined, month !== undefined ? Number(month) : undefined); }
  @Post('calendar-events') async createCalendarEvent(@Body() d: dto.CreateCalendarEventDto, @Request() r: any) { return this.svc.createCalendarEvent(d, this.tId(r)); }
  @Delete('calendar-events/:id') async deleteCalendarEvent(@Param('id') id: string, @Request() r: any) { return this.svc.deleteCalendarEvent(id, this.tId(r)); }

  // ── Shared Resources ──
  @Get('shared-resources') async getSharedResources(@Request() r: any) { return this.svc.getSharedResources(this.tId(r)); }
  @Post('shared-resources') async createSharedResource(@Body() d: dto.CreateSharedResourceDto, @Request() r: any) { return this.svc.createSharedResource(d, this.tId(r), this.uName(r)); }
  @Delete('shared-resources/:id') async deleteSharedResource(@Param('id') id: string, @Request() r: any) { return this.svc.deleteSharedResource(id, this.tId(r)); }

  // ── Notifications ──
  @Get('notifications') async getNotifications(@Request() r: any) { return this.svc.getNotifications(this.tId(r)); }
  @Post('notifications/:id/read') async markNotificationRead(@Param('id') id: string, @Request() r: any) { return this.svc.markNotificationRead(id, this.tId(r)); }
  @Post('notifications/read-all') async markAllNotificationsRead(@Request() r: any) { return this.svc.markAllNotificationsRead(this.tId(r)); }

  // ── Remedial ──
  @Get('remedial') async getRemedial(@Request() r: any) { return this.svc.getRemedial(this.tId(r)); }
  @Post('remedial') async createRemedial(@Body() d: dto.CreateRemedialDto, @Request() r: any) { return this.svc.createRemedial(d, this.tId(r)); }
  @Put('remedial/:id') async updateRemedial(@Param('id') id: string, @Body() d: dto.UpdateRemedialDto, @Request() r: any) { return this.svc.updateRemedial(id, d, this.tId(r)); }
  @Delete('remedial/:id') async deleteRemedial(@Param('id') id: string, @Request() r: any) { return this.svc.deleteRemedial(id, this.tId(r)); }

  // ── Analytics ──
  @Get('analytics/class') async getClassAnalytics(@Query('classForm') classForm: string, @Query('subject') subject: string, @Request() r: any) { return this.svc.getClassAnalytics(this.tId(r), classForm, subject); }
  @Get('analytics/attendance') async getAttendanceAnalytics(@Query('classForm') classForm: string, @Request() r: any) { return this.svc.getAttendanceAnalytics(this.tId(r), classForm); }

  // ── Student Profile ──
  @Get('students/:admNo/profile') async getStudentProfile(@Param('admNo') admNo: string, @Request() r: any) { return this.svc.getStudentProfile(this.tId(r), admNo); }

  // ── AI Lesson Plan ──
  @Post('ai-lesson-plan') async generateAILessonPlan(@Body() d: dto.AILessonPlanDto) { return this.svc.generateAILessonPlan(d); }
}
