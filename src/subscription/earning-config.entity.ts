import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('earning_configs')
export class EarningConfigEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  tenantId: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0.1 })
  ratePerAction: number;

  @Column({ type: 'int', default: 100 })
  maxActionsPerDay: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 50 })
  minPayoutThreshold: number;

  @Column({ type: 'varchar', default: 'GHS' })
  currency: string;

  @Column({ type: 'boolean', default: true })
  enabled: boolean;

  @CreateDateColumn()
  createdAt: Date;
}
