import { IsString, IsOptional } from 'class-validator';

export class CreateCleaningTaskDto {
  @IsString() task: string;
  @IsOptional() @IsString() area?: string;
  @IsOptional() @IsString() frequency?: string;
  @IsOptional() @IsString() assignedTo?: string;
  @IsOptional() @IsString() date?: string;
  @IsOptional() @IsString() priority?: string;
}

export class CreateMaintenanceIssueDto {
  @IsString() date: string;
  @IsOptional() @IsString() location?: string;
  @IsString() issue: string;
  @IsOptional() @IsString() priority?: string;
  @IsString() reportedBy: string;
  @IsOptional() @IsString() notes?: string;
}
