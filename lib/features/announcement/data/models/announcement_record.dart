import 'package:web_learner/features/announcement/domain/entities/announcement.dart';

/// 表示从 Supabase 读取到的原始公告记录。
class AnnouncementRecord {
  const AnnouncementRecord({
    required this.id,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    this.startsAt,
    this.endsAt,
  });

  /// 根据 Supabase 返回行创建记录模型。
  factory AnnouncementRecord.fromMap(Map<String, dynamic> map) {
    return AnnouncementRecord(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      isPinned: map['is_pinned'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      startsAt: _parseDateTime(map['starts_at']),
      endsAt: _parseDateTime(map['ends_at']),
    );
  }

  final String id;
  final String title;
  final String content;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startsAt;
  final DateTime? endsAt;

  /// 转换为领域层使用的公告实体。
  Announcement toEntity() {
    return Announcement(
      id: id,
      title: title,
      content: content,
      isPinned: isPinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
      startsAt: startsAt,
      endsAt: endsAt,
    );
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}
