import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('fee_records')
export class FeeRecord {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  studentName: string;

  @Column()
  admNo: string;

  @Column({ type: 'varchar', nullable: true })
  class: string | null;

  @Column()
  term: string;

  @Column()
  feeType: string;

  @Column({ type: 'decimal', precision: 12, scale: 2 })
  amountDue: number;

  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 })
  amountPaid: number;

  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 })
  balance: number;

  @Column({ default: 'Owing' })
  status: string;

  @Column({ type: 'varchar', nullable: true })
  guardianName: string | null;

  @Column({ type: 'varchar', nullable: true })
  guardianPhone: string | null;

  @Column({ type: 'date', nullable: true })
  lastPaymentDate: string | null;

  @Column({ type: 'varchar', nullable: true })
  lastPaymentMethod: string | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
