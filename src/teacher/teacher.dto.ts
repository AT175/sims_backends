import { IsString, IsOptional, IsNumber, IsBoolean, IsArray, IsDateString } from 'class-validator';

// ── Lesson Plan ──
export class CreateLessonPlanDto {
  @IsString() subject: string;
  @IsString() classForm: string;
  @IsString() date: string;
  @IsString() topic: string;
  @IsOptional() @IsString() objectives?: string;
  @IsOptional() @IsString() teachingMethods?: string;
  @IsOptional() @IsString() resources?: string;
  @IsOptional() @IsString() activities?: string;
  @IsOptional() @IsString() assessment?: string;
  @IsOptional() @IsString() homework?: string;
  @IsOptional() @IsString() fileUrl?: string;
  @IsOptional() @IsString() fileName?: string;
}
export class UpdateLessonPlanDto {
  @IsOptional() @IsString() objectives?: string;
  @IsOptional() @IsString() teachingMethods?: string;
  @IsOptional() @IsString() resources?: string;
  @IsOptional() @IsString() activities?: string;
  @IsOptional() @IsString() assessment?: string;
  @IsOptional() @IsString() homework?: string;
  @IsOptional() @IsString() status?: string;
  @IsOptional() @IsString() reflection?: string;
}

// ── Assignment ──
export class CreateAssignmentDto {
  @IsString() title: string;
  @IsOptional() @IsString() description?: string;
  @IsString() classForm: string;
  @IsString() subject: string;
  @IsString() dueDate: string;
  @IsOptional() @IsString() expiryDate?: string;
  @IsNumber() maxScore: number;
}
export class GradeSubmissionDto {
  @IsString() submissionId: string;
  @IsNumber() score: number;
  @IsOptional() @IsString() feedback?: string;
}
export class BulkGradeDto {
  @IsArray() grades: { submissionId: string; score: number; feedback?: string }[];
}

// ── Gradebook ──
export class CreateGradebookDto {
  @IsString() studentName: string;
  @IsString() admNo: string;
  @IsString() classForm: string;
  @IsString() subject: string;
  @IsString() term: string;
  @IsNumber() classwork: number;
  @IsNumber() classworkMax: number;
  @IsNumber() homework: number;
  @IsNumber() homeworkMax: number;
  @IsNumber() test: number;
  @IsNumber() testMax: number;
  @IsNumber() exam: number;
  @IsNumber() examMax: number;
  @IsNumber() total: number;
  @IsNumber() totalMax: number;
  @IsString() grade: string;
}

// ── Attendance ──
export class CreateAttendanceDto {
  @IsString() studentName: string;
  @IsString() admNo: string;
  @IsString() classForm: string;
  @IsString() subject: string;
  @IsString() date: string;
  @IsString() status: string;
  @IsOptional() @IsString() notes?: string;
}
export class BulkAttendanceDto {
  @IsArray() records: CreateAttendanceDto[];
}

// ── Syllabus ──
export class CreateSyllabusDto {
  @IsString() subject: string;
  @IsString() classForm: string;
  @IsString() topic: string;
  @IsOptional() @IsString() subTopics?: string;
  @IsNumber() week: number;
}
export class UpdateSyllabusDto {
  @IsOptional() @IsString() status?: string;
  @IsOptional() @IsString() dateTaught?: string;
  @IsOptional() @IsString() notes?: string;
}

// ── Material ──
export class CreateMaterialDto {
  @IsString() title: string;
  @IsString() type: string;
  @IsString() classForm: string;
  @IsString() subject: string;
  @IsOptional() @IsString() topic?: string;
  @IsOptional() @IsString() description?: string;
  @IsOptional() @IsString() fileUrl?: string;
}

// ── AV Recording ──
export class CreateAVDto {
  @IsString() title: string;
  @IsString() type: string;
  @IsOptional() @IsString() duration?: string;
  @IsString() classForm: string;
  @IsString() subject: string;
  @IsOptional() @IsString() topic?: string;
  @IsOptional() @IsString() url?: string;
}

