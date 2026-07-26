import { Module } from '@nestjs/common';
import { GoverningBoardController } from './governing-board.controller';
import { GoverningBoardService } from './governing-board.service';

@Module({ controllers: [GoverningBoardController], providers: [GoverningBoardService] })
export class GoverningBoardModule {}
