import { Module } from '@nestjs/common';
import { AcademicBoardController } from './academic-board.controller';
import { AcademicBoardService } from './academic-board.service';

@Module({ controllers: [AcademicBoardController], providers: [AcademicBoardService] })
export class AcademicBoardModule {}
