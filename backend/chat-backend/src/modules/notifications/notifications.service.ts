import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  queueNewMessageNotification(payload: unknown) {
    this.logger.log(`Queued notification payload: ${JSON.stringify(payload)}`);
    return { queued: true };
  }
}
