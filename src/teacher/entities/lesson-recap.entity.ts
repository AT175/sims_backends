import { Entity, PrimaryGeneratedColumn, Column, Index, CreateDateColumn } from 'typeorm';

@Entity('teacher_lesson_recaps')
export class LessonRecapEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Column() teacherId: string;
  @Column() teacherName: string;

  @Column() classForm: string;
  @Column() subject: string;
  @Column() topic: string;
  @Column() date: string;

  @Column({ nullable: true }) week: string;
  @Column({ nullable: true }) term: string;

  @Column('text', { nullable: true }) keyPoints: string;
  @Column('text', { nullable: true }) activitiesDone: string;
  @Column('text', { nullable: true }) homework: string;
  @Column('text', { nullable: true }) nextLessonPreview: string;
  @Column('text', { nullable: true }) teacherNotes: string;

  @CreateDateColumn() createdAt: Date;
}
