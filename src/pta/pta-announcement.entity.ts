import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('pta_announcements')
export class PTAAnnouncement {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() title: string;
  @Column({ type: 'text' }) body: string;
  @Column({ type: 'date' }) date: string;
  @Column() author: string;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
