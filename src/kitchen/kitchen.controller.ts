import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { KitchenService } from './kitchen.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';
import { CreateStockDto, CreateMenuDto } from './kitchen.dto';

@Controller('kitchen')
@UseGuards(JwtAuthGuard)
export class KitchenController {
  constructor(private readonly service: KitchenService) {}

  @Get('stock')
  async getStock(@Request() req: any) { return this.service.getStock(req.user.tenantId); }

  @Post('stock')
  @Roles('headmaster', 'catering', 'system_admin')
  async createStock(@Body() data: CreateStockDto, @Request() req: any) { return this.service.createStock(data, req.user.tenantId); }

  @Get('menus')
  async getMenus(@Request() req: any) { return this.service.getMenus(req.user.tenantId); }

  @Post('menus')
  @Roles('headmaster', 'catering', 'system_admin')
  async createMenu(@Body() data: CreateMenuDto, @Request() req: any) { return this.service.createMenu(data, req.user.tenantId); }
}
