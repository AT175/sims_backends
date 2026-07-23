import { Body, Controller, Post, Get, Param, UseGuards, Request } from '@nestjs/common';
import { IsString, MinLength, IsArray, IsOptional } from 'class-validator';
import { SkipThrottle, Throttle } from '@nestjs/throttler';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './jwt-auth.guard';
import { Roles } from './roles.decorator';

class LoginDto {
  @IsString()
  @MinLength(3)
  username: string;

  @IsString()
  @MinLength(6)
  password: string;
}

class SwitchRoleDto {
  @IsString()
  role: string;
}

class UpdateProfileDto {
  @IsString()
  displayName?: string;

  @IsString()
  profilePictureUrl?: string;
}

class ChangePasswordDto {
  @IsString()
  @MinLength(12)
  currentPassword: string;

  @IsString()
  @MinLength(12)
  newPassword: string;
}

class UploadPictureDto {
  @IsString()
  image: string;
}

class RefreshTokenDto {
  @IsString()
  refreshToken: string;
}

class MasterKeyDto {
  @IsString()
  tenantId: string;

  maxUses?: number;
}

class CreateUserDto {
  @IsString()
  @MinLength(3)
  username: string;

  @IsString()
  @MinLength(6)
  password: string;

  @IsString()
  displayName: string;

  @IsOptional()
  @IsString()
  email?: string;

  @IsArray()
  roles: string[];

  @IsString()
  tenantId: string;

  @IsOptional()
  @IsString()
  activeRole?: string;
}

class AdminResetPasswordDto {
  @IsString()
  @MinLength(6)
  newPassword: string;
}

@Controller('auth')
@SkipThrottle({ default: false })
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @Throttle({ auth: { ttl: 60000, limit: 5 } })
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto.username, dto.password);
  }

  @Post('login-temp')
  @Throttle({ auth: { ttl: 60000, limit: 5 } })
  async loginTemp(@Body() dto: LoginDto) {
    return this.authService.loginWithTempCredentials(dto.username, dto.password);
  }

  @Post('update-profile')
  @UseGuards(JwtAuthGuard)
  async updateProfile(@Request() req: any, @Body() dto: UpdateProfileDto) {
    return this.authService.updateProfile(req.user.id, dto);
  }

  @Post('change-password')
  @UseGuards(JwtAuthGuard)
  async changePassword(@Request() req: any, @Body() dto: ChangePasswordDto) {
    return this.authService.changePassword(req.user.id, dto.currentPassword, dto.newPassword);
  }

  @Post('upload-profile-picture')
  @UseGuards(JwtAuthGuard)
  async uploadProfilePicture(@Request() req: any, @Body() dto: UploadPictureDto) {
    return this.authService.uploadProfilePicture(req.user.id, dto.image);
  }

  @Post('switch-role')
  @UseGuards(JwtAuthGuard)
  async switchRole(@Request() req: any, @Body() dto: SwitchRoleDto) {
    return this.authService.switchRole(req.user.id, dto.role);
  }

  @Post('refresh')
  @Throttle({ auth: { ttl: 60000, limit: 10 } })
  async refresh(@Body() dto: RefreshTokenDto) {
    return this.authService.rotateRefreshToken(dto.refreshToken);
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  async logout(@Request() req: any, @Body() dto: RefreshTokenDto) {
    await this.authService.revokeRefreshToken(dto.refreshToken);
    await this.authService.revokeAllUserRefreshTokens(req.user.id);
    return { message: 'Logged out successfully' };
  }

  @Post('voter-master-key')
  @UseGuards(JwtAuthGuard)
  @Roles('headmaster', 'system_admin')
  async createVoterMasterKey(@Request() req: any, @Body() dto: MasterKeyDto) {
    const tenantId = dto.tenantId || req.user.tenantId;
    return this.authService.createVoterMasterKey(tenantId, req.user.id, dto.maxUses);
  }

  @Post('revoke-voter-master-key')
  @UseGuards(JwtAuthGuard)
  @Roles('headmaster', 'system_admin')
  async revokeVoterMasterKey(@Request() req: any, @Body() dto: MasterKeyDto) {
    const tenantId = dto.tenantId || req.user.tenantId;
    await this.authService.revokeVoterMasterKey(tenantId);
    return { message: 'Voter master key revoked' };
  }

  @Post('users')
  @UseGuards(JwtAuthGuard)
  @Roles('headmaster', 'system_admin')
  async createUser(@Body() dto: CreateUserDto) {
    return this.authService.createUser(dto);
  }

  @Post('users/:id/reset-password')
  @UseGuards(JwtAuthGuard)
  @Roles('headmaster', 'system_admin')
  async adminResetPassword(@Param('id') id: string, @Body() dto: AdminResetPasswordDto) {
    return this.authService.adminResetPassword(id, dto.newPassword);
  }

  @Get('users')
  @UseGuards(JwtAuthGuard)
  @Roles('headmaster', 'system_admin')
  async listUsers(@Request() req: any) {
    return this.authService.listUsers(req.user.tenantId);
  }
}
