import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('vehicles')
export class Vehicle {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() plate: string;
  @Column() type: string;
  @Column({ type: 'date', nullable: true }) insuranceExpiry: string | null;
  @Column({ type: 'date', nullable: true }) roadworthinessExpiry: string | null;
  @Column({ default: 'Active' }) status: string;
  @Column({ type: 'varchar', nullable: true }) assignedDriver: string | null;
  @Column({ type: 'text', nullable: true }) notes: string | null;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
