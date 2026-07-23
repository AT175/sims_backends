import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('circulation_records')
export class CirculationRecord {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ type: 'date' }) date: string;
  @Column() bookId: string;
  @Column() bookTitle: string;
  @Column() borrowerName: string;
  @Column({ type: 'varchar', nullable: true }) borrowerClass: string | null;
  @Column({ type: 'date' }) dueDate: string;
  @Column({ type: 'date', nullable: true }) returnDate: string | null;
  @Column({ default: 'Borrowed' }) status: string;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
