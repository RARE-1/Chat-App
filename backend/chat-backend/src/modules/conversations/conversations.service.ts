import { Injectable } from '@nestjs/common';
import { CreateConversationDto } from './dto/create-conversation.dto';
import { ConversationsRepository } from './conversations.repository';

@Injectable()
export class ConversationsService {
  constructor(
    private readonly conversationsRepository: ConversationsRepository,
  ) {}

  create(userId: string, dto: CreateConversationDto) {
    return this.conversationsRepository.createConversation({
      type: dto.type,
      title: dto.title,
      createdBy: userId,
      participantIds: dto.participantIds,
    });
  }

  list(userId: string) {
    return this.conversationsRepository.listForUser(userId);
  }

  getById(conversationId: string) {
    return this.conversationsRepository.findById(conversationId);
  }

  addParticipant(conversationId: string, userId: string) {
    return this.conversationsRepository.addParticipant(conversationId, userId);
  }

  removeParticipant(conversationId: string, userId: string) {
    return this.conversationsRepository.removeParticipant(
      conversationId,
      userId,
    );
  }
}
