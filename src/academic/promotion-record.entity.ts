import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('promotion_records')
export class PromotionRecord {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  tenantId: string;

  @Column()
  studentId: string;

  @Column()
  admissionNumber: string;

  @Column()
  studentName: string;

  @Column()
  fromLevel: string;

  @Column()
  toLevel: string;

  @Column({ type: 'decimal', precision: 5, scale: 2 })
  overallAverage: number;

  @Column({ type: 'varchar' })
  action: string; // 'promoted' | 'repeated' | 'graduated'

  @Column({ type: 'varchar', nullable: true })
  academicYear: string | null;

  @Column({ type: 'varchar', nullable: true })
  performedBy: string | null;

  @CreateDateColumn()
  createdAt: Date;
}
