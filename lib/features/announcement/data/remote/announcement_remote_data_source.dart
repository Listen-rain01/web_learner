import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_learner/features/announcement/data/models/announcement_record.dart';

/// 从 Supabase 加载登录页公告数据。
class AnnouncementRemoteDataSource {
  const AnnouncementRemoteDataSource({
    required SupabaseClient? client,
  }) : _client = client;

  final SupabaseClient? _client;

  /// 按置顶状态和更新时间加载公告列表。
  Future<List<AnnouncementRecord>> fetchAnnouncements() async {
    // 本地开发或早期接入环境可能还没有启用 Supabase。
    if (_client == null) {
      return const [];
    }

    final response = await _client
        .from('announcements')
        .select(
          'id, title, content, is_pinned, starts_at, ends_at, created_at, updated_at',
        )
        .order('is_pinned', ascending: false)
        .order('updated_at', ascending: false);

    final rows = (response as List).whereType<Map<String, dynamic>>().toList(
      growable: false,
    );

    return rows
        .map(AnnouncementRecord.fromMap)
        .where(
          (record) => record.id.isNotEmpty && record.title.trim().isNotEmpty,
        )
        .toList(growable: false);
  }
}
