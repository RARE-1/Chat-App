import { Module } from '@nestjs/common';
import { ChatGateway } from './chat.gateway';
import { PresenceService } from './presence.service';
import { RealtimeService } from './realtime.service';

@Module({
  providers: [ChatGateway, PresenceService, RealtimeService],
  exports: [RealtimeService, PresenceService],
})
export class RealtimeModule {}
