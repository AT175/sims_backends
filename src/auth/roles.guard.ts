import { Injectable, CanActivate, ExecutionContext, ForbiddenException, UnauthorizedException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from './roles.decorator';
import { JwtPayload } from './jwt.strategy';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!requiredRoles) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest<{ user: JwtPayload }>();
    if (!user) {
      return true;
    }
    const hasRole = user.roles.some((role) => requiredRoles.includes(role));
    if (!hasRole) {
      throw new ForbiddenException('You do not have permission to access this resource');
    }
    return true;
  }
}
