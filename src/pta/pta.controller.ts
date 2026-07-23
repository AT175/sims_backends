import { Controller, Get, Post, Put, Body, Param, UseGuards, Request, ParseUUIDPipe } from '@nestjs/common';
import { PTAService } from './pta.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('pta')
@UseGuards(JwtAuthGuard)
export class PTAController {
  constructor(private readonly service: PTAService) {}

  @Get('announcements')
  async getAnnouncements(@Request() req: any) { return this.service.getAnnouncements(req.user.tenantId); }

  @Post('announcements')
  async createAnnouncement(@Body() data: any, @Request() req: any) { return this.service.createAnnouncement(data, req.user.tenantId); }

  @Get('meetings')
  async getMeetings(@Request() req: any) { return this.service.getMeetings(req.user.tenantId); }

  @Post('meetings')
  async createMeeting(@Body() data: any, @Request() req: any) { return this.service.createMeeting(data, req.user.tenantId); }

  @Put('meetings/:id/rsvp')
  async updateRSVP(@Param('id', ParseUUIDPipe) id: string, @Body() body: { rsvp: string }, @Request() req: any) {
    return this.service.updateRSVP(id, body.rsvp, req.user.tenantId);
  }
}
