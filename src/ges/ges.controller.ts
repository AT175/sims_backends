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
  AssignSchoolToCircuitDto,
} from './ges.dto';

@Controller('ges')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class GesController {
  constructor(private readonly gesService: GesService) {}

  // ── Office endpoints ──

  @Get('offices')
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
  async findAllOffices(
    @Query('level') level?: string,
    @Query('parentId') parentId?: string,
  ) {
    return this.gesService.findAllOffices(level, parentId);
  }

  @Get('offices/tree')
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
  async getOfficeTree() {
    return this.gesService.getOfficeTree();
  }

  @Get('offices/:id')
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
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
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
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
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
  async findReportById(@Param('id') id: string) {
    return this.gesService.findReportById(id);
  }

  @Post('reports')
  @Roles('system_admin', 'ges_circuit')
  async createReport(@Body() dto: CreateGesReportDto, @Query('tenantId') tenantId: string) {
    return this.gesService.createReport(dto, tenantId);
  }

  @Post('reports/:id/submit')
  @Roles('system_admin', 'ges_circuit')
  async submitReport(@Param('id') id: string) {
    return this.gesService.submitReport(id);
  }

  @Put('reports/:id/status')
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
  async updateReportStatus(
    @Param('id') id: string,
    @Body() dto: UpdateGesReportStatusDto,
    @Query('reviewerId') reviewerId: string,
  ) {
    return this.gesService.updateReportStatus(id, dto, reviewerId);
  }

  // ── School-Office assignment ──

  @Put('assign-school/:tenantId')
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district')
  async assignSchoolToCircuit(
    @Param('tenantId') tenantId: string,
    @Body() dto: AssignSchoolToCircuitDto,
  ) {
    return this.gesService.assignSchoolToCircuit(tenantId, dto.gesCircuitId);
  }

  @Get('schools')
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
  async getSchoolsByOffice(
    @Query('officeId') officeId: string,
    @Query('includeChildren') includeChildren?: string,
  ) {
    return this.gesService.getSchoolsByOffice(officeId, includeChildren === 'true');
  }

  // ── Stats ──

  @Get('my-office/:tenantKey')
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
  async findMyOffice(@Param('tenantKey') tenantKey: string) {
    const office = await this.gesService.findOfficeByTenantKey(tenantKey);
    if (!office) throw new NotFoundException('GES office not found for this tenant');
    return office;
  }

  @Get('stats/:officeId')
  @Roles('system_admin', 'ges_national', 'ges_regional', 'ges_district', 'ges_circuit')
  async getOfficeStats(
    @Param('officeId') officeId: string,
    @Query('includeChildren') includeChildren?: string,
  ) {
    return this.gesService.getOfficeStats(officeId, includeChildren === 'true');
  }
}
