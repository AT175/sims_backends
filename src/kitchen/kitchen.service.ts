import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { KitchenStockItem } from './kitchen-stock-item.entity';
import { KitchenMenu } from './kitchen-menu.entity';

@Injectable()
export class KitchenService {
  constructor(
    @InjectRepository(KitchenStockItem) private readonly stockRepo: Repository<KitchenStockItem>,
    @InjectRepository(KitchenMenu) private readonly menuRepo: Repository<KitchenMenu>,
  ) {}

  async getStock(tenantId: string): Promise<KitchenStockItem[]> {
    return this.stockRepo.find({ where: { tenantId }, order: { name: 'ASC' } });
  }
  async createStock(data: Partial<KitchenStockItem>, tenantId: string): Promise<KitchenStockItem> {
    return this.stockRepo.save(this.stockRepo.create({ ...data, tenantId }));
  }
  async getMenus(tenantId: string): Promise<KitchenMenu[]> {
    return this.menuRepo.find({ where: { tenantId } });
  }
  async createMenu(data: Partial<KitchenMenu>, tenantId: string): Promise<KitchenMenu> {
    return this.menuRepo.save(this.menuRepo.create({ ...data, tenantId }));
  }
}
