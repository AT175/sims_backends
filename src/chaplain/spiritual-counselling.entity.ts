import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('chaplain_counselling')
export class SpiritualCounselling {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() studentName: string;
  @Column({ type: 'varchar', nullable: true }) studentClass: string | null;
  @Column() type: string;
  @Column({ type: 'date' }) date: string;
  @Column({ type: 'text' }) summary: string;
  @Column({ type: 'date', nullable: true }) followUpDate: string | null;
  @Column({ default: 'Open' }) status: string;
  @Column({ type: 'text', default: '' }) notes: string;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
