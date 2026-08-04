import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';

export interface JwtPayload {
  sub: string;
  tenantId: string;
  username: string;
  roles: string[];
  activeRole: string;
  isTempLogin?: boolean;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.getOrThrow('JWT_SECRET'),
    });
  }

  async validate(payload: JwtPayload) {
    // Handle temp login - skip database lookup
    if (payload.isTempLogin) {
      return {
        id: payload.sub,
        tenantId: payload.tenantId,
        username: payload.username,
        roles: payload.roles,
        activeRole: payload.activeRole,
        isTempLogin: true,
      };
    }

    const user = await this.userRepo.findOne({ where: { id: payload.sub } });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    return {
      id: user.id,
      tenantId: user.tenantId,
      username: user.username,
      roles: user.roles,
      activeRole: user.activeRole,
    };
  }
}
