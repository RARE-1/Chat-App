import { Injectable } from '@nestjs/common';
import { MessageStatusState, MessageType } from '@prisma/client';
import { DatabaseService } from '../../core/database/database.service';

@Injectable()
export class MessagesRepository {
  constructor(private readonly database: DatabaseService) {}

  createMessage(data: {
    conversationId: string;
    senderId: string;
    type: MessageType;
    content: string;
    replyToMessageId?: string;
  }) {
    return this.database.message.create({
      data: {
        conversationId: data.conversationId,
        senderId: data.senderId,
        type: data.type,
        content: data.content,
        replyToMessageId: data.replyToMessageId,
      },
      include: {
        sender: true,
      },
    });
  }

  listConversationMessages(conversationId: string, limit: number) {
    return this.database.message.findMany({
      where: {
        conversationId,
        deletedAt: null,
      },
      include: {
        sender: true,
        statuses: true,
        media: true,
      },
      take: limit,
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  markStatus(messageId: string, userId: string, status: MessageStatusState) {
    return this.database.messageStatus.upsert({
      where: {
        messageId_userId: {
          messageId,
          userId,
        },
      },
      update: {
        status,
      },
      create: {
        messageId,
        userId,
        status,
      },
    });
  }

  softDelete(messageId: string) {
    return this.database.message.update({
      where: { id: messageId },
      data: {
        deletedAt: new Date(),
      },
    });
  }

  updateConversationLastMessage(conversationId: string, messageId: string) {
    return this.database.conversation.update({
      where: { id: conversationId },
      data: {
        lastMessageId: messageId,
      },
    });
  }
}
