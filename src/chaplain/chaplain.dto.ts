import { IsString, IsOptional } from 'class-validator';

export class CreatePrayerRequestDto {
  @IsString() studentName: string;
  @IsOptional() @IsString() studentClass?: string;
  @IsString() request: string;
  @IsOptional() @IsString() visibility?: string;
  @IsString() dateSubmitted: string;
}

export class CreateSpiritualCounsellingDto {
  @IsString() studentName: string;
  @IsOptional() @IsString() studentClass?: string;
  @IsString() type: string;
  @IsString() date: string;
  @IsString() summary: string;
}
