import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_behavior_notes')
export class BehaviorNoteEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() studentName: string;
  @Column() admNo: string;
  @Column() classForm: string;
  @Column({ type: 'date' }) date: string;
  @Column({ default: 'Neutral' }) type: string;
  @Column({ default: 'Low' }) severity: string;
  @Column({ default: '' }) category: string;
  @Column({ type: 'text', default: '' }) description: string;
  @Column({ type: 'text', default: '' }) actionTaken: string;
  @Column() reportedBy: string;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
