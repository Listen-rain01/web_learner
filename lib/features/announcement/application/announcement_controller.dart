import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/features/announcement/di/announcement_providers.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';

final FutureProvider<List<Announcement>> loginAnnouncementsProvider =
    FutureProvider.autoDispose<List<Announcement>>((ref) async {
  return ref.watch(announcementRepositoryProvider).fetchLoginAnnouncements();
});

final Provider<Announcement?> primaryLoginAnnouncementProvider =
    Provider.autoDispose<Announcement?>((ref) {
  final announcements = ref.watch(loginAnnouncementsProvider).asData?.value;
  if (announcements == null || announcements.isEmpty) {
    return null;
  }

  return announcements.first;
});
