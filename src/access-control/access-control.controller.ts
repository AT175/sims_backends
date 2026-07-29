import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { IsString, IsArray, IsOptional } from 'class-validator';
import { AccessControlService } from './access-control.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { Roles } from '../auth/roles.decorator';

class CreateGrantDto {
  @IsString()
  userId: string;

  @IsString()
  username: string;

  @IsString()
  displayName: string;

  @IsString()
  dashboardKey: string;

  @IsString()
  dashboardLabel: string;

  allowedPages: string[] | 'all';

  @IsString()
  grantedBy: string;
}

@Controller('access-control')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AccessControlController {
  constructor(private readonly accessControlService: AccessControlService) {}

  @Post('grants')
  @Roles('headmaster', 'system_admin')
  async createGrant(@Body() dto: CreateGrantDto, @Request() req: any) {
    return this.accessControlService.createGrant({
      ...dto,
      tenantId: req.user.tenantId,
    });
  }

  @Get('grants')
  @Roles('headmaster', 'system_admin')
  async getGrants(@Request() req: any) {
    return this.accessControlService.getAllGrants(req.user.tenantId);
  }

  @Delete('grants/:id')
  @Roles('headmaster', 'system_admin')
  async deleteGrant(@Param('id') id: string, @Request() req: any) {
    return this.accessControlService.deleteGrant(id, req.user.tenantId);
  }
}
