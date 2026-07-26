import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { DiningHallService } from './dining-hall.service';

@Controller('dining-hall')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class DiningHallController {
  constructor(private readonly service: DiningHallService) {}

  @Get('menu-items')
  async getMenuitems(@Request() req: any) {
    return this.service.getMenuitems(req.user.tenantId);
  }

  @Get('meal-attendance')
  async getMealattendance(@Request() req: any) {
    return this.service.getMealattendance(req.user.tenantId);
  }

  @Get('supplies')
  async getSupplies(@Request() req: any) {
    return this.service.getSupplies(req.user.tenantId);
  }
}
