import { IsString, IsOptional } from 'class-validator';

export class CreateAnnouncementDto {
  @IsString() title: string;
  @IsString() body: string;
  @IsString() date: string;
  @IsString() author: string;
}

export class CreateMeetingDto {
  @IsString() date: string;
  @IsString() time: string;
  @IsString() topic: string;
  @IsOptional() @IsString() location?: string;
}

export class UpdateRSVPDto {
  @IsString() rsvp: string;
}
