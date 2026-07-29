import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';

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
  constructor(config: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.getOrThrow('JWT_SECRET'),
    });
  }

  async validate(payload: JwtPayload) {
    // Trust the signed JWT payload directly — avoids a DB query on every request.
    // Token has a short expiry (15m) so role/status changes propagate within that window.
    return {
      id: payload.sub,
      tenantId: payload.tenantId,
      username: payload.username,
      roles: payload.roles,
      activeRole: payload.activeRole,
      isTempLogin: payload.isTempLogin ?? false,
    };
  }
}
