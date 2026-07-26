import { Module } from '@nestjs/common';
import { DiningHallController } from './dining-hall.controller';
import { DiningHallService } from './dining-hall.service';

@Module({ controllers: [DiningHallController], providers: [DiningHallService] })
export class DiningHallModule {}
