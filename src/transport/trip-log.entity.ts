import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('trip_logs')
export class TripLog {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ type: 'date' }) date: string;
  @Column() vehiclePlate: string;
  @Column() driverName: string;
  @Column() route: string;
  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 }) mileage: number;
  @Column({ type: 'text', default: '' }) purpose: string;
  @Column({ type: 'varchar', nullable: true }) departureTime: string | null;
  @Column({ type: 'varchar', nullable: true }) returnTime: string | null;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
