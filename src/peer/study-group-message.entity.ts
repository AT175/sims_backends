import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('study_group_messages')
export class StudyGroupMessageEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Index() @Column() groupId: string;
  @Column() studentId: string;
  @Column() studentName: string;

  @Column({ type: 'text' }) content: string;

  @CreateDateColumn() createdAt: Date;
}
