import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('sports_fixtures')
export class SportsFixture {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ type: 'date' }) date: string;
  @Column() sport: string;
  @Column() match: string;
  @Column({ type: 'varchar', nullable: true }) venue: string | null;
  @Column({ default: 'Upcoming' }) status: string;
  @Column({ type: 'varchar', nullable: true }) scoreHome: string | null;
  @Column({ type: 'varchar', nullable: true }) scoreAway: string | null;
  @Column({ type: 'varchar', nullable: true }) result: string | null;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
