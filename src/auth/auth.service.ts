import { Injectable, UnauthorizedException, BadRequestException, NotFoundException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThan } from 'typeorm';
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';
import { User } from './user.entity';
import { Student } from '../students/student.entity';
import { RefreshToken } from './refresh-token.entity';
import { VoterMasterKey } from './voter-master-key.entity';
import { AuditService } from '../audit/audit.service';
import { TenantsService } from '../tenants/tenants.service';
import { SubscriptionService } from '../subscription/subscription.service';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
    @InjectRepository(Student)
    private readonly studentRepo: Repository<Student>,
    @InjectRepository(RefreshToken)
    private readonly refreshTokenRepo: Repository<RefreshToken>,
    @InjectRepository(VoterMasterKey)
    private readonly masterKeyRepo: Repository<VoterMasterKey>,
    private readonly jwtService: JwtService,
    private readonly auditService: AuditService,
    private readonly tenantsService: TenantsService,
    private readonly subscriptionService: SubscriptionService,
  ) {}

  async validateUser(username: string, password: string): Promise<User> {
    const user = await this.userRepo.findOne({ where: { username } });
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    if (user.lockedUntil && new Date() < user.lockedUntil) {
      throw new UnauthorizedException('Account is temporarily locked due to multiple failed login attempts');
    }

    const valid = await bcrypt.compare(password, user.passwordHash);
    if (!valid) {
      user.failedLoginAttempts += 1;
      if (user.failedLoginAttempts >= 5) {
        const lockout = new Date();
        lockout.setMinutes(lockout.getMinutes() + 30);
        user.lockedUntil = lockout;
      }
      await this.userRepo.save(user);
      await this.auditService.log({
        userId: user.id,
        username: user.username,
        action: 'login_failed',
        resource: 'auth',
        details: `Attempt ${user.failedLoginAttempts}`,
        success: false,
      });
      throw new UnauthorizedException('Invalid credentials');
    }

    if (user.failedLoginAttempts > 0) {
      user.failedLoginAttempts = 0;
      user.lockedUntil = null;
      await this.userRepo.save(user);
    }

    return user;
  }

  private async createRefreshToken(userId: string): Promise<string> {
    const token = crypto.randomBytes(32).toString('hex');
    const hash = crypto.createHash('sha256').update(token).digest('hex');
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    const refresh = this.refreshTokenRepo.create({ userId, tokenHash: hash, expiresAt, revoked: false });
    await this.refreshTokenRepo.save(refresh);
    return token;
  }

  async rotateRefreshToken(token: string) {
    const hash = crypto.createHash('sha256').update(token).digest('hex');
    const stored = await this.refreshTokenRepo.findOne({
      where: { tokenHash: hash, revoked: false, expiresAt: MoreThan(new Date()) },
    });
    if (!stored) {
      throw new UnauthorizedException('Invalid refresh token');
    }

    stored.revoked = true;
    await this.refreshTokenRepo.save(stored);

    const user = await this.userRepo.findOne({ where: { id: stored.userId } });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    const payload = {
      sub: user.id,
      tenantId: user.tenantId,
      username: user.username,
      roles: user.roles,
      activeRole: user.activeRole,
    };

    const accessToken = this.jwtService.sign(payload);
    const newRefreshToken = await this.createRefreshToken(user.id);

    return {
      accessToken,
      refreshToken: newRefreshToken,
      user: {
        id: user.id,
        tenantId: user.tenantId,
        schoolName: user.schoolName,
        schoolLogoUrl: user.schoolLogoUrl,
        profilePictureUrl: user.profilePictureUrl,
        username: user.username,
        displayName: user.displayName,
        roles: user.roles,
        activeRole: user.activeRole,
      },
    };
  }

  async revokeRefreshToken(token: string) {
    const hash = crypto.createHash('sha256').update(token).digest('hex');
    await this.refreshTokenRepo.update({ tokenHash: hash }, { revoked: true });
  }

  async revokeAllUserRefreshTokens(userId: string) {
    await this.refreshTokenRepo.update({ userId }, { revoked: true });
  }

  async login(username: string, password: string) {
    const user = await this.validateUser(username, password);
    const payload = {
      sub: user.id,
      tenantId: user.tenantId,
      username: user.username,
      roles: user.roles,
      activeRole: user.activeRole,
    };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = await this.createRefreshToken(user.id);

    await this.auditService.log({
      userId: user.id,
      username: user.username,
      action: 'login',
      resource: 'auth',
      details: `Role: ${user.activeRole}`,
      success: true,
      roles: user.roles,
      tenantId: user.tenantId,
    });

    // Fetch tenant info for school name and logo
    const tenant = await this.tenantsService.findByKey(user.tenantId);

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        tenantId: user.tenantId,
        schoolName: tenant?.schoolName ?? user.schoolName,
        schoolLogoUrl: tenant?.logoUrl ?? user.schoolLogoUrl,
        profilePictureUrl: user.profilePictureUrl,
        username: user.username,
        displayName: user.displayName,
        roles: user.roles,
        activeRole: user.activeRole,
        mustChangePassword: user.mustChangePassword,
      },
    };
  }

  async updateProfile(userId: string, updates: { displayName?: string; profilePictureUrl?: string }) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    if (updates.displayName !== undefined) user.displayName = updates.displayName;
    if (updates.profilePictureUrl !== undefined) user.profilePictureUrl = updates.profilePictureUrl;
    await this.userRepo.save(user);

    return {
      id: user.id,
      tenantId: user.tenantId,
      schoolName: user.schoolName,
      schoolLogoUrl: user.schoolLogoUrl,
      profilePictureUrl: user.profilePictureUrl,
      username: user.username,
      displayName: user.displayName,
      roles: user.roles,
      activeRole: user.activeRole,
    };
  }

  async changePassword(userId: string, currentPassword: string, newPassword: string) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    const valid = await bcrypt.compare(currentPassword, user.passwordHash);
    if (!valid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    if (!newPassword || newPassword.length < 12) {
      throw new UnauthorizedException('New password must be at least 12 characters');
    }
    if (!/[A-Z]/.test(newPassword) || !/[a-z]/.test(newPassword) || !/[0-9]/.test(newPassword)) {
      throw new UnauthorizedException('Password must include uppercase, lowercase, and a number');
    }
    if (newPassword.toLowerCase().includes(user.username.toLowerCase())) {
      throw new UnauthorizedException('Password must not contain your username');
    }

    user.passwordHash = await bcrypt.hash(newPassword, 10);
    user.mustChangePassword = false;
    await this.userRepo.save(user);
    await this.revokeAllUserRefreshTokens(user.id);
    await this.auditService.log({
      userId: user.id,
      username: user.username,
      action: 'password_change',
      resource: 'auth',
      success: true,
      roles: user.roles,
      tenantId: user.tenantId,
    });
    return { message: 'Password changed successfully' };
  }

  async uploadProfilePicture(userId: string, base64Image: string) {
    const MAX_SIZE = 2 * 1024 * 1024; // 2MB
    const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp'];

    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    if (!base64Image.startsWith('data:image/')) {
      throw new UnauthorizedException('Invalid image format');
    }

    const match = base64Image.match(/^data:([^;]+);base64,(.+)$/);
    if (!match) {
      throw new UnauthorizedException('Invalid image format');
    }

    const [, mimeType, base64Data] = match;
    if (!ALLOWED_TYPES.includes(mimeType)) {
      throw new UnauthorizedException('Only JPEG, PNG and WebP images are allowed');
    }

    const size = Buffer.byteLength(base64Data, 'base64');
    if (size > MAX_SIZE) {
      throw new UnauthorizedException('Image exceeds 2MB limit');
    }

    user.profilePictureUrl = base64Image;
    await this.userRepo.save(user);
    await this.auditService.log({
      userId: user.id,
      username: user.username,
      action: 'profile_picture_upload',
      resource: 'auth',
      success: true,
      roles: user.roles,
      tenantId: user.tenantId,
    });
    return {
      id: user.id,
      tenantId: user.tenantId,
      schoolName: user.schoolName,
      schoolLogoUrl: user.schoolLogoUrl,
      profilePictureUrl: user.profilePictureUrl,
      username: user.username,
      displayName: user.displayName,
      roles: user.roles,
      activeRole: user.activeRole,
    };
  }

  async switchRole(userId: string, role: string) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    if (!user.roles.includes(role)) {
      throw new UnauthorizedException('User does not have this role');
    }
    user.activeRole = role;
    await this.userRepo.save(user);

    const payload = {
      sub: user.id,
      tenantId: user.tenantId,
      username: user.username,
      roles: user.roles,
      activeRole: user.activeRole,
    };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = await this.createRefreshToken(user.id);

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        tenantId: user.tenantId,
        schoolName: user.schoolName,
        schoolLogoUrl: user.schoolLogoUrl,
        profilePictureUrl: user.profilePictureUrl,
        username: user.username,
        displayName: user.displayName,
        roles: user.roles,
        activeRole: user.activeRole,
      },
    };
  }

  async createVoterMasterKey(tenantId: string, createdByUserId: string, maxUses = 50): Promise<{ key: string; expiresAt: Date }> {
    await this.masterKeyRepo.update({ tenantId, active: true }, { active: false });

    const key = `MASTER-${crypto.randomBytes(8).toString('hex').toUpperCase()}`;
    const keyHash = await bcrypt.hash(key, 10);
    const expiresAt = new Date();
    expiresAt.setHours(expiresAt.getHours() + 12);

    const masterKey = this.masterKeyRepo.create({
      tenantId,
      keyHash,
      expiresAt,
      maxUses,
      usedCount: 0,
      active: true,
      createdBy: createdByUserId,
    });
    await this.masterKeyRepo.save(masterKey);

    await this.auditService.log({
      userId: createdByUserId,
      action: 'voter_master_key_created',
      resource: 'auth',
      details: `Tenant: ${tenantId}, maxUses: ${maxUses}`,
      success: true,
    });

    return { key, expiresAt };
  }

  async revokeVoterMasterKey(tenantId: string) {
    await this.masterKeyRepo.update({ tenantId, active: true }, { active: false });
  }

  async loginWithTempCredentials(username: string, password: string) {
    if (!username.startsWith('VOTER_') || !password) {
      throw new UnauthorizedException('Invalid temporary credentials');
    }

    const student = await this.studentRepo.findOne({ where: { tempUsername: username } });
    if (!student || !student.tempPasswordHash || !student.tempExpiresAt) {
      throw new UnauthorizedException('Invalid temporary credentials');
    }

    if (student.tempUsed) {
      throw new UnauthorizedException('Temporary credentials have already been used');
    }

    if (new Date() > student.tempExpiresAt) {
      throw new UnauthorizedException('Temporary credentials have expired');
    }

    let loginMethod: 'temp' | 'master' = 'temp';
    const valid = await bcrypt.compare(password, student.tempPasswordHash);
    if (!valid) {
      const masterKey = await this.masterKeyRepo.findOne({
        where: { tenantId: student.tenantId, active: true, expiresAt: MoreThan(new Date()) },
      });
      if (!masterKey) {
        throw new UnauthorizedException('Invalid temporary credentials');
      }
      const masterValid = await bcrypt.compare(password, masterKey.keyHash);
      if (!masterValid) {
        throw new UnauthorizedException('Invalid temporary credentials');
      }
      if (masterKey.usedCount >= masterKey.maxUses) {
        throw new UnauthorizedException('Master key usage limit reached');
      }
      masterKey.usedCount += 1;
      if (masterKey.usedCount >= masterKey.maxUses) {
        masterKey.active = false;
      }
      await this.masterKeyRepo.save(masterKey);
      loginMethod = 'master';
    }

    student.tempUsed = true;
    await this.studentRepo.save(student);

    await this.auditService.log({
      userId: student.id,
      username: student.tempUsername,
      action: 'temp_login',
      resource: 'auth',
      details: loginMethod === 'master' ? 'Voter login via master key' : 'Voter temporary credential used',
      success: true,
    });

    const tempUser = {
      id: student.id,
      tenantId: student.tenantId,
      schoolName: 'SIMS High School',
      schoolLogoUrl: null,
      profilePictureUrl: student.photoUrl,
      username: student.tempUsername,
      displayName: `${student.firstName} ${student.lastName}`,
      roles: ['voter'],
      activeRole: 'voter',
    };

    const payload = {
      sub: student.id,
      tenantId: student.tenantId,
      username: student.tempUsername,
      roles: ['voter'],
      activeRole: 'voter',
      isTempLogin: true,
    };

    const accessToken = this.jwtService.sign(payload, { expiresIn: '2h' });
    const refreshToken = this.jwtService.sign(payload, { expiresIn: '2h' });

    return {
      accessToken,
      refreshToken,
      user: tempUser,
      isTempLogin: true,
    };
  }

  async verifyCode(username: string, code: string) {
    if (!username || !code) {
      throw new BadRequestException('Username and verification code are required');
    }

    const student = await this.studentRepo.findOne({ where: { tempUsername: username } });
    if (!student || !student.verificationCode) {
      throw new UnauthorizedException('Invalid verification request');
    }

    if (student.tempExpiresAt && new Date() > student.tempExpiresAt) {
      throw new UnauthorizedException('Verification window has expired. Please request new credentials.');
    }

    if (student.verificationCode !== code.trim()) {
      await this.auditService.log({
        userId: student.id,
        username: student.tempUsername,
        action: 'verify_code_failed',
        resource: 'auth',
        details: 'Incorrect verification code',
        success: false,
      });
      throw new UnauthorizedException('Invalid verification code');
    }

    // Clear the verification code so it can't be reused
    student.verificationCode = null;
    await this.studentRepo.save(student);

    await this.auditService.log({
      userId: student.id,
      username: student.tempUsername,
      action: 'verify_code_success',
      resource: 'auth',
      details: 'Identity verified successfully',
      success: true,
    });

    const payload = {
      sub: student.id,
      tenantId: student.tenantId,
      username: student.tempUsername,
      roles: ['voter'],
      activeRole: 'voter',
      isTempLogin: false,
    };

    const accessToken = this.jwtService.sign(payload, { expiresIn: '2h' });
    const refreshToken = this.jwtService.sign(payload, { expiresIn: '2h' });

    return {
      accessToken,
      refreshToken,
      user: {
        id: student.id,
        tenantId: student.tenantId,
        schoolName: 'SIMS High School',
        schoolLogoUrl: null,
        profilePictureUrl: student.photoUrl,
        username: student.tempUsername,
        displayName: `${student.firstName} ${student.lastName}`,
        roles: ['voter'],
        activeRole: 'voter',
      },
    };
  }

  async createUser(data: {
    username: string;
    password?: string;
    displayName: string;
    email?: string;
    roles: string[];
    tenantId: string;
    activeRole?: string;
    creatorRoles?: string[];
  }) {
    const existing = await this.userRepo.findOne({ where: { username: data.username } });
    if (existing) {
      throw new BadRequestException('Username already exists');
    }

    // Non-system-admin creators cannot assign the system_admin role
    const creatorRoles = data.creatorRoles || [];
    const isSystemAdmin = creatorRoles.includes('system_admin');
    if (!isSystemAdmin && data.roles.includes('system_admin')) {
      throw new BadRequestException('Only a System Administrator can assign the system_admin role');
    }

    // Generate a unique random password if none provided
    let generatedPassword: string | undefined;
    let password = data.password;
    if (!password) {
      const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
      const lower = 'abcdefghijkmnpqrstuvwxyz';
      const digits = '23456789';
      const all = upper + lower + digits;
      const bytes = crypto.randomBytes(16);
      // Guarantee at least one of each category
      let pwd = '';
      pwd += upper[bytes[0] % upper.length];
      pwd += lower[bytes[1] % lower.length];
      pwd += digits[bytes[2] % digits.length];
      for (let i = 3; i < 12; i++) {
        pwd += all[bytes[i] % all.length];
      }
      // Shuffle the characters
      pwd = pwd.split('').sort(() => Math.random() - 0.5).join('');
      generatedPassword = pwd;
      password = pwd;
    }

    if (password.length < 6) {
      throw new BadRequestException('Password must be at least 6 characters');
    }

    // Validate tenant exists
    const tenant = await this.tenantsService.findByKey(data.tenantId);
    if (!tenant) {
      throw new BadRequestException(`Tenant "${data.tenantId}" does not exist`);
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const mustChangePassword = !data.password;
    const user = this.userRepo.create({
      username: data.username,
      passwordHash,
      displayName: data.displayName,
      tenantId: data.tenantId,
      schoolName: null,
      schoolLogoUrl: null,
      roles: data.roles,
      activeRole: data.activeRole || data.roles[0] || 'staff',
      mustChangePassword,
    });
    await this.userRepo.save(user);

    // If user has 'student' role, also add 'parent' role and create a linked Student record
    if (data.roles.includes('student') && !data.roles.includes('parent')) {
      data.roles.push('parent');
      user.roles = data.roles;
      await this.userRepo.save(user);
    }

    // If user has 'student' role, create a linked Student record
    if (data.roles.includes('student')) {
      const nameParts = data.displayName.trim().split(/\s+/);
      const firstName = nameParts[0] || data.username;
      const lastName = nameParts.slice(1).join(' ') || 'Student';
      const admissionNumber = `USR-${data.username.toUpperCase()}`;
      const student = this.studentRepo.create({
        userId: user.id,
        admissionNumber,
        firstName,
        lastName,
        dateOfBirth: '2000-01-01',
        gender: 'male',
        classSectionId: 'unassigned',
        houseId: null,
        guardianName: 'N/A',
        guardianPhone: '0000000000',
        guardianAddress: 'N/A',
        admissionDate: new Date().toISOString().slice(0, 10),
        status: 'active',
        tenantId: data.tenantId,
      });
      await this.studentRepo.save(student);
    }

    await this.auditService.log({
      userId: user.id,
      username: user.username,
      action: 'user_created',
      resource: 'users',
      details: `Roles: ${data.roles.join(', ')}${mustChangePassword ? ' (default password)' : ''}`,
      success: true,
      roles: data.roles,
      tenantId: data.tenantId,
    });

    return {
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      roles: user.roles,
      activeRole: user.activeRole,
      tenantId: user.tenantId,
      mustChangePassword,
      defaultPassword: generatedPassword,
    };
  }

  async adminResetPassword(userId: string, newPassword?: string) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    let generatedPassword: string | undefined;
    let password = newPassword;
    if (!password) {
      const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
      const lower = 'abcdefghijkmnpqrstuvwxyz';
      const digits = '23456789';
      const all = upper + lower + digits;
      const bytes = crypto.randomBytes(16);
      let pwd = '';
      pwd += upper[bytes[0] % upper.length];
      pwd += lower[bytes[1] % lower.length];
      pwd += digits[bytes[2] % digits.length];
      for (let i = 3; i < 12; i++) {
        pwd += all[bytes[i] % all.length];
      }
      pwd = pwd.split('').sort(() => Math.random() - 0.5).join('');
      generatedPassword = pwd;
      password = pwd;
    }

    if (password.length < 6) {
      throw new BadRequestException('Password must be at least 6 characters');
    }

    user.passwordHash = await bcrypt.hash(password, 10);
    user.failedLoginAttempts = 0;
    user.lockedUntil = null;
    user.mustChangePassword = true;
    await this.userRepo.save(user);
    await this.revokeAllUserRefreshTokens(user.id);

    await this.auditService.log({
      userId: user.id,
      username: user.username,
      action: 'admin_password_reset',
      resource: 'users',
      success: true,
      roles: user.roles,
      tenantId: user.tenantId,
    });

    return { message: 'Password reset successfully', generatedPassword };
  }

  async listUsers(tenantId?: string) {
    const where = tenantId ? { tenantId } : {};
    const users = await this.userRepo.find({ where });
    return users.map((u) => ({
      id: u.id,
      username: u.username,
      displayName: u.displayName,
      roles: u.roles,
      activeRole: u.activeRole,
      tenantId: u.tenantId,
      failedLoginAttempts: u.failedLoginAttempts,
      lockedUntil: u.lockedUntil,
      createdAt: u.createdAt,
    }));
  }

  async unlockAccount(username: string) {
    const user = await this.userRepo.findOne({ where: { username } });
    if (!user) {
      throw new NotFoundException('User not found');
    }
    user.failedLoginAttempts = 0;
    user.lockedUntil = null;
    await this.userRepo.save(user);
    return { message: `Account ${username} unlocked`, username: user.username, roles: user.roles, tenantId: user.tenantId };
  }

  async getHeadmasterByTenant(tenantId: string) {
    const users = await this.userRepo.find({ where: { tenantId } });
    const headmaster = users.find((u) => u.roles.includes('headmaster'));
    if (!headmaster) {
      return null;
    }
    return {
      id: headmaster.id,
      username: headmaster.username,
      displayName: headmaster.displayName,
      roles: headmaster.roles,
      tenantId: headmaster.tenantId,
    };
  }

  async updateUser(userId: string, data: { displayName?: string; username?: string; roles?: string[]; creatorRoles?: string[] }) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }
    if (data.username !== undefined && data.username !== user.username) {
      const existing = await this.userRepo.findOne({ where: { username: data.username } });
      if (existing) {
        throw new BadRequestException('Username already taken');
      }
      user.username = data.username;
    }
    if (data.displayName !== undefined) {
      user.displayName = data.displayName;
    }
    if (data.roles !== undefined) {
      // Non-system-admin creators cannot assign the system_admin role
      const creatorRoles = data.creatorRoles || [];
      const isSystemAdmin = creatorRoles.includes('system_admin');
      if (!isSystemAdmin && data.roles.includes('system_admin')) {
        throw new BadRequestException('Only a System Administrator can assign the system_admin role');
      }
      user.roles = data.roles;
      user.activeRole = data.roles[0] || user.activeRole;
    }
    await this.userRepo.save(user);

    await this.auditService.log({
      userId: user.id,
      username: user.username,
      action: 'user_updated',
      resource: 'users',
      details: `Updated by admin`,
      success: true,
      roles: user.roles,
      tenantId: user.tenantId,
    });

    return {
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      roles: user.roles,
      activeRole: user.activeRole,
      tenantId: user.tenantId,
    };
  }

  async setupParentAccount(currentUserId: string, data: { username: string; password: string; displayName?: string }) {
    const currentUser = await this.userRepo.findOne({ where: { id: currentUserId } });
    if (!currentUser) {
      throw new NotFoundException('User not found');
    }
    if (!currentUser.roles.includes('parent')) {
      throw new BadRequestException('Your account does not have the parent role. Only shared student/parent accounts can set up a separate parent login.');
    }

    // Check username is not taken
    const existing = await this.userRepo.findOne({ where: { username: data.username } });
    if (existing) {
      throw new BadRequestException('Username already taken. Please choose a different username.');
    }

    // Find the student linked to this user
    let student = await this.studentRepo.findOne({ where: { userId: currentUserId, tenantId: currentUser.tenantId } });
    if (!student) {
      student = await this.studentRepo.findOne({ where: { id: currentUserId, tenantId: currentUser.tenantId } });
    }
    if (!student) {
      throw new NotFoundException('Student record not found for this account.');
    }

    // If student already has a separate parent account, reject
    if (student.parentUserId) {
      throw new BadRequestException('A separate parent account has already been set up for this student.');
    }

    // Create the new parent User
    const passwordHash = await bcrypt.hash(data.password, 10);
    const parentUser = this.userRepo.create({
      username: data.username,
      passwordHash,
      displayName: data.displayName || `Parent of ${student.firstName} ${student.lastName}`,
      tenantId: currentUser.tenantId,
      schoolName: null,
      schoolLogoUrl: null,
      roles: ['parent'],
      activeRole: 'parent',
      mustChangePassword: false,
    });
    await this.userRepo.save(parentUser);

    // Link parent to student
    student.parentUserId = parentUser.id;
    await this.studentRepo.save(student);

    // Create trial subscription for the new parent
    await this.subscriptionService.createTrial(
      parentUser.id,
      parentUser.tenantId,
      `${student.firstName} ${student.lastName}`,
      student.admissionNumber,
    );

    // Remove 'parent' role from the student's original user account
    currentUser.roles = currentUser.roles.filter((r) => r !== 'parent');
    if (currentUser.activeRole === 'parent') {
      currentUser.activeRole = currentUser.roles[0] || 'student';
    }
    await this.userRepo.save(currentUser);

    await this.auditService.log({
      userId: parentUser.id,
      username: parentUser.username,
      action: 'parent_account_setup',
      resource: 'users',
      details: `Parent account created for student ${student.admissionNumber}`,
      success: true,
      roles: parentUser.roles,
      tenantId: parentUser.tenantId,
    });

    return {
      id: parentUser.id,
      username: parentUser.username,
      displayName: parentUser.displayName,
      roles: parentUser.roles,
      activeRole: parentUser.activeRole,
      tenantId: parentUser.tenantId,
      message: 'Parent account created successfully. You can now log in with your new username and password.',
    };
  }
}
