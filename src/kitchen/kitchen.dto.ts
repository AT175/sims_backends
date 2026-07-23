import { IsString, IsOptional, IsNumber } from 'class-validator';

export class CreateStockDto {
  @IsString() name: string;
  @IsNumber() quantity: number;
  @IsOptional() @IsString() unit?: string;
  @IsNumber() reorderLevel: number;
  @IsOptional() @IsString() category?: string;
}

export class CreateMenuDto {
  @IsString() day: string;
  @IsString() breakfast: string;
  @IsString() lunch: string;
  @IsString() dinner: string;
}
