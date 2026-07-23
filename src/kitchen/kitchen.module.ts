import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { KitchenStockItem } from './kitchen-stock-item.entity';
import { KitchenMenu } from './kitchen-menu.entity';
import { KitchenService } from './kitchen.service';
import { KitchenController } from './kitchen.controller';

@Module({
  imports: [TypeOrmModule.forFeature([KitchenStockItem, KitchenMenu])],
  providers: [KitchenService],
  controllers: [KitchenController],
})
export class KitchenModule {}
