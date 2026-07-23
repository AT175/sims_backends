import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('security_incidents')
export class SecurityIncident {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ type: 'varchar', nullable: true }) incidentId: string | null;
  @Column({ type: 'date' }) date: string;
  @Column() time: string;
  @Column() type: string;
  @Column({ type: 'varchar', nullable: true }) location: string | null;
  @Column({ type: 'text' }) description: string;
  @Column({ default: 'Low' }) severity: string;
  @Column({ default: 'Reported' }) status: string;
  @Column() reportedBy: string;
  @Column({ type: 'varchar', nullable: true }) assignedTo: string | null;
  @Column({ type: 'text', nullable: true }) resolution: string | null;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
