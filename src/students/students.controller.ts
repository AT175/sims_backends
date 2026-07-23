import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
  Request,
  ParseUUIDPipe,
} from '@nestjs/common';
import { StudentsService } from './students.service';
import { CreateStudentDto, UpdateStudentDto } from './student.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('students')
@UseGuards(JwtAuthGuard)
export class StudentsController {
  constructor(private readonly service: StudentsService) {}

  @Get()
  async findAll(@Request() req: any) {
    return this.service.findAll(req.user.tenantId);
  }

  @Get('candidates')
  async getCandidates(@Request() req: any) {
    return this.service.getCandidates(req.user.tenantId);
  }

  @Get('my-voter-id')
  async getMyVoterId(@Request() req: any) {
    return this.service.getStudentVoterId(req.user.userId, req.user.tenantId);
  }

  @Get(':id')
  async findOne(@Param('id', ParseUUIDPipe) id: string, @Request() req: any) {
    return this.service.findOne(id, req.user.tenantId);
  }

  @Post()
  @Roles('headmaster', 'asst_headmaster_admin', 'registry', 'system_admin')
  async create(@Body() dto: CreateStudentDto, @Request() req: any) {
    return this.service.create(dto, req.user.tenantId);
  }

  @Put(':id')
  @Roles('headmaster', 'asst_headmaster_admin', 'registry', 'system_admin')
  async update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateStudentDto,
    @Request() req: any,
  ) {
    return this.service.update(id, dto, req.user.tenantId);
  }

  @Delete(':id')
  @Roles('headmaster', 'asst_headmaster_admin', 'system_admin')
  async remove(@Param('id', ParseUUIDPipe) id: string, @Request() req: any) {
    await this.service.softDelete(id, req.user.tenantId);
    return { success: true };
  }

  @Post('generate-voter-ids')
  @Roles('headmaster', 'system_admin', 'registry')
  async generateVoterIds(@Request() req: any) {
    return this.service.generateVoterIds(req.user.tenantId);
  }

  @Post('cast-vote')
  async castVote(@Body() body: { voterId: string; candidateId: string }, @Request() req: any) {
    return this.service.castVote(body.voterId, body.candidateId, req.user.tenantId);
  }

  @Post('generate-temp-credentials')
  @Roles('headmaster', 'system_admin', 'registry')
  async generateTempCredentials(@Body() body: { studentId: string }, @Request() req: any) {
    return this.service.generateTempCredentials(body.studentId, req.user.tenantId);
  }

  @Post('verify-voter')
  async verifyVoter(@Body() body: { voterId: string }, @Request() req: any) {
    return this.service.verifyVoter(body.voterId, req.user.tenantId);
  }

  @Post('seed')
  @Roles('headmaster', 'system_admin')
  async seedStudents(@Request() req: any) {
    return this.service.seedStudents(req.user.tenantId);
  }
}
