import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Vehicle } from './vehicle.entity';
import { TripLog } from './trip-log.entity';

@Injectable()
export class TransportService {
  constructor(
    @InjectRepository(Vehicle) private readonly vehicleRepo: Repository<Vehicle>,
    @InjectRepository(TripLog) private readonly tripRepo: Repository<TripLog>,
  ) {}

  async getVehicles(tenantId: string): Promise<Vehicle[]> {
    return this.vehicleRepo.find({ where: { tenantId }, order: { plate: 'ASC' } });
  }
  async createVehicle(data: Partial<Vehicle>, tenantId: string): Promise<Vehicle> {
    return this.vehicleRepo.save(this.vehicleRepo.create({ ...data, tenantId }));
  }
  async getTrips(tenantId: string): Promise<TripLog[]> {
    return this.tripRepo.find({ where: { tenantId }, order: { date: 'DESC' } });
  }
  async createTrip(data: Partial<TripLog>, tenantId: string): Promise<TripLog> {
    return this.tripRepo.save(this.tripRepo.create({ ...data, tenantId }));
  }
}
