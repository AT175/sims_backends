import { IsString, IsOptional, IsNumber, IsDateString } from 'class-validator';

export class CreateTimetableEntryDto {
  @IsString()
  day: string;

  @IsString()
  startTime: string;

  @IsString()
  endTime: string;

  @IsString()
  subject: string;

  @IsOptional()
  @IsString()
  teacher?: string;

  @IsOptional()
  @IsString()
  room?: string;

  @IsString()
  classSection: string;
}

export class CreateExamResultDto {
  @IsString()
  studentName: string;

  @IsString()
  admNo: string;

  @IsString()
  subject: string;

  @IsString()
  term: string;

  @IsOptional()
  @IsString()
  examType?: string;

  @IsNumber()
  marks: number;

  @IsOptional()
  @IsString()
  grade?: string;

  @IsOptional()
  @IsString()
  remarks?: string;
}

export class CreateAttendanceDto {
  @IsString()
  studentName: string;

  @IsString()
  admNo: string;

  @IsDateString()
  date: string;

  @IsString()
  status: string;

  @IsOptional()
  @IsString()
  classSection?: string;

  @IsOptional()
  @IsString()
  remarks?: string;
}
