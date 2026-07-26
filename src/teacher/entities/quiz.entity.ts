import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_quizzes')
export class QuizEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() title: string;
  @Column() subject: string;
  @Column() classForm: string;
  @Column({ type: 'json', default: [] }) questionIds: string[];
  @Column({ type: 'int', default: 0 }) totalMarks: number;
  @Column({ type: 'int', default: 30 }) duration: number;
  @Column({ type: 'date' }) dueDate: string;
  @Column({ type: 'date' }) expiryDate: string;
  @Column({ default: 'Draft' }) status: string;
  @Column({ type: 'date' }) createdAt: string;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAtColumn: Date;
}
