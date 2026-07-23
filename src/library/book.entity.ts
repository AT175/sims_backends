import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('books')
export class Book {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() title: string;
  @Column() author: string;
  @Column({ type: 'varchar', nullable: true }) category: string | null;
  @Column({ type: 'varchar', nullable: true }) isbn: string | null;
  @Column({ type: 'int', default: 0 }) totalCopies: number;
  @Column({ type: 'int', default: 0 }) availableCopies: number;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
