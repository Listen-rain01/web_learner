import 'package:web_learner/features/announcement/domain/entities/announcement.dart';

/// 描述登录页公告的当前状态。
class AnnouncementState {
  const AnnouncementState({
    this.announcements = const [],
    this.lastSuccessfulRefreshAt,
    this.isRefreshing = false,
  });

  final List<Announcement> announcements;
  final DateTime? lastSuccessfulRefreshAt;
  final bool isRefreshing;

  /// 返回当前是否存在可展示的公告。
  bool get hasAnnouncements => announcements.isNotEmpty;

  /// 创建新状态，同时保留未显式覆盖的字段。
  AnnouncementState copyWith({
    List<Announcement>? announcements,
    DateTime? lastSuccessfulRefreshAt,
    bool? isRefreshing,
  }) {
    return AnnouncementState(
      announcements: announcements ?? this.announcements,
      lastSuccessfulRefreshAt:
          lastSuccessfulRefreshAt ?? this.lastSuccessfulRefreshAt,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
