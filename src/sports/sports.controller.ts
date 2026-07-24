import { RolesGuard } from '../auth/roles.guard';
import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { SportsService } from './sports.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CreateFixtureDto, CreateClubDto } from './sports.dto';

@Controller('sports')
@UseGuards(JwtAuthGuard, RolesGuard)
export class SportsController {
  constructor(private readonly service: SportsService) {}

  @Get('fixtures')
  async getFixtures(@Request() req: any) { return this.service.getFixtures(req.user.tenantId); }

  @Post('fixtures')
  @Roles('headmaster', 'sports_clubs', 'system_admin')
  async createFixture(@Body() data: CreateFixtureDto, @Request() req: any) { return this.service.createFixture(data, req.user.tenantId); }

  @Get('clubs')
  async getClubs(@Request() req: any) { return this.service.getClubs(req.user.tenantId); }

  @Post('clubs')
  @Roles('headmaster', 'sports_clubs', 'system_admin')
  async createClub(@Body() data: CreateClubDto, @Request() req: any) { return this.service.createClub(data, req.user.tenantId); }
}
