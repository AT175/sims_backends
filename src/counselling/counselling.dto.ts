import { IsString, IsOptional, IsBoolean } from 'class-validator';

export class CreateCounsellingCaseDto {
  @IsString() studentName: string;
  @IsOptional() @IsString() studentClass?: string;
  @IsOptional() @IsString() category?: string;
  @IsString() type: string;
  @IsString() description: string;
  @IsString() openedDate: string;
  @IsOptional() @IsString() priority?: string;
  @IsOptional() @IsString() assignedCounsellor?: string;
  @IsOptional() @IsBoolean() confidential?: boolean;
}

export class UpdateCaseStatusDto {
  @IsString() status: string;
}
