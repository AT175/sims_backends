import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_av_recordings')
export class AVRecordingEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() title: string;
  @Column() type: string;
  @Column({ default: '' }) duration: string;
  @Column() classForm: string;
  @Column() subject: string;
  @Column({ default: '' }) topic: string;
  @Column({ type: 'date' }) dateRecorded: string;
  @Column() recordedBy: string;
  @Column({ type: 'text', nullable: true }) url: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
