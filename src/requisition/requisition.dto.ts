import { IsString, IsOptional, IsNumber } from 'class-validator';

export class CreateRequisitionDto {
  @IsString() date: string;
  @IsString() itemName: string;
  @IsNumber() quantity: number;
  @IsOptional() @IsString() unit?: string;
  @IsString() department: string;
  @IsString() requestedBy: string;
  @IsOptional() @IsString() priority?: string;
  @IsOptional() @IsString() notes?: string;
  @IsOptional() @IsString() house?: string;
}

export class UpdateRequisitionStatusDto {
  @IsString() status: string;
}
