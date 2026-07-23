import { IsString, IsOptional, IsNumber } from 'class-validator';

export class CreateVehicleDto {
  @IsString() plate: string;
  @IsString() type: string;
  @IsOptional() @IsString() insuranceExpiry?: string;
  @IsOptional() @IsString() roadworthinessExpiry?: string;
  @IsOptional() @IsString() status?: string;
  @IsOptional() @IsString() assignedDriver?: string;
  @IsOptional() @IsString() notes?: string;
}

export class CreateTripDto {
  @IsString() date: string;
  @IsString() vehiclePlate: string;
  @IsString() driverName: string;
  @IsString() route: string;
  @IsNumber() mileage: number;
  @IsOptional() @IsString() purpose?: string;
  @IsOptional() @IsString() departureTime?: string;
  @IsOptional() @IsString() returnTime?: string;
}
