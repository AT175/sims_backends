import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

export type SubscriptionPlan = 'trial' | 'annual';
export type SubscriptionStatus = 'active' | 'expired' | 'cancelled' | 'pending';

@Entity('subscriptions')
export class SubscriptionEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  userId: string;

  @Column()
  tenantId: string;

  @Column({ type: 'varchar', default: 'trial' })
  plan: SubscriptionPlan;

  @Column({ type: 'varchar', default: 'pending' })
  status: SubscriptionStatus;

  @Column({ type: 'date' })
  startDate: string;

  @Column({ type: 'date' })
  endDate: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  amount: number;

  @Column({ type: 'varchar', default: 'GHS' })
  currency: string;

  @Column({ type: 'varchar', nullable: true })
  paymentMethod: string | null;

  @Column({ type: 'varchar', nullable: true })
  paymentReference: string | null;

  @Column({ type: 'varchar', nullable: true })
  paymentStatus: string | null;

  @Column({ type: 'varchar', nullable: true })
  studentAdmissionNumber: string | null;

  @Column({ type: 'varchar', nullable: true })
  studentName: string | null;

  @CreateDateColumn()
  createdAt: Date;
}
