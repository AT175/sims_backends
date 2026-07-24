import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Tenant } from './tenant.entity';
import { TenantsService } from './tenants.service';
import { TenantsController } from './tenants.controller';
import { PublicTenantsController } from './public-tenants.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Tenant])],
  providers: [TenantsService],
  controllers: [TenantsController, PublicTenantsController],
  exports: [TenantsService],
})
export class TenantsModule {}
