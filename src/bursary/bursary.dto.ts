import { IsString, IsOptional, IsNumber, IsDateString, MaxLength } from 'class-validator';

export class CreateFeeRecordDto {
  @IsString()
  studentName: string;

  @IsString()
  admNo: string;

  @IsOptional()
  @IsString()
  class?: string;

  @IsString()
  term: string;

  @IsString()
  feeType: string;

  @IsNumber()
  amountDue: number;

  @IsOptional()
  @IsString()
  guardianName?: string;

  @IsOptional()
  @IsString()
  guardianPhone?: string;
}

export class RecordPaymentDto {
  @IsString()
  feeRecordId: string;

  @IsNumber()
  amount: number;

  @IsString()
  method: string;

  @IsString()
  receivedBy: string;

  @IsString()
  term: string;

  @IsOptional()
  @IsString()
  notes?: string;
}
