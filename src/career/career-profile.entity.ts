import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

@Entity('career_profiles')
export class CareerProfileEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Index() @Column() studentId: string;
  @Column() studentName: string;

  @Column({ type: 'simple-array', default: [] }) interests: string[];
  @Column({ type: 'simple-array', default: [] }) favoriteSubjects: string[];
  @Column({ type: 'simple-array', default: [] }) savedOpportunities: string[];

  @Column({ type: 'varchar', nullable: true }) preferredCareerPath: string | null;

  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
