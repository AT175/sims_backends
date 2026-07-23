import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index } from 'typeorm';

@Entity('kitchen_menus')
export class KitchenMenu {
  @PrimaryGeneratedColumn('uuid') id: string;
  @Column() day: string;
  @Column({ type: 'text' }) breakfast: string;
  @Column({ type: 'text' }) lunch: string;
  @Column({ type: 'text' }) dinner: string;
  @Index() @Column() tenantId: string;
  @CreateDateColumn() createdAt: Date;
}
