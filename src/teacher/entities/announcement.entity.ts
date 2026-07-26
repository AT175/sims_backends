import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_announcements')
export class AnnouncementEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() title: string;
  @Column({ type: 'text', default: '' }) body: string;
  @Column() classForm: string;
  @Column({ type: 'date' }) date: string;
  @Column() postedBy: string;
  @Column({ default: 'Normal' }) priority: string;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
