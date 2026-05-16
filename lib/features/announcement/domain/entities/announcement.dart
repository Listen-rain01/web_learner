/// 表示展示给终端用户的登录页公告。
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    this.startsAt,
    this.endsAt,
  });

  final String id;
  final String title;
  final String content;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startsAt;
  final DateTime? endsAt;

  /// 返回从完整公告正文中提取出的单行预览文本。
  String get previewText => content.replaceAll(RegExp(r'\s+'), ' ').trim();

  /// 返回公告在指定时间点是否仍可展示。
  bool isVisibleAt(DateTime time) {
    if (id.trim().isEmpty || title.trim().isEmpty || content.trim().isEmpty) {
      return false;
    }
    if (startsAt != null && time.isBefore(startsAt!)) {
      return false;
    }
    if (endsAt != null && time.isAfter(endsAt!)) {
      return false;
    }
    return true;
  }
}
