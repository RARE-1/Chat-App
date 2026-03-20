import { Injectable } from '@nestjs/common';
import { MessageStatusState } from '@prisma/client';
import { RealtimeService } from '../realtime/realtime.service';
import { MessagesRepository } from './messages.repository';
import { SendMessageDto } from './dto/send-message.dto';

@Injectable()
export class MessagesService {
  constructor(
    private readonly messagesRepository: MessagesRepository,
    private readonly realtimeService: RealtimeService,
  ) {}

  async send(userId: string, dto: SendMessageDto) {
    const message = await this.messagesRepository.createMessage({
      conversationId: dto.conversationId,
      senderId: userId,
      type: dto.type,
      content: dto.content,
      replyToMessageId: dto.replyToMessageId,
    });

    await this.messagesRepository.updateConversationLastMessage(
      dto.conversationId,
      message.id,
    );

    this.realtimeService.emitNewMessage(dto.conversationId, message);

    return message;
  }

  list(conversationId: string, limit = 20) {
    return this.messagesRepository.listConversationMessages(
      conversationId,
      limit,
    );
  }

  markRead(messageId: string, userId: string) {
    return this.messagesRepository.markStatus(
      messageId,
      userId,
      MessageStatusState.read,
    );
  }

  markDelivered(messageId: string, userId: string) {
    return this.messagesRepository.markStatus(
      messageId,
      userId,
      MessageStatusState.delivered,
    );
  }

  delete(messageId: string) {
    return this.messagesRepository.softDelete(messageId);
  }
}
