import { Controller, Get, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ExeatService } from './exeat.service';

@Controller('exeats')
@UseGuards(JwtAuthGuard)
@SkipThrottle()
export class ExeatController {
  constructor(private readonly service: ExeatService) {}

  @Get()
  async getRoot(@Request() req: any) {
    return this.service.getRoot(req.user.tenantId);
  }
}
