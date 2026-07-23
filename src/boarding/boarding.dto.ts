import { IsString, IsOptional, IsBoolean, IsNumber, IsDateString, IsIn } from 'class-validator';

const SEVERITY_LEVELS = ['Minor', 'Moderate', 'Serious', 'Critical'];
const ROLL_CALL_STATUSES = ['Present', 'Absent', 'Excused', 'Late'];

export class CreateExeatDto {
  @IsString() date: string;
  @IsString() studentName: string;
  @IsString() admissionNo: string;
  @IsOptional() @IsString() house?: string;
  @IsOptional() @IsString() class?: string;
  @IsString() reason: string;
  @IsOptional() @IsString() reasonDetail?: string;
  @IsOptional() @IsString() destination?: string;
  @IsString() departureDate: string;
  @IsString() returnDate: string;
  @IsOptional() @IsString() guardianName?: string;
  @IsOptional() @IsString() guardianPhone?: string;
  @IsOptional() @IsString() transportMode?: string;
}

export class UpdateExeatStatusDto {
  @IsString() status: string;
}

export class CreateRollCallDto {
  @IsString() date: string;
  @IsString() house: string;
  @IsString() studentName: string;
  @IsOptional() @IsString() room?: string;
  @IsOptional() @IsIn(ROLL_CALL_STATUSES) status?: string;
  @IsOptional() @IsString() notes?: string;
  @IsString() recordedBy: string;
}

export class CreateDisciplineLogDto {
  @IsString() date: string;
  @IsString() house: string;
  @IsString() studentName: string;
  @IsString() incident: string;
  @IsOptional() @IsIn(SEVERITY_LEVELS) severity?: string;
  @IsOptional() @IsString() actionTaken?: string;
  @IsString() recordedBy: string;
}
