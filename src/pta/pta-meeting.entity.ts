import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('pta_meetings')
export class PTAMeeting {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column({ type: 'date' }) date: string;
  @Column() time: string;
  @Column() topic: string;
  @Column({ type: 'varchar', nullable: true }) location: string | null;
  @Column({ default: 'Not Responded' }) rsvp: string;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
