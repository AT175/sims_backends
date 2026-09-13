import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('forum_answers')
export class ForumAnswerEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Index() @Column() questionId: string;
  @Column() studentId: string;
  @Column() studentName: string;

  @Column({ type: 'text' }) content: string;

  @Column({ type: 'int', default: 0 }) upvotes: number;
  @Column({ type: 'boolean', default: false }) isAccepted: boolean;
  @Column({ type: 'boolean', default: false }) flagged: boolean;

  @CreateDateColumn() createdAt: Date;
}
