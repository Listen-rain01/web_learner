import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../models/announcement_model.dart';

part 'announcement_remote_datasource.g.dart';

class AnnouncementRemoteDataSource {
  const AnnouncementRemoteDataSource(this._client);

  final SupabaseClient _client;

  /// 实时订阅最新一条启用的公告
  /// 每当 announcements 表发生变更时自动推送最新数据
  Stream<AnnouncementModel?> watchLatestAnnouncement() {
    return _client
        .from('announcements')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((rows) {
          final active = rows.where((r) => r['is_active'] == true).toList();
          if (active.isEmpty) return null;
          return AnnouncementModel.fromJson(active.first);
        });
  }
}

@riverpod
AnnouncementRemoteDataSource announcementRemoteDataSource(Ref ref) {
  return AnnouncementRemoteDataSource(ref.watch(supabaseClientProvider));
}
