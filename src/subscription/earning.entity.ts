import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

export type EarningType = 'credit' | 'debit' | 'payout';
export type EarningStatus = 'pending' | 'claimed' | 'disbursed' | 'cancelled';

@Entity('earnings')
export class EarningEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  userId: string;

  @Column()
  tenantId: string;

  @Column({ type: 'varchar' })
  type: EarningType;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  amount: number;

  @Column({ type: 'varchar', default: 'GHS' })
  currency: string;

  @Column({ type: 'varchar', nullable: true })
  action: string | null;

  @Column({ type: 'varchar', nullable: true })
  resource: string | null;

  @Column({ type: 'varchar', default: 'pending' })
  status: EarningStatus;

  @Column({ type: 'varchar', nullable: true })
  mobileMoneyNumber: string | null;

  @Column({ type: 'varchar', nullable: true })
  payoutReference: string | null;

  @Column({ type: 'varchar', nullable: true })
  disbursedBy: string | null;

  @CreateDateColumn()
  @Index()
  createdAt: Date;
}
