import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  Index,
} from 'typeorm';

@Entity('exam_results')
export class ExamResult {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  studentName: string;

  @Column()
  admNo: string;

  @Column()
  subject: string;

  @Column()
  term: string;

  @Column({ type: 'varchar', nullable: true })
  examType: string | null;

  @Column({ type: 'decimal', precision: 5, scale: 2 })
  marks: number;

  @Column({ type: 'varchar', nullable: true })
  grade: string | null;

  @Column({ type: 'text', nullable: true })
  remarks: string | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;
}
