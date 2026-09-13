import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

@Entity('investors')
export class InvestorEntity {
  @PrimaryGeneratedColumn('uuid') id: string;

  @Index() @Column() userId: string;

  @Column() fullName: string;
  @Column({ type: 'varchar', nullable: true }) email: string | null;
  @Column({ type: 'varchar', nullable: true }) phone: string | null;
  @Column({ type: 'varchar', nullable: true }) organization: string | null;

  // Investment details
  @Column({ type: 'decimal', precision: 12, scale: 2, default: 0 }) amountInvested: number;
  @Column({ type: 'varchar', default: 'GHS' }) currency: string;
  @Column({ type: 'decimal', precision: 5, scale: 2, default: 0 }) equityPercentage: number;

  @Column({ type: 'date', nullable: true }) investmentDate: string | null;

  // Status: pending | confirmed | active | withdrawn
  @Column({ type: 'varchar', default: 'pending' }) status: string;

  @Column({ type: 'text', nullable: true }) notes: string | null;

  // Linked user account info
  @Column({ type: 'varchar', nullable: true }) username: string | null;

  @CreateDateColumn() createdAt: Date;
  @UpdateDateColumn() updatedAt: Date;
}
