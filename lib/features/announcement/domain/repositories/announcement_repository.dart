// ignore_for_file: one_member_abstracts, reason: 特性仓储抽象是项目架构要求。

import 'package:web_learner/features/announcement/domain/entities/announcement.dart';

/// 提供登录流程需要使用的公告数据。
abstract interface class AnnouncementRepository {
  /// 加载需要展示在登录页的公告列表。
  Future<List<Announcement>> fetchLoginAnnouncements();
}
