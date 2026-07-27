import { IsString, IsOptional, IsBoolean, IsInt, IsNumber } from 'class-validator';

export class CreateFeedbackDto {
  @IsString() subject: string;
  @IsString() body: string;
  @IsString() routedTo: string;
}

export class CreateHealthRecordDto {
  @IsString() date: string;
  @IsString() reason: string;
  @IsString() treatment: string;
  @IsOptional() @IsString() notes?: string;
  @IsOptional() @IsString() conditions?: string;
  @IsOptional() @IsString() allergies?: string;
}

export class SubmitAssignmentDto {
  @IsString() assignmentId: string;
  @IsOptional() @IsString() content?: string;
  @IsOptional() @IsString() fileUrl?: string;
}

export class CreateStudentMaterialDto {
  @IsString() title: string;
  @IsString() subject: string;
  @IsOptional() @IsString() type?: string;
  @IsOptional() @IsString() fileUrl?: string;
}

export class CreateStudentClassDto {
  @IsString() subject: string;
  @IsString() teacher: string;
  @IsOptional() @IsString() nextSession?: string;
  @IsOptional() @IsString() classForm?: string;
}

export class CreateStudentResultDto {
  @IsString() subject: string;
  @IsString() term: string;
  @IsInt() score: number;
  @IsInt() maxScore: number;
  @IsString() grade: string;
  @IsOptional() @IsInt() classPosition?: number;
  @IsOptional() @IsInt() classSize?: number;
  @IsOptional() @IsNumber() termAverage?: number;
}

export class CreateStudentAttendanceDto {
  @IsString() date: string;
  @IsString() type: string;
  @IsString() subject: string;
  @IsString() status: string;
}

export class RequestExeatDto {
  @IsString() reason: string;
  @IsOptional() @IsString() reasonDetail?: string;
  @IsOptional() @IsString() destination?: string;
  @IsString() departureDate: string;
  @IsString() returnDate: string;
  @IsOptional() @IsString() transportMode?: string;
}

export class CreateStudentMessageDto {
  @IsString() recipientType: string;
  @IsOptional() @IsString() recipientName?: string;
  @IsString() subject: string;
  @IsString() body: string;
}
