import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('teacher_materials')
export class LessonMaterialEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column() title: string;
  @Column() type: string;
  @Column() classForm: string;
  @Column() subject: string;
  @Column({ default: '' }) topic: string;
  @Column({ type: 'text', default: '' }) description: string;
  @Column({ type: 'date' }) dateUploaded: string;
  @Column() uploadedBy: string;
  @Column({ type: 'text', nullable: true }) fileUrl: string | null;

  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