// ── Live Session ──
export class CreateLiveSessionDto {
  @IsString() subject: string;
  @IsString() classForm: string;
  @IsString() scheduledTime: string;
  @IsString() topic: string;
}

// ── Announcement ──
export class CreateAnnouncementDto {
  @IsString() title: string;
  @IsOptional() @IsString() body?: string;
  @IsString() classForm: string;
  @IsString() priority: string;
}

// ── Question Bank ──
export class CreateQuestionDto {
  @IsString() subject: string;
  @IsString() topic: string;
  @IsString() type: string;
  @IsString() question: string;
  @IsOptional() @IsArray() options?: string[];
  @IsString() correctAnswer: string;
  @IsNumber() marks: number;
  @IsString() difficulty: string;
  @IsOptional() @IsString() tags?: string;
}

// ── Quiz ──
export class CreateQuizDto {
  @IsString() title: string;
  @IsString() subject: string;
  @IsString() classForm: string;
  @IsArray() questionIds: string[];
  @IsNumber() duration: number;
  @IsString() dueDate: string;
  @IsString() expiryDate: string;
}

// ── Parent Comm ──
export class CreateParentCommDto {
  @IsString() studentName: string;
  @IsOptional() @IsString() admNo?: string;
  @IsString() classForm: string;
  @IsOptional() @IsString() guardianName?: string;
  @IsOptional() @IsString() guardianPhone?: string;
  @IsOptional() @IsString() channel?: string;
  @IsOptional() @IsString() direction?: string;
  @IsOptional() @IsString() subject?: string;
  @IsOptional() @IsString() notes?: string;
  @IsOptional() @IsBoolean() followUpNeeded?: boolean;
  @IsOptional() @IsString() followUpDate?: string;
}

// ── Behavior Note ──
export class CreateBehaviorNoteDto {
  @IsString() studentName: string;
  @IsOptional() @IsString() admNo?: string;
  @IsString() classForm: string;
  @IsString() date: string;
  @IsOptional() @IsString() type?: string;
  @IsOptional() @IsString() severity?: string;
  @IsOptional() @IsString() category?: string;
  @IsOptional() @IsString() description?: string;
  @IsOptional() @IsString() actionTaken?: string;
}

// ── Calendar Event ──
export class CreateCalendarEventDto {
  @IsString() title: string;
  @IsString() date: string;
  @IsOptional() @IsString() time?: string;
  @IsOptional() @IsString() type?: string;
  @IsOptional() @IsString() subject?: string;
  @IsOptional() @IsString() classForm?: string;
  @IsOptional() @IsString() notes?: string;
}

// ── Shared Resource ──
export class CreateSharedResourceDto {
  @IsString() title: string;
  @IsString() subject: string;
  @IsOptional() @IsString() type?: string;
  @IsString() classForm: string;
  @IsOptional() @IsString() description?: string;
  @IsOptional() @IsString() fileUrl?: string;
}

// ── Remedial ──
export class CreateRemedialDto {
  @IsString() studentName: string;
  @IsOptional() @IsString() admNo?: string;
  @IsString() classForm: string;
  @IsString() subject: string;
  @IsString() area: string;
  @IsOptional() @IsString() intervention?: string;
  @IsOptional() @IsString() notes?: string;
}
export class UpdateRemedialDto {
  @IsOptional() @IsString() progress?: string;
  @IsOptional() @IsString() notes?: string;
}

// ── AI Lesson Plan ──
export class AILessonPlanDto {
  @IsString() subject: string;
  @IsString() classForm: string;
  @IsString() topic: string;
  @IsOptional() @IsString() duration?: string;
  @IsOptional() @IsString() objectives?: string;
  @IsOptional() @IsString() teachingStyle?: string;
}
