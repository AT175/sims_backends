import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_notifications')
export class TeacherNotificationEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() title: string;
  @Column({ type: 'text' }) message: string;
  @Column({ default: 'System' }) type: string;
  @Column({ type: 'date' }) date: string;
  @Column({ type: 'boolean', default: false }) read: boolean;
  @Column({ type: 'text', nullable: true }) actionUrl: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
