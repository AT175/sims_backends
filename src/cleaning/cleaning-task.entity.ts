import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('cleaning_tasks')
export class CleaningTask {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() task: string;
  @Column({ type: 'varchar', nullable: true }) area: string | null;
  @Column({ default: 'Daily' }) frequency: string;
  @Column({ type: 'varchar', nullable: true }) assignedTo: string | null;
  @Column({ default: false }) done: boolean;
  @Column({ type: 'date', nullable: true }) date: string | null;
  @Column({ default: 'Medium' }) priority: string;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
