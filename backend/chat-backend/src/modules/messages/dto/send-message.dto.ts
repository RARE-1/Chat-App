import { IsIn, IsOptional, IsString, IsUUID, MinLength } from 'class-validator';

export class SendMessageDto {
  @IsUUID('4')
  conversationId!: string;

  @IsIn(['text', 'image', 'video', 'file', 'system'])
  type!: 'text' | 'image' | 'video' | 'file' | 'system';

  @IsString()
  @MinLength(1)
  content!: string;

  @IsOptional()
  @IsUUID('4')
  replyToMessageId?: string;
}
