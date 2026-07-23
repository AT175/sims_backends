import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('payment_receipts')
export class PaymentReceipt {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  feeRecordId: string;

  @Column()
  studentName: string;

  @Column()
  admNo: string;

  @Column({ type: 'decimal', precision: 12, scale: 2 })
  amount: number;

  @Column()
  method: string;

  @Column({ type: 'date' })
  date: string;

  @Column()
  receivedBy: string;

  @Column()
  receiptNo: string;

  @Column()
  term: string;

  @Column({ type: 'text', default: '' })
  notes: string;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;
}
