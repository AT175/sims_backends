import { IsString, IsOptional, IsDateString, IsIn, MaxLength, Matches } from 'class-validator';

export class CreateStudentDto {
  @IsString()
  @MaxLength(20)
  admissionNumber: string;

  @IsString()
  @MaxLength(50)
  firstName: string;

  @IsString()
  @MaxLength(50)
  lastName: string;

  @IsDateString()
  dateOfBirth: string;

  @IsIn(['male', 'female'])
  gender: string;

  @IsString()
  @MaxLength(50)
  classSectionId: string;

  @IsOptional()
  @IsString()
  houseId?: string | null;

  @IsString()
  @MaxLength(100)
  guardianName: string;

  @IsString()
  @Matches(/^\+?[0-9\s\-()]{7,20}$/)
  guardianPhone: string;

  @IsString()
  @MaxLength(200)
  guardianAddress: string;

  @IsDateString()
  admissionDate: string;

  @IsOptional()
  @IsIn(['active', 'graduated', 'withdrawn', 'transferred'])
  status?: string;
}

export class UpdateStudentDto extends CreateStudentDto {
  @IsOptional()
  @IsString()
  id?: string;
}
