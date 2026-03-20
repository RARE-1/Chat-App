import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { DatabaseService } from '../../core/database/database.service';

@Injectable()
export class UsersRepository {
  constructor(private readonly database: DatabaseService) {}

  create(data: {
    email: string;
    passwordHash: string;
    displayName: string;
    avatarUrl?: string;
  }) {
    return this.database.user.create({
      data,
    });
  }

  findByEmail(email: string) {
    return this.database.user.findUnique({
      where: { email },
    });
  }

  findById(id: string) {
    return this.database.user.findUnique({
      where: { id },
      select: {
        id: true,
        email: true,
        displayName: true,
        avatarUrl: true,
        isActive: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }

  search(query?: string) {
    const where: Prisma.UserWhereInput | undefined = query
      ? {
          OR: [
            { email: { contains: query, mode: 'insensitive' } },
            { displayName: { contains: query, mode: 'insensitive' } },
          ],
        }
      : undefined;

    return this.database.user.findMany({
      where,
      take: 20,
      select: {
        id: true,
        email: true,
        displayName: true,
        avatarUrl: true,
        isActive: true,
      },
    });
  }

  update(id: string, data: { displayName?: string; avatarUrl?: string }) {
    return this.database.user.update({
      where: { id },
      data,
      select: {
        id: true,
        email: true,
        displayName: true,
        avatarUrl: true,
        isActive: true,
        createdAt: true,
        updatedAt: true,
      },
    });
  }
}
