import { IsString, IsOptional, IsEmail, IsIn, MaxLength, Matches, IsBoolean } from 'class-validator';

export class SubmitAdmissionDto {
  @IsString()
  @MaxLength(100)
  applicantName: string;

  @IsString()
  @MaxLength(100)
  parentName: string;

  @IsString()
  @Matches(/^\+?[0-9\s\-()]{7,20}$/)
  parentPhone: string;

  @IsOptional()
  @IsEmail()
  parentEmail?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  csspsPlacementRef?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  programme?: string;

  @IsOptional()
  @IsString()
  appliedClassLevel?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  previousSchool?: string;

  @IsOptional()
  @IsString()
  @MaxLength(50)
  previousClass?: string;

  @IsOptional()
  @IsString()
  dateOfBirth?: string;

  @IsOptional()
  @IsString()
  gender?: string;

  @IsOptional()
  @IsBoolean()
  isDirectApplication?: boolean;
}

export class CheckStatusDto {
  @IsString()
  applicantName: string;

  @IsString()
  csspsPlacementRef: string;
}

export class CheckStatusByPhoneDto {
  @IsString()
  applicantName: string;

  @IsString()
  parentPhone: string;
}

export class UpdateAdmissionStatusDto {
  @IsString()
  @IsIn(['received', 'under_review', 'approved', 'rejected', 'waitlisted'])
  status: string;

  @IsOptional()
  @IsString()
  @IsIn(['true', 'false'])
  documentsVerified?: string;
}
