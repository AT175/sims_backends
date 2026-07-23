import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('kitchen_stock_items')
export class KitchenStockItem {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() name: string;
  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 }) quantity: number;
  @Column({ type: 'varchar', nullable: true }) unit: string | null;
  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 }) reorderLevel: number;
  @Column({ type: 'varchar', nullable: true }) category: string | null;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
