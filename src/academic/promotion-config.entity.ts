import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('promotion_config')
export class PromotionConfig {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ unique: true })
  tenantId: string;

  @Column({ type: 'decimal', precision: 5, scale: 2, default: 50 })
  promotionAverage: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, default: 40 })
  repeatAverage: number;

  @Column({ type: 'varchar', default: 'Term 3' })
  promotionTerm: string;

  @Column({ type: 'boolean', default: true })
  enabled: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
