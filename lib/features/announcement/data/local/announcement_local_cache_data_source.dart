import 'dart:convert';

import 'package:web_learner/core/storage/local_kv_store.dart';
import 'package:web_learner/features/announcement/application/announcement_state.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';

/// 负责读写登录页公告的本地缓存。
class AnnouncementLocalCacheDataSource {
  const AnnouncementLocalCacheDataSource({
    required LocalKvStore localKvStore,
  }) : _localKvStore = localKvStore;

  static const _announcementsCacheKey = 'announcement.login.cache';
  static const _lastRefreshAtKey = 'announcement.login.last_refresh_at';

  final LocalKvStore _localKvStore;

  /// 加载登录页公告缓存与最近成功刷新时间。
  Future<AnnouncementState> loadState() async {
    final cachedValue = await _localKvStore.read(_announcementsCacheKey);
    final refreshValue = await _localKvStore.read(_lastRefreshAtKey);
    final now = DateTime.now();

    return AnnouncementState(
      announcements: _decodeAnnouncements(cachedValue)
          .where((announcement) {
            return announcement.isVisibleAt(now);
          })
          .toList(growable: false),
      lastSuccessfulRefreshAt: _parseDateTime(refreshValue),
    );
  }

  /// 用最新公告覆盖本地缓存，并记录成功刷新时间。
  Future<void> saveAnnouncements(
    List<Announcement> announcements, {
    required DateTime refreshedAt,
  }) async {
    final encoded = jsonEncode(
      announcements.map(_encodeAnnouncement).toList(growable: false),
    );

    await _localKvStore.write(
      key: _announcementsCacheKey,
      value: encoded,
    );
    await _localKvStore.write(
      key: _lastRefreshAtKey,
      value: refreshedAt.toIso8601String(),
    );
  }

  /// 清空本地公告缓存，并记录最近一次成功刷新时间。
  Future<void> clearAnnouncements({
    required DateTime refreshedAt,
  }) async {
    await _localKvStore.delete(_announcementsCacheKey);
    await _localKvStore.write(
      key: _lastRefreshAtKey,
      value: refreshedAt.toIso8601String(),
    );
  }

  List<Announcement> _decodeAnnouncements(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is List) {
        return decoded
            .whereType<Map<dynamic, dynamic>>()
            .map((item) {
              return _decodeAnnouncement(Map<String, dynamic>.from(item));
            })
            .toList(growable: false);
      }
    } on FormatException {
      return const [];
    }

    return const [];
  }

  Map<String, dynamic> _encodeAnnouncement(Announcement announcement) {
    return {
      'id': announcement.id,
      'title': announcement.title,
      'content': announcement.content,
      'isPinned': announcement.isPinned,
      'createdAt': announcement.createdAt.toIso8601String(),
      'updatedAt': announcement.updatedAt.toIso8601String(),
      'startsAt': announcement.startsAt?.toIso8601String(),
      'endsAt': announcement.endsAt?.toIso8601String(),
    };
  }

  Announcement _decodeAnnouncement(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      isPinned: map['isPinned'] as bool? ?? false,
      createdAt: _parseDateTime(map['createdAt']) ?? DateTime(1970),
      updatedAt: _parseDateTime(map['updatedAt']) ?? DateTime(1970),
      startsAt: _parseDateTime(map['startsAt']),
      endsAt: _parseDateTime(map['endsAt']),
    );
  }

  DateTime? _parseDateTime(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}
