import { Injectable } from '@nestjs/common';

@Injectable()
export class PresenceService {
  private readonly onlineUsers = new Map<string, Set<string>>();

  setOnline(userId: string, socketId: string) {
    const sockets = this.onlineUsers.get(userId) ?? new Set<string>();
    sockets.add(socketId);
    this.onlineUsers.set(userId, sockets);
  }

  setOffline(userId: string, socketId: string) {
    const sockets = this.onlineUsers.get(userId);

    if (!sockets) {
      return;
    }

    sockets.delete(socketId);

    if (sockets.size === 0) {
      this.onlineUsers.delete(userId);
    }
  }

  isOnline(userId: string) {
    return this.onlineUsers.has(userId);
  }
}
