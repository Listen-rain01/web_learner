import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/features/announcement/di/announcement_providers.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';

/// 为登录页加载完整的公告列表。
final FutureProvider<List<Announcement>> loginAnnouncementsProvider =
    FutureProvider.autoDispose<List<Announcement>>((ref) async {
      return ref
          .watch(announcementRepositoryProvider)
          .fetchLoginAnnouncements();
    });

/// 暴露第一条公告，供登录页主公告卡片使用。
final Provider<Announcement?> primaryLoginAnnouncementProvider =
    Provider.autoDispose<Announcement?>((ref) {
      final announcements = ref.watch(loginAnnouncementsProvider).asData?.value;
      if (announcements == null || announcements.isEmpty) {
        return null;
      }

      return announcements.first;
    });
