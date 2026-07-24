import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
  Query,
} from '@nestjs/common';
import { IsString, MinLength, IsOptional, IsInt, IsArray, IsBoolean } from 'class-validator';
import { TenantsService } from './tenants.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

class CreateTenantDto {
  @IsString()
  @MinLength(3)
  tenantKey: string;

  @IsString()
  @MinLength(2)
  schoolName: string;

  @IsOptional()
  @IsString()
  schoolCode?: string;

  @IsOptional()
  @IsString()
  region?: string;

  @IsOptional()
  @IsString()
  district?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  email?: string;

  @IsOptional()
  @IsInt()
  maxStudents?: number;

  @IsOptional()
  @IsInt()
  maxStaff?: number;

  @IsOptional()
  @IsString()
  subscriptionPlan?: string;

  @IsOptional()
  @IsString()
  subscriptionExpiry?: string;

  @IsOptional()
  @IsArray()
  enabledModules?: string[];
}

class UpdateTenantDto {
  @IsOptional()
  @IsString()
  schoolName?: string;

  @IsOptional()
  @IsString()
  schoolCode?: string;

  @IsOptional()
  @IsString()
  region?: string;

  @IsOptional()
  @IsString()
  district?: string;

  @IsOptional()
  @IsString()
  address?: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  email?: string;

  @IsOptional()
  @IsString()
  logoUrl?: string;

  @IsOptional()
  @IsString()
  academicYear?: string;

  @IsOptional()
  @IsString()
  term?: string;

  @IsOptional()
  @IsInt()
  maxStudents?: number;

  @IsOptional()
  @IsInt()
  maxStaff?: number;

  @IsOptional()
  @IsString()
  subscriptionPlan?: string;

  @IsOptional()
  @IsString()
  subscriptionExpiry?: string;

  @IsOptional()
  @IsArray()
  enabledModules?: string[];

  @IsOptional()
  @IsBoolean()
  active?: boolean;
}

@Controller('tenants')
@UseGuards(JwtAuthGuard, RolesGuard)
export class TenantsController {
  constructor(private readonly tenantsService: TenantsService) {}

  @Get()
  @Roles('system_admin')
  async findAll() {
    return this.tenantsService.findAll();
  }

  @Get(':id')
  @Roles('system_admin', 'headmaster')
  async findOne(@Param('id') id: string) {
    return this.tenantsService.findOne(id);
  }

  @Post()
  @Roles('system_admin')
  async create(@Body() dto: CreateTenantDto) {
    return this.tenantsService.create(dto);
  }

  @Put(':id')
  @Roles('system_admin')
  async update(@Param('id') id: string, @Body() dto: UpdateTenantDto) {
    return this.tenantsService.update(id, dto);
  }

  @Delete(':id')
  @Roles('system_admin')
  async remove(@Param('id') id: string) {
    return this.tenantsService.remove(id);
  }
}
