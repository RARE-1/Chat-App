import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { PresenceService } from './presence.service';
import { RealtimeService } from './realtime.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server!: Server;

  constructor(
    private readonly presenceService: PresenceService,
    private readonly realtimeService: RealtimeService,
  ) {}

  afterInit() {
    this.realtimeService.setServer(this.server);
  }

  handleConnection(client: Socket) {
    const userId = this.extractUserId(client);

    if (userId) {
      this.presenceService.setOnline(userId, client.id);
    }
  }

  handleDisconnect(client: Socket) {
    const userId = this.extractUserId(client);

    if (userId) {
      this.presenceService.setOffline(userId, client.id);
    }
  }

  @SubscribeMessage('join_conversation')
  handleJoinConversation(
    @ConnectedSocket() client: Socket,
    @MessageBody() body: { conversationId: string },
  ) {
    void client.join(`conversation:${body.conversationId}`);
    return { joined: body.conversationId };
  }

  @SubscribeMessage('leave_conversation')
  handleLeaveConversation(
    @ConnectedSocket() client: Socket,
    @MessageBody() body: { conversationId: string },
  ) {
    void client.leave(`conversation:${body.conversationId}`);
    return { left: body.conversationId };
  }

  @SubscribeMessage('typing_start')
  handleTypingStart(
    @MessageBody() body: { conversationId: string; userId: string },
  ) {
    this.realtimeService.emitTyping(body.conversationId, body);
    return { ok: true };
  }

  private extractUserId(client: Socket) {
    const authUserId =
      typeof client.handshake.auth.userId === 'string'
        ? client.handshake.auth.userId
        : undefined;
    const queryUserId =
      typeof client.handshake.query.userId === 'string'
        ? client.handshake.query.userId
        : undefined;

    return authUserId ?? queryUserId;
  }
}
