import { Module } from '@nestjs/common';
import { SafeSpaceController } from './safe-space.controller';
import { SafeSpaceService } from './safe-space.service';

@Module({ controllers: [SafeSpaceController], providers: [SafeSpaceService] })
export class SafeSpaceModule {}
