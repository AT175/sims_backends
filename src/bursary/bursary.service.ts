import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { FeeRecord } from './fee-record.entity';
import { PaymentReceipt } from './payment-receipt.entity';
import { CreateFeeRecordDto, RecordPaymentDto } from './bursary.dto';

@Injectable()
export class BursaryService {
  constructor(
    @InjectRepository(FeeRecord)
    private readonly feeRepo: Repository<FeeRecord>,
    @InjectRepository(PaymentReceipt)
    private readonly receiptRepo: Repository<PaymentReceipt>,
    private readonly dataSource: DataSource,
  ) {}

  async getFeeRecords(tenantId: string): Promise<FeeRecord[]> {
    return this.feeRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } });
  }

  async createFeeRecord(dto: CreateFeeRecordDto, tenantId: string): Promise<FeeRecord> {
    const record = this.feeRepo.create({
      ...dto,
      balance: dto.amountDue,
      status: 'Owing',
      tenantId,
    });
    return this.feeRepo.save(record);
  }

  async recordPayment(dto: RecordPaymentDto, tenantId: string): Promise<PaymentReceipt> {
    const fee = await this.feeRepo.findOne({ where: { id: dto.feeRecordId, tenantId } });
    if (!fee) {
      throw new NotFoundException('Fee record not found');
    }

    const receiptNo = `RCP-${Date.now()}`;
    const receipt = this.receiptRepo.create({
      feeRecordId: dto.feeRecordId,
      studentName: fee.studentName,
      admNo: fee.admNo,
      amount: dto.amount,
      method: dto.method,
      date: new Date().toISOString().slice(0, 10),
      receivedBy: dto.receivedBy,
      receiptNo,
      term: dto.term,
      notes: dto.notes || '',
      tenantId,
    });

    fee.amountPaid = Number(fee.amountPaid) + dto.amount;
    fee.balance = Number(fee.amountDue) - fee.amountPaid;
    fee.lastPaymentDate = new Date().toISOString().slice(0, 10);
    fee.lastPaymentMethod = dto.method;
    fee.status = fee.balance <= 0 ? 'Cleared' : 'Partial';

    await this.dataSource.transaction(async (manager) => {
      await manager.save(fee);
      await manager.save(receipt);
    });

    return receipt;
  }

  async getReceipts(tenantId: string): Promise<PaymentReceipt[]> {
    return this.receiptRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } });
  }

  async getFeeSummary(tenantId: string) {
    const records = await this.feeRepo.find({ where: { tenantId } });
    const totalBilled = records.reduce((sum, r) => sum + Number(r.amountDue), 0);
    const totalCollected = records.reduce((sum, r) => sum + Number(r.amountPaid), 0);
    const totalOutstanding = records.reduce((sum, r) => sum + Number(r.balance), 0);
    return { totalBilled, totalCollected, totalOutstanding, recordCount: records.length };
  }

  async getPayroll(tenantId: string): Promise<any[]> {
    return [];
  }

  async getExpenditure(tenantId: string): Promise<any[]> {
    return [];
  }

  async createExpenditure(dto: any, tenantId: string): Promise<any> {
    return { ...dto, tenantId };
  }

  async getBudgetItems(tenantId: string): Promise<any[]> {
    return [];
  }

  async getBudgetSubmissions(tenantId: string): Promise<any[]> {
    return [];
  }

  async getInvoices(tenantId: string): Promise<any[]> {
    return [];
  }

  async createReceipt(dto: any, tenantId: string): Promise<any> {
    return { ...dto, tenantId };
  }

  async getProcurement(tenantId: string): Promise<any[]> {
    return [];
  }

  async getPettyCash(tenantId: string): Promise<any[]> {
    return [];
  }

  async getCashTransactions(tenantId: string): Promise<any[]> {
    return [];
  }

  async getStudentAccounts(tenantId: string): Promise<any[]> {
    return [];
  }

  async getImprest(tenantId: string): Promise<any[]> {
    return [];
  }

  async getFeeding(tenantId: string): Promise<any[]> {
    return [];
  }

  async getBoardingSupplies(tenantId: string): Promise<any[]> {
    return [];
  }

  async getReturns(tenantId: string): Promise<any[]> {
    return [];
  }
}
