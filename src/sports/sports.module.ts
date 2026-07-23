import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SportsFixture } from './sports-fixture.entity';
import { SportsClub } from './sports-club.entity';
import { SportsService } from './sports.service';
import { SportsController } from './sports.controller';

@Module({
  imports: [TypeOrmModule.forFeature([SportsFixture, SportsClub])],
  providers: [SportsService],
  controllers: [SportsController],
})
export class SportsModule {}
