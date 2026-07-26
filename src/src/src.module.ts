import { Module } from '@nestjs/common';
import { SrcController } from './src.controller';
import { SrcService } from './src.service';

@Module({ controllers: [SrcController], providers: [SrcService] })
export class SrcModule {}
