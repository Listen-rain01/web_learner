import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_learner/features/announcement/data/models/announcement_record.dart';

class AnnouncementRemoteDataSource {
  const AnnouncementRemoteDataSource({
    required SupabaseClient? client,
  }) : _client = client;

  final SupabaseClient? _client;

  Future<List<AnnouncementRecord>> fetchAnnouncements() async {
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

    final rows = (response as List)
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return rows
        .map(AnnouncementRecord.fromMap)
        .where((record) => record.id.isNotEmpty && record.title.trim().isNotEmpty)
        .toList(growable: false);
  }
}
