import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_shared_resources')
export class SharedResourceEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() title: string;
  @Column() subject: string;
  @Column({ default: 'Notes' }) type: string;
  @Column() sharedBy: string;
  @Column({ type: 'date' }) sharedDate: string;
  @Column({ type: 'text', default: '' }) description: string;
  @Column() classForm: string;
  @Column({ type: 'text', nullable: true }) fileUrl: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
