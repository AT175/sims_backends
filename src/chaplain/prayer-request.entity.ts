import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('chaplain_prayer_requests')
export class PrayerRequest {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() studentName: string;
  @Column({ type: 'varchar', nullable: true }) studentClass: string | null;
  @Column({ type: 'text' }) request: string;
  @Column({ default: 'Open' }) status: string;
  @Column({ default: 'Public' }) visibility: string;
  @Column({ type: 'date' }) dateSubmitted: string;
  @Column({ type: 'date', nullable: true }) dateAnswered: string | null;
  @Column({ type: 'text', default: '' }) notes: string;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
