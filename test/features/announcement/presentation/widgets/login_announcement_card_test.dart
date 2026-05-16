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
            (_) => [announcement],
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: LoginAnnouncementCard(),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byIcon(Icons.campaign_outlined), findsOneWidget);
    expect(find.textContaining('登录页公告测试'), findsWidgets);
    expect(find.text('查看'), findsNothing);
  });
}
