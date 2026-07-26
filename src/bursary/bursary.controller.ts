import { RolesGuard } from '../auth/roles.guard';
import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Request,
} from '@nestjs/common';
import { SkipThrottle } from '@nestjs/throttler';
import { BursaryService } from './bursary.service';
import { CreateFeeRecordDto, RecordPaymentDto } from './bursary.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('bursary')
@UseGuards(JwtAuthGuard, RolesGuard)
@SkipThrottle()
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

  @Get('payroll')
  async getPayroll(@Request() req: any) {
    return this.service.getPayroll(req.user.tenantId);
  }

  @Get('expenditure')
  async getExpenditure(@Request() req: any) {
    return this.service.getExpenditure(req.user.tenantId);
  }

  @Post('expenditure')
  @Roles('headmaster', 'bursary', 'accountant', 'system_admin')
  async createExpenditure(@Body() dto: any, @Request() req: any) {
    return this.service.createExpenditure(dto, req.user.tenantId);
  }

  @Get('budget-items')
  async getBudgetItems(@Request() req: any) {
    return this.service.getBudgetItems(req.user.tenantId);
  }

  @Get('budget-submissions')
  async getBudgetSubmissions(@Request() req: any) {
    return this.service.getBudgetSubmissions(req.user.tenantId);
  }

  @Get('invoices')
  async getInvoices(@Request() req: any) {
    return this.service.getInvoices(req.user.tenantId);
  }

  @Post('receipts')
  @Roles('headmaster', 'bursary', 'accountant', 'system_admin')
  async createReceipt(@Body() dto: any, @Request() req: any) {
    return this.service.createReceipt(dto, req.user.tenantId);
  }

  // Bursar endpoints
  @Get('procurement')
  async getProcurement(@Request() req: any) {
    return this.service.getProcurement(req.user.tenantId);
  }

  @Get('petty-cash')
  async getPettyCash(@Request() req: any) {
    return this.service.getPettyCash(req.user.tenantId);
  }

  @Get('cash-transactions')
  async getCashTransactions(@Request() req: any) {
    return this.service.getCashTransactions(req.user.tenantId);
  }

  @Get('student-accounts')
  async getStudentAccounts(@Request() req: any) {
    return this.service.getStudentAccounts(req.user.tenantId);
  }

  @Get('imprest')
  async getImprest(@Request() req: any) {
    return this.service.getImprest(req.user.tenantId);
  }

  @Get('feeding')
  async getFeeding(@Request() req: any) {
    return this.service.getFeeding(req.user.tenantId);
  }

  @Get('boarding-supplies')
  async getBoardingSupplies(@Request() req: any) {
    return this.service.getBoardingSupplies(req.user.tenantId);
  }

  @Get('returns')
  async getReturns(@Request() req: any) {
    return this.service.getReturns(req.user.tenantId);
  }
}
