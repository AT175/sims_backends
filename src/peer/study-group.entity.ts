import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('study_groups')
export class StudyGroupEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Column() name: string;
  @Column() subject: string;
  @Column({ type: 'text', nullable: true }) description: string | null;
  @Column() createdBy: string;
  @Column() createdByName: string;

  // simple-array of student IDs
  @Column({ type: 'simple-array', default: [] }) members: string[];

  @Column({ type: 'boolean', default: false }) isOfficial: boolean;
  @Column({ type: 'varchar', nullable: true }) classForm: string | null;

  @CreateDateColumn() createdAt: Date;
}
