import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_syllabus')
export class SyllabusTopicEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() subject: string;
  @Column() classForm: string;
  @Column() topic: string;
  @Column({ type: 'text', default: '' }) subTopics: string;
  @Column({ type: 'int', default: 1 }) week: number;
  @Column({ default: 'Not Started' }) status: string;
  @Column({ type: 'date', nullable: true }) dateTaught: string | null;
  @Column({ type: 'text', nullable: true }) notes: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
