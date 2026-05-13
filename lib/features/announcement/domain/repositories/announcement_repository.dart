import 'package:web_learner/features/announcement/domain/entities/announcement.dart';

// ignore: one_member_abstracts, reason: Feature repository abstractions are required by project architecture.
abstract interface class AnnouncementRepository {
  Future<List<Announcement>> fetchLoginAnnouncements();
}
