import {
  Controller,
  Get,
  Post,
  Put,
  Body,
  Param,
  UseGuards,
  Request,
  ParseUUIDPipe,
  BadRequestException,
} from '@nestjs/common';
import { Throttle, SkipThrottle } from '@nestjs/throttler';
import { AdmissionsService } from './admissions.service';
import { SubmitAdmissionDto, UpdateAdmissionStatusDto } from './admission.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('admissions')
@SkipThrottle({ default: false })
export class AdmissionsController {
  constructor(private readonly service: AdmissionsService) {}

  @Post('apply')
  @Throttle({ auth: { ttl: 60000, limit: 3 } })
  async submit(@Body() dto: SubmitAdmissionDto, @Request() req: any) {
    const tenantId = req.headers['x-tenant-id'];
    if (!tenantId) {
      throw new BadRequestException('Tenant ID header is required');
    }
    return this.service.submit(dto, tenantId);
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  @Roles('headmaster', 'asst_headmaster_admin', 'registry', 'system_admin')
  async findAll(@Request() req: any) {
    return this.service.findAll(req.user.tenantId);
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  @Roles('headmaster', 'asst_headmaster_admin', 'registry', 'system_admin')
  async findOne(@Param('id', ParseUUIDPipe) id: string, @Request() req: any) {
    return this.service.findOne(id, req.user.tenantId);
  }

  @Put(':id/status')
  @UseGuards(JwtAuthGuard)
  @Roles('headmaster', 'asst_headmaster_admin', 'registry', 'system_admin')
  async updateStatus(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateAdmissionStatusDto,
    @Request() req: any,
  ) {
    return this.service.updateStatus(id, dto, req.user.tenantId);
  }
}
