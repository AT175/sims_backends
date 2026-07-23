import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('audit_logs')
export class AuditLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  userId: string;

  @Column({ type: 'varchar', nullable: true })
  username: string | null;

  @Column()
  action: string;

  @Column({ type: 'varchar', nullable: true })
  resource: string | null;

  @Column({ type: 'text', nullable: true })
  details: string | null;

  @Column({ type: 'varchar', nullable: true })
  ipAddress: string | null;

  @Column({ type: 'varchar', nullable: true })
  userAgent: string | null;

  @Column({ default: false })
  success: boolean;

  @CreateDateColumn()
  createdAt: Date;
}
