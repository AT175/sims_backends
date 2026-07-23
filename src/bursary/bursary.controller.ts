import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Request,
} from '@nestjs/common';
import { BursaryService } from './bursary.service';
import { CreateFeeRecordDto, RecordPaymentDto } from './bursary.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('bursary')
@UseGuards(JwtAuthGuard)
export class BursaryController {
  constructor(private readonly service: BursaryService) {}

  @Get('fees')
  @Roles('headmaster', 'bursary', 'accountant', 'system_admin', 'asst_headmaster_admin')
  async getFeeRecords(@Request() req: any) {
    return this.service.getFeeRecords(req.user.tenantId);
  }

  @Post('fees')
  @Roles('headmaster', 'bursary', 'accountant', 'system_admin')
  async createFeeRecord(@Body() dto: CreateFeeRecordDto, @Request() req: any) {
    return this.service.createFeeRecord(dto, req.user.tenantId);
  }

  @Post('payments')
  @Roles('headmaster', 'bursary', 'accountant', 'system_admin')
  async recordPayment(@Body() dto: RecordPaymentDto, @Request() req: any) {
    return this.service.recordPayment(dto, req.user.tenantId);
  }

  @Get('receipts')
  @Roles('headmaster', 'bursary', 'accountant', 'system_admin', 'asst_headmaster_admin')
  async getReceipts(@Request() req: any) {
    return this.service.getReceipts(req.user.tenantId);
  }

  @Get('summary')
  @Roles('headmaster', 'bursary', 'accountant', 'system_admin', 'asst_headmaster_admin')
  async getSummary(@Request() req: any) {
    return this.service.getFeeSummary(req.user.tenantId);
  }
}
