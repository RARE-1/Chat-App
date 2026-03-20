import { IsUUID } from 'class-validator';

export class ManageParticipantDto {
  @IsUUID('4')
  userId!: string;
}
