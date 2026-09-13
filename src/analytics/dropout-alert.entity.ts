import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('dropout_alerts')
export class DropoutAlertEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() tenantId: string;
  @Index() @Column() studentId: string;
  @Column() studentName: string;
  @Column() admissionNumber: string;
  @Column() classForm: string;

  @Column({ type: 'int' }) riskScore: number;
  @Column({ default: 'Low' }) riskLevel: string;  // Low | Medium | High

  @Column({ type: 'simple-array' }) riskFactors: string[];
  @Column({ type: 'text', nullable: true }) recommendation: string | null;

  @Column({ default: 'Active' }) status: string;  // Active | Resolved | Monitoring
  @Column({ type: 'varchar', nullable: true }) assignedTo: string | null;

  @CreateDateColumn() createdAt: Date;
}
