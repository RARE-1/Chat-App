import { Injectable } from '@nestjs/common';

@Injectable()
export class MediaService {
  createUploadTarget(file: {
    fileName: string;
    mimeType: string;
    size: number;
  }) {
    return {
      storageProvider: 's3-compatible-placeholder',
      method: 'PUT',
      uploadUrl: `https://storage.example.com/uploads/${encodeURIComponent(file.fileName)}`,
      headers: {
        'content-type': file.mimeType,
      },
      maxAllowedSize: 25 * 1024 * 1024,
    };
  }
}
