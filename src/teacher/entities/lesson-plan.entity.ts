import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_lesson_plans')
export class LessonPlanEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() subject: string;
  @Column() classForm: string;
  @Column({ type: 'date' }) date: string;
  @Column() topic: string;
  @Column({ type: 'text', default: '' }) objectives: string;
  @Column({ type: 'text', default: '' }) teachingMethods: string;
  @Column({ type: 'text', default: '' }) resources: string;
  @Column({ type: 'text', default: '' }) activities: string;
  @Column({ type: 'text', default: '' }) assessment: string;
  @Column({ type: 'text', default: '' }) homework: string;
  @Column({ default: 'Planned' }) status: string;
  @Column({ type: 'text', nullable: true }) reflection: string | null;
  @Column({ type: 'text', nullable: true }) fileUrl: string | null;
  @Column({ type: 'text', nullable: true }) fileName: string | null;
  @Column({ nullable: true }) teacherId: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
