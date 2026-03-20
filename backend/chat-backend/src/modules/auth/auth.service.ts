import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { StringValue } from 'ms';
import { AUTH_CONSTANTS } from '../../core/constants/auth.constants';
import { AuthenticatedUser } from '../../core/decorators/current-user.decorator';
import { UsersRepository } from '../users/users.repository';
import { AuthRepository } from './auth.repository';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';
import { JwtPayload } from './interfaces/jwt-payload.interface';

@Injectable()
export class AuthService {
  constructor(
    private readonly authRepository: AuthRepository,
    private readonly usersRepository: UsersRepository,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async register(dto: RegisterDto) {
    const existingUser = await this.usersRepository.findByEmail(dto.email);

    if (existingUser) {
      throw new ConflictException('A user with this email already exists.');
    }

    const passwordHash = await bcrypt.hash(
      dto.password,
      AUTH_CONSTANTS.BCRYPT_ROUNDS,
    );

    const user = await this.usersRepository.create({
      email: dto.email,
      passwordHash,
      displayName: dto.displayName,
      avatarUrl: dto.avatarUrl,
    });

    return this.buildAuthResponse(user);
  }

  async login(dto: LoginDto) {
    const user = await this.usersRepository.findByEmail(dto.email);

    if (!user) {
      throw new UnauthorizedException('Invalid credentials.');
    }

    const isValidPassword = await bcrypt.compare(
      dto.password,
      user.passwordHash,
    );

    if (!isValidPassword) {
      throw new UnauthorizedException('Invalid credentials.');
    }

    return this.buildAuthResponse(user);
  }

  async refresh(dto: RefreshTokenDto) {
    const payload = await this.jwtService.verifyAsync<JwtPayload>(
      dto.refreshToken,
      {
        secret: this.configService.getOrThrow<string>(
          'auth.refreshTokenSecret',
        ),
      },
    );
    const session = await this.authRepository.findActiveRefreshToken(
      payload.sub,
    );

    if (!session) {
      throw new UnauthorizedException('Refresh token is invalid or expired.');
    }

    return this.buildAuthResponse(session.user);
  }

  async logout(refreshToken: string) {
    const payload = await this.jwtService.verifyAsync<JwtPayload>(
      refreshToken,
      {
        secret: this.configService.getOrThrow<string>(
          'auth.refreshTokenSecret',
        ),
      },
    );
    await this.authRepository.revokeActiveTokens(payload.sub);

    return { success: true };
  }

  async me(userId: string) {
    return this.usersRepository.findById(userId);
  }

  private async buildAuthResponse(user: {
    id: string;
    email: string;
    displayName: string;
    passwordHash: string;
  }) {
    const accessPayload: JwtPayload = {
      sub: user.id,
      email: user.email,
      displayName: user.displayName,
      type: 'access',
    };

    const refreshPayload: JwtPayload = {
      ...accessPayload,
      type: 'refresh',
    };

    const accessToken = await this.jwtService.signAsync(accessPayload, {
      secret: this.configService.getOrThrow<string>('auth.accessTokenSecret'),
      expiresIn: this.configService.getOrThrow<string>(
        'auth.accessTokenTtl',
      ) as StringValue,
    });

    const refreshToken = await this.jwtService.signAsync(refreshPayload, {
      secret: this.configService.getOrThrow<string>('auth.refreshTokenSecret'),
      expiresIn: this.configService.getOrThrow<string>(
        'auth.refreshTokenTtl',
      ) as StringValue,
    });

    const refreshTokenHash = await bcrypt.hash(refreshToken, 1);

    await this.authRepository.createRefreshToken({
      userId: user.id,
      tokenHash: refreshTokenHash,
      expiresAt: new Date(Date.now() + 1000 * 60 * 60 * 24 * 30),
    });

    const safeUser: AuthenticatedUser = {
      id: user.id,
      email: user.email,
      displayName: user.displayName,
    };

    return {
      user: safeUser,
      tokens: {
        accessToken,
        refreshToken,
      },
    };
  }
}
