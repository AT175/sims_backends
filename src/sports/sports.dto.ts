import { IsString, IsOptional, IsInt } from 'class-validator';

export class CreateFixtureDto {
  @IsString() date: string;
  @IsString() sport: string;
  @IsString() match: string;
  @IsOptional() @IsString() venue?: string;
  @IsOptional() @IsString() status?: string;
}

export class CreateClubDto {
  @IsString() name: string;
  @IsOptional() @IsString() category?: string;
  @IsOptional() @IsString() patron?: string;
  @IsOptional() @IsInt() memberCount?: number;
  @IsOptional() @IsString() meetingDay?: string;
  @IsOptional() @IsString() description?: string;
}
