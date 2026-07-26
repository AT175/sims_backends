import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { GoverningBoardService } from './governing-board.service';

@Controller('governing-board')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class GoverningBoardController {
  constructor(private readonly service: GoverningBoardService) {}

  @Get('policies')
  async getPolicies(@Request() req: any) {
    return this.service.getPolicies(req.user.tenantId);
  }

  @Get('budgets')
  async getBudgets(@Request() req: any) {
    return this.service.getBudgets(req.user.tenantId);
  }

  @Get('minutes')
  async getMinutes(@Request() req: any) {
    return this.service.getMinutes(req.user.tenantId);
  }
}
