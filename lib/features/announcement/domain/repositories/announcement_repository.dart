import '../entities/announcement_entity.dart';

abstract class AnnouncementRepository {
  Stream<AnnouncementEntity?> watchLatestAnnouncement();
}
