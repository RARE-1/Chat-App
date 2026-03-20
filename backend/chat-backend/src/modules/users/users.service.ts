import { Injectable } from '@nestjs/common';
import { SearchUsersDto } from './dto/search-users.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UsersRepository } from './users.repository';

@Injectable()
export class UsersService {
  constructor(private readonly usersRepository: UsersRepository) {}

  getMe(userId: string) {
    return this.usersRepository.findById(userId);
  }

  getById(userId: string) {
    return this.usersRepository.findById(userId);
  }

  search(dto: SearchUsersDto) {
    return this.usersRepository.search(dto.q);
  }

  updateMe(userId: string, dto: UpdateProfileDto) {
    return this.usersRepository.update(userId, dto);
  }
}
