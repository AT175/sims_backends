import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Book } from './book.entity';
import { CirculationRecord } from './circulation-record.entity';
import { LibraryService } from './library.service';
import { LibraryController } from './library.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Book, CirculationRecord])],
  providers: [LibraryService],
  controllers: [LibraryController],
})
export class LibraryModule {}
