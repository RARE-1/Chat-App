import { Injectable } from '@nestjs/common';
import { ConversationType, ParticipantRole } from '@prisma/client';
import { DatabaseService } from '../../core/database/database.service';

@Injectable()
export class ConversationsRepository {
  constructor(private readonly database: DatabaseService) {}

  createConversation(data: {
    type: ConversationType;
    title?: string;
    createdBy: string;
    participantIds: string[];
  }) {
    return this.database.conversation.create({
      data: {
        type: data.type,
        title: data.title,
        createdBy: data.createdBy,
        participants: {
          create: [...new Set([data.createdBy, ...data.participantIds])].map(
            (userId) => ({
              userId,
              role:
                userId === data.createdBy
                  ? ParticipantRole.admin
                  : ParticipantRole.member,
            }),
          ),
        },
      },
      include: {
        participants: true,
      },
    });
  }

  listForUser(userId: string) {
    return this.database.conversation.findMany({
      where: {
        participants: {
          some: {
            userId,
            leftAt: null,
          },
        },
      },
      include: {
        participants: true,
        lastMessage: true,
      },
      orderBy: {
        updatedAt: 'desc',
      },
    });
  }

  findById(id: string) {
    return this.database.conversation.findUnique({
      where: { id },
      include: {
        participants: true,
        lastMessage: true,
      },
    });
  }

  addParticipant(conversationId: string, userId: string) {
    return this.database.conversationParticipant.create({
      data: {
        conversationId,
        userId,
      },
    });
  }

  removeParticipant(conversationId: string, userId: string) {
    return this.database.conversationParticipant.updateMany({
      where: {
        conversationId,
        userId,
        leftAt: null,
      },
      data: {
        leftAt: new Date(),
      },
    });
  }
}
