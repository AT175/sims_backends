import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Vehicle } from './vehicle.entity';
import { TripLog } from './trip-log.entity';
import { TransportService } from './transport.service';
import { TransportController } from './transport.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Vehicle, TripLog])],
  providers: [TransportService],
  controllers: [TransportController],
})
export class TransportModule {}
