import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('leave_requests')
export class LeaveRequest {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  staffName: string;

  @Column()
  staffRole: string;

  @Column({ type: 'date' })
  startDate: string;

  @Column({ type: 'date' })
  endDate: string;

  @Column()
  type: string;

  @Column({ type: 'text', default: '' })
  reason: string;

  @Column({ default: 'Pending' })
  status: string;

  @Column({ type: 'varchar', nullable: true })
  reviewedBy: string | null;

  @Column({ type: 'date', nullable: true })
  reviewDate: string | null;

  @Column({ type: 'text', nullable: true })
  reviewNotes: string | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;
}
