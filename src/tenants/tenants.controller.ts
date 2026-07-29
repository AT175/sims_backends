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
import { SkipThrottle } from '@nestjs/throttler';
import { IsString, MinLength, IsOptional, IsInt, IsArray, IsBoolean, IsObject } from 'class-validator';
import { TenantsService } from './tenants.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';
import { SCHOOL_LEVEL_CONFIGS, GRADING_SCHEMES } from './school-level.config';

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
  schoolLevel?: string;

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
  schoolLevel?: string;

  @IsOptional()
  @IsString()
  gradingScheme?: string;

  @IsOptional()
  @IsObject()
  classLevelNames?: Record<string, string>;

  @IsOptional()
  @IsArray()
  offeredLevels?: string[];

  @IsOptional()
  @IsInt()
  termsPerYear?: number;

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
  @IsArray()
  disabledRoles?: string[];

  @IsOptional()
  @IsBoolean()
  active?: boolean;

  @IsOptional()
  @IsString()
  motto?: string;

  @IsOptional()
  @IsString()
  primaryColor?: string;

  @IsOptional()
  @IsString()
  secondaryColor?: string;

  @IsOptional()
  @IsString()
  bannerImage?: string;

  @IsOptional()
  @IsString()
  aboutText?: string;

  @IsOptional()
  @IsString()
  mission?: string;

  @IsOptional()
  @IsString()
  vision?: string;

  @IsOptional()
  @IsString()
  principalsMessage?: string;

  @IsOptional()
  @IsString()
  admissionsInfo?: string;

  @IsOptional()
  @IsString()
  facebookUrl?: string;

  @IsOptional()
  @IsString()
  instagramUrl?: string;

  @IsOptional()
  @IsString()
  twitterUrl?: string;

  @IsOptional()
  @IsArray()
  newsItems?: { title: string; body: string; date: string }[];

  @IsOptional()
  @IsArray()
  galleryImages?: string[];

  @IsOptional()
  @IsString()
  customDomain?: string;

  @IsOptional()
  @IsArray()
  programmes?: { name: string; description: string; icon: string }[];

  @IsOptional()
  @IsArray()
  staffProfiles?: { name: string; title: string; photoUrl: string | null; bio: string | null }[];

  @IsOptional()
  @IsArray()
  upcomingEvents?: { title: string; date: string; description: string; type: string }[];

  @IsOptional()
  @IsArray()
  testimonials?: { author: string; role: string; content: string; rating: number }[];
}

@Controller('tenants')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class TenantsController {
  constructor(private readonly tenantsService: TenantsService) {}

  @Get('school-level-configs')
  async getSchoolLevelConfigs() {
    return {
      levels: Object.entries(SCHOOL_LEVEL_CONFIGS).map(([key, config]) => ({
        key,
        label: config.label,
        shortLabel: config.shortLabel,
        defaultGradingScheme: config.defaultGradingScheme,
        defaultClassLevels: config.defaultClassLevels,
        defaultClassLevelNames: config.defaultClassLevelNames,
        usesCssps: config.usesCssps,
        typicallyBoarding: config.typicallyBoarding,
        excludedRoles: config.excludedRoles,
        defaultModules: config.defaultModules,
      })),
      gradingSchemes: Object.entries(GRADING_SCHEMES).map(([key, scheme]) => ({
        key,
        label: scheme.label,
        bands: scheme.bands,
      })),
    };
  }

  @Get()
  @Roles('system_admin', 'headmaster')
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
  @Roles('system_admin', 'headmaster')
  async update(@Param('id') id: string, @Body() dto: UpdateTenantDto) {
    return this.tenantsService.update(id, dto);
  }

  @Delete(':id')
  @Roles('system_admin')
  async remove(@Param('id') id: string) {
    return this.tenantsService.remove(id);
  }
}
