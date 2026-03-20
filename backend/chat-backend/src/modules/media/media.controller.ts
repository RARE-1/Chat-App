import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../core/guards/jwt-auth.guard';
import { MediaService } from './media.service';

@UseGuards(JwtAuthGuard)
@Controller('media')
export class MediaController {
  constructor(private readonly mediaService: MediaService) {}

  @Post('presign')
  createUploadTarget(
    @Body() body: { fileName: string; mimeType: string; size: number },
  ) {
    return this.mediaService.createUploadTarget(body);
  }
}
