import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Book } from './book.entity';
import { CirculationRecord } from './circulation-record.entity';

@Injectable()
export class LibraryService {
  constructor(
    @InjectRepository(Book) private readonly bookRepo: Repository<Book>,
    @InjectRepository(CirculationRecord) private readonly circRepo: Repository<CirculationRecord>,
  ) {}

  async getBooks(tenantId: string): Promise<Book[]> {
    return this.bookRepo.find({ where: { tenantId }, order: { title: 'ASC' } });
  }
  async createBook(data: Partial<Book>, tenantId: string): Promise<Book> {
    return this.bookRepo.save(this.bookRepo.create({ ...data, tenantId }));
  }
  async getCirculation(tenantId: string): Promise<CirculationRecord[]> {
    return this.circRepo.find({ where: { tenantId }, order: { createdAt: 'DESC' } });
  }
  async createCirculation(data: Partial<CirculationRecord>, tenantId: string): Promise<CirculationRecord> {
    return this.circRepo.save(this.circRepo.create({ ...data, status: 'Borrowed', tenantId }));
  }
  async returnBook(id: string, tenantId: string): Promise<CirculationRecord | null> {
    const rec = await this.circRepo.findOne({ where: { id, tenantId } });
    if (!rec) return null;
    rec.status = 'Returned';
    rec.returnDate = new Date().toISOString().slice(0, 10);
    return this.circRepo.save(rec);
  }
}
