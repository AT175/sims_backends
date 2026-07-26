import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('assignment_submissions')
export class AssignmentSubmission {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  assignmentId: string;

  @Index()
  @Column()
  studentId: string;

  @Column()
  studentName: string;

  @Column()
  assignmentTitle: string;

  @Column()
  subject: string;

  @Column()
  dueDate: string;

  @Column({ type: 'text', nullable: true })
  content: string | null;

  @Column({ type: 'varchar', nullable: true })
  fileUrl: string | null;

  @Column({ default: 'Not Submitted' })
  status: string;

  @Column({ type: 'int', nullable: true })
  score: number | null;

  @Column({ type: 'int', default: 20 })
  maxScore: number;

  @Column({ type: 'text', nullable: true })
  feedback: string | null;

  @Column({ type: 'timestamp', nullable: true })
  submittedAt: Date | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
