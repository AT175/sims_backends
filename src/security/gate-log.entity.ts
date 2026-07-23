import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('gate_logs')
export class GateLog {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() date: string;
  @Column() time: string;
  @Column() visitorName: string;
  @Column({ type: 'varchar', nullable: true }) vehiclePlate: string | null;
  @Column({ type: 'text', default: '' }) purpose: string;
  @Column({ type: 'varchar', nullable: true }) host: string | null;
  @Column({ default: 'In' }) status: string;
  @Column({ type: 'varchar', nullable: true }) checkInTime: string | null;
  @Column({ type: 'varchar', nullable: true }) checkOutTime: string | null;
  @Column({ type: 'text', nullable: true }) notes: string | null;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
