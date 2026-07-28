import { IsString, IsOptional, IsIn, IsObject, IsBoolean, IsArray, MaxLength, MinLength } from 'class-validator';

const GES_LEVELS = ['national', 'regional', 'district', 'circuit'];

export class CreateGesOfficeDto {
  @IsString()
  @MinLength(3)
  officeKey: string;

  @IsString()
  @MinLength(2)
  name: string;

  @IsString()
  @IsIn(GES_LEVELS)
  level: string;

  @IsOptional()
  @IsString()
  parentId?: string;

  @IsOptional()
  @IsString()
  gesCode?: string;

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
  headName?: string;

  @IsOptional()
  @IsString()
  headTitle?: string;
}

export class UpdateGesOfficeDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  parentId?: string;

  @IsOptional()
  @IsString()
  gesCode?: string;

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
  headName?: string;

  @IsOptional()
  @IsString()
  headTitle?: string;

  @IsOptional()
  @IsBoolean()
  active?: boolean;
}

const REPORT_TYPES = [
  'enrollment', 'staffing', 'infrastructure', 'academic_performance',
  'financial', 'health_safety', 'inspection', 'compliance', 'special_report',
];

export class CreateGesReportDto {
  @IsString()
  reportType: string;

  @IsString()
  @MaxLength(200)
  title: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsString()
  academicYear: string;

  @IsOptional()
  @IsString()
  term?: string;

  @IsOptional()
  @IsObject()
  reportData?: Record<string, any>;

  @IsOptional()
  @IsArray()
  attachments?: string[];

  @IsOptional()
  @IsString()
  gesOfficeId?: string;

  @IsOptional()
  @IsString()
  deadline?: string;
}

export class UpdateGesReportStatusDto {
  @IsString()
  @IsIn(['draft', 'submitted', 'under_review', 'approved', 'rejected', 'overdue'])
  status: string;

  @IsOptional()
  @IsString()
  reviewNotes?: string;
}

export class AssignSchoolToCircuitDto {
  @IsString()
  gesCircuitId: string;
}
