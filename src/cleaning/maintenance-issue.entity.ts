import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('maintenance_issues')
export class MaintenanceIssue {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ type: 'date' }) date: string;
  @Column({ type: 'varchar', nullable: true }) location: string | null;
  @Column({ type: 'text' }) issue: string;
  @Column({ default: 'Medium' }) priority: string;
  @Column({ default: 'Reported' }) status: string;
  @Column() reportedBy: string;
  @Column({ type: 'text', default: '' }) notes: string;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
