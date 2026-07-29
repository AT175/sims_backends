import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  NotFoundException,
} from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { GesService } from './ges.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import {
  CreateGesOfficeDto,
  UpdateGesOfficeDto,
  CreateGesReportDto,
  UpdateGesReportStatusDto,
  AssignSchoolToOfficeDto,
} from './ges.dto';

const GES_ALL_ROLES = ['system_admin', 'ges_national', 'ges_regional', 'ges_district', 'siso', 'ges_auditor', 'emis'];
const GES_DIRECTOR_ROLES = ['system_admin', 'ges_national', 'ges_regional', 'ges_district'];

@Controller('ges')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class GesController {
  constructor(private readonly gesService: GesService) {}

  // ── Office endpoints ──

  @Get('offices')
  @Roles(...GES_ALL_ROLES)
  async findAllOffices(
    @Query('level') level?: string,
    @Query('parentId') parentId?: string,
  ) {
    return this.gesService.findAllOffices(level, parentId);
  }

  @Get('offices/tree')
  @Roles(...GES_ALL_ROLES)
  async getOfficeTree() {
    return this.gesService.getOfficeTree();
  }

  @Get('offices/:id')
  @Roles(...GES_ALL_ROLES)
  async findOfficeById(@Param('id') id: string) {
    return this.gesService.findOfficeById(id);
  }

  @Post('offices')
  @Roles('system_admin', 'ges_national')
  async createOffice(@Body() dto: CreateGesOfficeDto) {
    return this.gesService.createOffice(dto);
  }

  @Put('offices/:id')
  @Roles('system_admin', 'ges_national', 'ges_regional')
  async updateOffice(@Param('id') id: string, @Body() dto: UpdateGesOfficeDto) {
    return this.gesService.updateOffice(id, dto);
  }

  @Delete('offices/:id')
  @Roles('system_admin', 'ges_national')
  async deleteOffice(@Param('id') id: string) {
    return this.gesService.deleteOffice(id);
  }

  // ── Report endpoints ──

  @Get('reports')
  @Roles(...GES_ALL_ROLES)
  async findReports(
    @Query('tenantId') tenantId?: string,
    @Query('officeId') officeId?: string,
    @Query('includeChildren') includeChildren?: string,
  ) {
    if (tenantId) return this.gesService.findReportsByTenant(tenantId);
    if (officeId) return this.gesService.findReportsByOffice(officeId, includeChildren === 'true');
    return [];
  }

  @Get('reports/:id')
  @Roles(...GES_ALL_ROLES)
  async findReportById(@Param('id') id: string) {
    return this.gesService.findReportById(id);
  }

  @Post('reports')
  @Roles('system_admin', 'siso', 'ges_auditor', 'emis')
  async createReport(@Body() dto: CreateGesReportDto, @Query('tenantId') tenantId: string) {
    return this.gesService.createReport(dto, tenantId);
  }

  @Post('reports/:id/submit')
  @Roles('system_admin', 'siso', 'ges_auditor', 'emis')
  async submitReport(@Param('id') id: string) {
    return this.gesService.submitReport(id);
  }

  @Put('reports/:id/status')
  @Roles(...GES_DIRECTOR_ROLES)
  async updateReportStatus(
    @Param('id') id: string,
    @Body() dto: UpdateGesReportStatusDto,
    @Query('reviewerId') reviewerId: string,
  ) {
    return this.gesService.updateReportStatus(id, dto, reviewerId);
  }

  // ── School-Office assignment ──

  @Put('assign-school/:tenantId')
  @Roles(...GES_DIRECTOR_ROLES)
  async assignSchoolToOffice(
    @Param('tenantId') tenantId: string,
    @Body() dto: AssignSchoolToOfficeDto,
  ) {
    return this.gesService.assignSchoolToOffice(tenantId, dto.gesOfficeId);
  }

  @Get('schools')
  @Roles(...GES_ALL_ROLES)
  async getSchoolsByOffice(
    @Query('officeId') officeId: string,
    @Query('includeChildren') includeChildren?: string,
  ) {
    return this.gesService.getSchoolsByOffice(officeId, includeChildren === 'true');
  }

  // ── Stats ──

  @Get('my-office/:tenantKey')
  @Roles(...GES_ALL_ROLES)
  async findMyOffice(@Param('tenantKey') tenantKey: string) {
    const office = await this.gesService.findOfficeByTenantKey(tenantKey);
    if (!office) throw new NotFoundException('GES office not found for this tenant');
    return office;
  }

  @Get('stats/:officeId')
  @Roles(...GES_ALL_ROLES)
  async getOfficeStats(
    @Param('officeId') officeId: string,
    @Query('includeChildren') includeChildren?: string,
  ) {
    return this.gesService.getOfficeStats(officeId, includeChildren === 'true');
  }

  // ── EMIS Stats ──

  @Get('emis-stats/:officeId')
  @Roles(...GES_ALL_ROLES)
  async getEmisStats(
    @Param('officeId') officeId: string,
    @Query('includeChildren') includeChildren?: string,
  ) {
    return this.gesService.getEmisStats(officeId, includeChildren === 'true');
  }

  // ── User Management ──

  @Get('users/:tenantId')
  @Roles(...GES_DIRECTOR_ROLES)
  async listGesUsers(@Param('tenantId') tenantId: string) {
    return this.gesService.listGesUsers(tenantId);
  }

  @Post('users')
  @Roles(...GES_DIRECTOR_ROLES)
  async createGesUser(@Body() body: { username: string; password?: string; displayName: string; role: string; tenantId: string }) {
    return this.gesService.createGesUser(body);
  }

  @Post('users/:id/reset-password')
  @Roles(...GES_DIRECTOR_ROLES)
  async resetGesUserPassword(@Param('id') id: string, @Body() body: { newPassword?: string }) {
    return this.gesService.resetGesUserPassword(id, body.newPassword);
  }

  @Delete('users/:id')
  @Roles(...GES_DIRECTOR_ROLES)
  async deleteGesUser(@Param('id') id: string) {
    return this.gesService.deleteGesUser(id);
  }

  // ── Supervisory Report Generation ──

  @Post('reports/supervisory/:tenantId')
  @Roles(...GES_ALL_ROLES)
  async generateSupervisoryReport(
    @Param('tenantId') tenantId: string,
    @Body() body: { gesOfficeId: string; academicYear: string; term: string },
  ) {
    return this.gesService.generateSupervisoryReport(tenantId, body.gesOfficeId, body.academicYear, body.term);
  }

  @Post('reports/batch-supervisory/:officeId')
  @Roles(...GES_DIRECTOR_ROLES)
  async generateBatchSupervisoryReports(
    @Param('officeId') officeId: string,
    @Body() body: { academicYear: string; term: string },
  ) {
    return this.gesService.generateBatchSupervisoryReports(officeId, body.academicYear, body.term);
  }
}
