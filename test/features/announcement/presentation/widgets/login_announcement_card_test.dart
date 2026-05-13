import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_learner/features/announcement/application/announcement_controller.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';
import 'package:web_learner/features/announcement/presentation/widgets/login_announcement_card.dart';

void main() {
  testWidgets('shows latest announcement on login card', (tester) async {
    final announcement = Announcement(
      id: 'announcement-1',
      title: '登录页公告测试',
      content: '欢迎使用 Web Learner。',
      isPinned: true,
      createdAt: DateTime(2026, 5, 13),
      updatedAt: DateTime(2026, 5, 13),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginAnnouncementsProvider.overrideWith(
            (_) async => [announcement],
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: LoginAnnouncementCard(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('系统公告'), findsOneWidget);
    expect(find.text('登录页公告测试'), findsOneWidget);
    expect(find.text('查看详情'), findsOneWidget);
  });
}
