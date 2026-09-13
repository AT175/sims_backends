import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('forum_questions')
export class ForumQuestionEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Index() @Column() studentId: string;
  @Column() studentName: string;
  @Column() classForm: string;

  @Column() subject: string;
  @Column({ type: 'varchar', nullable: true }) topic: string | null;
  @Column({ type: 'text' }) question: string;
  @Column({ type: 'simple-array', default: [] }) tags: string[];

  @Column({ type: 'int', default: 0 }) upvotes: number;
  @Column({ type: 'int', default: 0 }) answerCount: number;
  @Column({ type: 'int', default: 0 }) viewCount: number;

  @Column({ default: 'open' }) status: string; // open | answered | closed | flagged
  @Column({ type: 'boolean', default: false }) pinned: boolean;

  @CreateDateColumn() createdAt: Date;
}
