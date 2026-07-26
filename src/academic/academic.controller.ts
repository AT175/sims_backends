import { RolesGuard } from '../auth/roles.guard';
import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { AcademicService } from './academic.service';
import { CreateTimetableEntryDto, CreateExamResultDto, CreateAttendanceDto } from './academic.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('academic')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class AcademicController {
  constructor(private readonly service: AcademicService) {}

  // Timetable
  @Get('timetable')
  async getTimetable(@Query('class') classSection: string, @Request() req: any) {
    return this.service.getTimetable(classSection, req.user.tenantId);
  }

  @Post('timetable')
  @Roles('headmaster', 'asst_headmaster_academic', 'subject_hod', 'system_admin', 'teacher')
  async createTimetableEntry(@Body() dto: CreateTimetableEntryDto, @Request() req: any) {
    return this.service.createTimetableEntry(dto, req.user.tenantId);
  }

  // Results
  @Get('results')
  async getResults(@Query('student') studentName: string, @Query('term') term: string, @Request() req: any) {
    return this.service.getResults(studentName, term, req.user.tenantId);
  }

  @Post('results')
  @Roles('headmaster', 'asst_headmaster_academic', 'subject_hod', 'system_admin', 'teacher')
  async createResult(@Body() dto: CreateExamResultDto, @Request() req: any) {
    return this.service.createResult(dto, req.user.tenantId);
  }

  // Attendance
  @Get('attendance')
  async getAttendance(@Query('student') studentName: string, @Query('date') date: string, @Request() req: any) {
    return this.service.getAttendance(studentName, date, req.user.tenantId);
  }

  @Post('attendance')
  @Roles('headmaster', 'asst_headmaster_academic', 'subject_hod', 'system_admin', 'teacher')
  async createAttendance(@Body() dto: CreateAttendanceDto, @Request() req: any) {
    return this.service.createAttendance(dto, req.user.tenantId);
  }

  // Exams
  @Get('exams')
  async getExams(@Request() req: any) {
    return this.service.getExams(req.user.tenantId);
  }

  // HOD Approvals
  @Get('hod-approvals')
  async getHODApprovals(@Request() req: any) {
    return this.service.getHODApprovals(req.user.tenantId);
  }

  // Report Cards
  @Get('report-cards')
  async getReportCards(@Request() req: any) {
    return this.service.getReportCards(req.user.tenantId);
  }

  // Transcripts
  @Get('transcripts')
  async getTranscripts(@Request() req: any) {
    return this.service.getTranscripts(req.user.tenantId);
  }

  // SPIPs
  @Get('spips')
  async getSPIPs(@Request() req: any) {
    return this.service.getSPIPs(req.user.tenantId);
  }

  // Curriculum
  @Get('curriculum')
  async getCurriculum(@Request() req: any) {
    return this.service.getCurriculum(req.user.tenantId);
  }

  // Calendar
  @Get('calendar')
  async getCalendar(@Request() req: any) {
    return this.service.getCalendar(req.user.tenantId);
  }

  // Terms
  @Get('terms')
  async getTerms(@Request() req: any) {
    return this.service.getTerms(req.user.tenantId);
  }

  // Subject Performance
  @Get('subject-performance')
  async getSubjectPerformance(@Request() req: any) {
    return this.service.getSubjectPerformance(req.user.tenantId);
  }

  // Teacher Activity
  @Get('teacher-activity')
  async getTeacherActivity(@Request() req: any) {
    return this.service.getTeacherActivity(req.user.tenantId);
  }

  // Admission Insights
  @Get('admission-insights')
  async getAdmissionInsights(@Request() req: any) {
    return this.service.getAdmissionInsights(req.user.tenantId);
  }
}
