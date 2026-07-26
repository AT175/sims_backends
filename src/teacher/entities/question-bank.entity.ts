import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_question_bank')
export class QuestionBankEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() subject: string;
  @Column() topic: string;
  @Column() type: string;
  @Column({ type: 'text' }) question: string;
  @Column({ type: 'json', nullable: true }) options: string[] | null;
  @Column({ type: 'text' }) correctAnswer: string;
  @Column({ type: 'int', default: 2 }) marks: number;
  @Column({ default: 'Easy' }) difficulty: string;
  @Column({ type: 'json', default: [] }) tags: string[];

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
