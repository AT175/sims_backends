import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('tutor_sessions')
export class TutorSessionEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Index() @Column() studentId: string;
  @Column() studentName: string;
  @Column() classForm: string;

  @Column({ type: 'text' }) subject: string;
  @Column({ type: 'text', nullable: true }) topic: string | null;

  // JSON array of { role: 'user'|'tutor', content: string, timestamp: string }
  @Column({ type: 'text', default: '[]' }) messages: string;

  @CreateDateColumn() createdAt: Date;
}
