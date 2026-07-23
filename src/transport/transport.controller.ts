import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { TransportService } from './transport.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('transport')
@UseGuards(JwtAuthGuard)
export class TransportController {
  constructor(private readonly service: TransportService) {}

  @Get('vehicles')
  async getVehicles(@Request() req: any) { return this.service.getVehicles(req.user.tenantId); }

  @Post('vehicles')
  @Roles('headmaster', 'transport', 'system_admin')
  async createVehicle(@Body() data: any, @Request() req: any) { return this.service.createVehicle(data, req.user.tenantId); }

  @Get('trips')
  async getTrips(@Request() req: any) { return this.service.getTrips(req.user.tenantId); }

  @Post('trips')
  @Roles('headmaster', 'transport', 'system_admin')
  async createTrip(@Body() data: any, @Request() req: any) { return this.service.createTrip(data, req.user.tenantId); }
}
