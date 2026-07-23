import { IsString, IsOptional } from 'class-validator';

export class CreateIncidentDto {
  @IsString() date: string;
  @IsString() time: string;
  @IsString() type: string;
  @IsOptional() @IsString() location?: string;
  @IsString() description: string;
  @IsOptional() @IsString() severity?: string;
  @IsString() reportedBy: string;
}

export class CreateGateLogDto {
  @IsString() date: string;
  @IsString() time: string;
  @IsString() visitorName: string;
  @IsOptional() @IsString() vehiclePlate?: string;
  @IsOptional() @IsString() purpose?: string;
  @IsOptional() @IsString() host?: string;
}
