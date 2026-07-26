import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Entity('student_results')
export class StudentResult {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column()
  studentId: string;

  @Column()
  studentName: string;

  @Column()
  subject: string;

  @Column()
  term: string;

  @Column({ type: 'int', default: 0 })
  score: number;

  @Column({ type: 'int', default: 100 })
  maxScore: number;

  @Column({ default: '' })
  grade: string;

  @Column({ type: 'int', nullable: true })
  classPosition: number | null;

  @Column({ type: 'int', nullable: true })
  classSize: number | null;

  @Column({ type: 'numeric', nullable: true })
  termAverage: number | null;

  @Index()
  @Column()
  tenantId: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
