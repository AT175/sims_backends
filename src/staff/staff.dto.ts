import { IsString, IsOptional, IsIn, IsDateString } from 'class-validator';

export class CreateStaffDto {
  @IsString()
  name: string;

  @IsString()
  role: string;

  @IsString()
  position: string;

  @IsString()
  department: string;

  @IsOptional()
  @IsString()
  phone?: string;

  @IsOptional()
  @IsString()
  email?: string;
}

export class CreateLeaveRequestDto {
  @IsString()
  staffName: string;

  @IsString()
  staffRole: string;

  @IsDateString()
  startDate: string;

  @IsDateString()
  endDate: string;

  @IsString()
  type: string;

  @IsOptional()
  @IsString()
  reason?: string;
}

export class ReviewLeaveDto {
  @IsIn(['Approved', 'Rejected'])
  status: string;

  @IsOptional()
  @IsString()
  reviewNotes?: string;
}
