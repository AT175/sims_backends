import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('sports_clubs')
export class SportsClub {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() name: string;
  @Column({ type: 'varchar', nullable: true }) category: string | null;
  @Column({ type: 'varchar', nullable: true }) patron: string | null;
  @Column({ type: 'int', default: 0 }) memberCount: number;
  @Column({ type: 'varchar', nullable: true }) meetingDay: string | null;
  @Column({ type: 'text', nullable: true }) description: string | null;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
