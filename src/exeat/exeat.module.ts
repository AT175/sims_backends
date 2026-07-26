import { Module } from '@nestjs/common';
import { ExeatController } from './exeat.controller';
import { ExeatService } from './exeat.service';

@Module({ controllers: [ExeatController], providers: [ExeatService] })
export class ExeatModule {}
