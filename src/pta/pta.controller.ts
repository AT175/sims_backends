import { RolesGuard } from '../auth/roles.guard';
import { Controller, Get, Post, Put, Body, Param, UseGuards, Request, ParseUUIDPipe } from '@nestjs/common';
import { PTAService } from './pta.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CreateAnnouncementDto, CreateMeetingDto, UpdateRSVPDto } from './pta.dto';

@Controller('pta')
@UseGuards(JwtAuthGuard, RolesGuard)
export class PTAController {
  constructor(private readonly service: PTAService) {}

  @Get('announcements')
  async getAnnouncements(@Request() req: any) { return this.service.getAnnouncements(req.user.tenantId); }

  @Post('announcements')
  async createAnnouncement(@Body() data: CreateAnnouncementDto, @Request() req: any) { return this.service.createAnnouncement(data, req.user.tenantId); }

  @Get('meetings')
  async getMeetings(@Request() req: any) { return this.service.getMeetings(req.user.tenantId); }

  @Post('meetings')
  async createMeeting(@Body() data: CreateMeetingDto, @Request() req: any) { return this.service.createMeeting(data, req.user.tenantId); }

  @Put('meetings/:id/rsvp')
  async updateRSVP(@Param('id', ParseUUIDPipe) id: string, @Body() body: UpdateRSVPDto, @Request() req: any) {
    return this.service.updateRSVP(id, body.rsvp, req.user.tenantId);
  }
}
