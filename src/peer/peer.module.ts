import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ForumQuestionEntity } from './forum-question.entity';
import { ForumAnswerEntity } from './forum-answer.entity';
import { StudyGroupEntity } from './study-group.entity';
import { StudyGroupMessageEntity } from './study-group-message.entity';
import { PeerService } from './peer.service';
import { PeerController } from './peer.controller';

@Module({
  imports: [TypeOrmModule.forFeature([ForumQuestionEntity, ForumAnswerEntity, StudyGroupEntity, StudyGroupMessageEntity])],
  providers: [PeerService],
  controllers: [PeerController],
  exports: [PeerService],
})
export class PeerModule {}
