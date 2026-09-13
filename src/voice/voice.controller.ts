import { Controller, Get, Param, Query, UseGuards, Request } from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { VoiceService } from './voice.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';

@Controller('voice')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
export class VoiceController {
  constructor(private readonly svc: VoiceService) {}

  @Get('languages')
  async getLanguages() {
    return { languages: this.svc.getLanguages() };
  }

  @Get('templates')
  async getTemplates() {
    return { templates: this.svc.getTemplates() };
  }

  @Get('message/:template/:language/:studentId')
  async getMessage(
    @Param('template') template: string,
    @Param('language') language: string,
    @Param('studentId') studentId: string,
    @Request() r: any,
  ) {
    return this.svc.getLocalizedMessage(template, language, studentId, r.user.tenantId);
  }
}
