import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_calendar_events')
export class CalendarEventEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() title: string;
  @Column({ type: 'date' }) date: string;
  @Column({ nullable: true }) time: string | null;
  @Column({ default: 'Lesson' }) type: string;
  @Column({ nullable: true }) subject: string | null;
  @Column({ nullable: true }) classForm: string | null;
  @Column({ type: 'text', nullable: true }) notes: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
