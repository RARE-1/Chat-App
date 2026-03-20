import { Injectable } from '@nestjs/common';
import { Server } from 'socket.io';

@Injectable()
export class RealtimeService {
  private server?: Server;

  setServer(server: Server) {
    this.server = server;
  }

  emitNewMessage(conversationId: string, payload: unknown) {
    this.server
      ?.to(`conversation:${conversationId}`)
      .emit('new_message', payload);
  }

  emitTyping(conversationId: string, payload: unknown) {
    this.server
      ?.to(`conversation:${conversationId}`)
      .emit('typing_start', payload);
  }
}
