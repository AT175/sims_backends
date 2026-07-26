import { Module } from '@nestjs/common';
import { HeadmasterController } from './headmaster.controller';
import { HeadmasterService } from './headmaster.service';

@Module({ controllers: [HeadmasterController], providers: [HeadmasterService] })
export class HeadmasterModule {}
