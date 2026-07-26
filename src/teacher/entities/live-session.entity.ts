import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_live_sessions')
export class LiveSessionEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() subject: string;
  @Column() classForm: string;
  @Column() scheduledTime: string;
  @Column({ default: 'Scheduled' }) status: string;
  @Column() topic: string;
  @Column({ default: '' }) startedBy: string;
  @Column({ type: 'int', default: 0 }) participants: number;
  @Column({ type: 'text', nullable: true }) recordingUrl: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
