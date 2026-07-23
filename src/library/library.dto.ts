import { IsString, IsOptional, IsNumber, IsInt } from 'class-validator';

export class CreateBookDto {
  @IsString() title: string;
  @IsString() author: string;
  @IsOptional() @IsString() category?: string;
  @IsOptional() @IsString() isbn?: string;
  @IsInt() totalCopies: number;
  @IsInt() availableCopies: number;
}

export class CreateCirculationDto {
  @IsString() date: string;
  @IsString() bookId: string;
  @IsString() bookTitle: string;
  @IsString() borrowerName: string;
  @IsOptional() @IsString() borrowerClass?: string;
  @IsString() dueDate: string;
}
