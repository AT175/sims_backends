import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('requisitions')
export class Requisition {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ type: 'date' }) date: string;
  @Column() itemName: string;
  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 }) quantity: number;
  @Column({ type: 'varchar', nullable: true }) unit: string | null;
  @Column() department: string;
  @Column({ default: 'Pending' }) status: string;
  @Column() requestedBy: string;
  @Column({ default: 'Normal' }) priority: string;
  @Column({ type: 'text', default: '' }) notes: string;
  @Column({ type: 'varchar', nullable: true }) house: string | null;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
