import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AcademicService } from './academic.service';
import { CreateTimetableEntryDto, CreateExamResultDto, CreateAttendanceDto } from './academic.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('academic')
@UseGuards(JwtAuthGuard)
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
}
