import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/core/di/core_providers.dart';
import 'package:web_learner/features/announcement/application/announcement_state.dart';
import 'package:web_learner/features/announcement/di/announcement_providers.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';

final announcementInitialStateProvider = Provider<AnnouncementState>((ref) {
  return const AnnouncementState();
});

final announcementControllerProvider =
    NotifierProvider<AnnouncementController, AnnouncementState>(
      AnnouncementController.new,
    );

/// 管理登录页公告的缓存态与后台刷新流程。
class AnnouncementController extends Notifier<AnnouncementState> {
  static const _refreshInterval = Duration(minutes: 10);

  bool _hasScheduledRefresh = false;

  @override
  AnnouncementState build() {
    final initialState = ref.watch(announcementInitialStateProvider);
    if (!_hasScheduledRefresh) {
      _hasScheduledRefresh = true;
      unawaited(Future<void>.microtask(refreshIfNeeded));
    }
    return initialState;
  }

  /// 在满足刷新条件时拉取最新公告。
  Future<void> refreshIfNeeded() async {
    final lastRefreshAt = state.lastSuccessfulRefreshAt;
    if (lastRefreshAt != null &&
        DateTime.now().difference(lastRefreshAt) < _refreshInterval) {
      return;
    }

    await refresh();
  }

  /// 刷新最新公告，并按结果更新缓存。
  Future<void> refresh() async {
    if (state.isRefreshing) {
      return;
    }

    state = state.copyWith(isRefreshing: true);

    try {
      final announcements = await ref
          .read(announcementRepositoryProvider)
          .fetchLoginAnnouncements();
      final refreshedAt = DateTime.now();
      final cacheDataSource = ref.read(
        announcementLocalCacheDataSourceProvider,
      );

      if (announcements.isEmpty) {
        await cacheDataSource.clearAnnouncements(refreshedAt: refreshedAt);
        state = AnnouncementState(
          lastSuccessfulRefreshAt: refreshedAt,
        );
        return;
      }

      await cacheDataSource.saveAnnouncements(
        announcements,
        refreshedAt: refreshedAt,
      );
      state = AnnouncementState(
        announcements: announcements,
        lastSuccessfulRefreshAt: refreshedAt,
      );
    } on Exception catch (error) {
      ref
          .read(appLoggerProvider)
          .warning(
            'announcement refresh failed: $error',
          );
      state = state.copyWith(isRefreshing: false);
    }
  }
}

/// 提供登录页当前可展示的公告列表。
final loginAnnouncementsProvider = Provider<List<Announcement>>((ref) {
  return ref.watch(announcementControllerProvider).announcements;
});

/// 暴露第一条公告，供登录页主公告卡片使用。
final primaryLoginAnnouncementProvider = Provider<Announcement?>((ref) {
  final announcements = ref.watch(loginAnnouncementsProvider);
  if (announcements.isEmpty) {
    return null;
  }

  return announcements.first;
});
