import { Controller, Get, Post, Put, Body, Param, UseGuards, Request, ParseUUIDPipe } from '@nestjs/common';
import { LibraryService } from './library.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('library')
@UseGuards(JwtAuthGuard)
export class LibraryController {
  constructor(private readonly service: LibraryService) {}

  @Get('books')
  async getBooks(@Request() req: any) { return this.service.getBooks(req.user.tenantId); }

  @Post('books')
  @Roles('headmaster', 'library_ict', 'system_admin')
  async createBook(@Body() data: any, @Request() req: any) { return this.service.createBook(data, req.user.tenantId); }

  @Get('circulation')
  async getCirculation(@Request() req: any) { return this.service.getCirculation(req.user.tenantId); }

  @Post('circulation')
  @Roles('headmaster', 'library_ict', 'system_admin', 'teacher')
  async createCirculation(@Body() data: any, @Request() req: any) { return this.service.createCirculation(data, req.user.tenantId); }

  @Put('circulation/:id/return')
  async returnBook(@Param('id', ParseUUIDPipe) id: string, @Request() req: any) { return this.service.returnBook(id, req.user.tenantId); }
}
