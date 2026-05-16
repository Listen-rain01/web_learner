import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web_learner/core/di/core_providers.dart';
import 'package:web_learner/core/storage/local_kv_store.dart';
import 'package:web_learner/features/announcement/application/announcement_controller.dart';
import 'package:web_learner/features/announcement/application/announcement_state.dart';
import 'package:web_learner/features/announcement/di/announcement_providers.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';
import 'package:web_learner/features/announcement/domain/repositories/announcement_repository.dart';

class _MockAnnouncementRepository extends Mock
    implements AnnouncementRepository {}

void main() {
  late LocalKvStore localKvStore;
  late AnnouncementRepository repository;

  setUp(() {
    localKvStore = LocalKvStore.memory();
    repository = _MockAnnouncementRepository();
  });

  test('刷新成功后写入公告缓存', () async {
    final announcement = Announcement(
      id: 'announcement-1',
      title: '登录页公告',
      content: '欢迎使用 Web Learner。',
      isPinned: true,
      createdAt: DateTime(2026, 5, 17),
      updatedAt: DateTime(2026, 5, 17),
    );

    when(
      () => repository.fetchLoginAnnouncements(),
    ).thenAnswer((_) async => [announcement]);

    final container = ProviderContainer(
      overrides: [
        localKvStoreProvider.overrideWithValue(localKvStore),
        announcementRepositoryProvider.overrideWithValue(repository),
        announcementInitialStateProvider.overrideWithValue(
          const AnnouncementState(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(announcementControllerProvider.notifier).refresh();

    final state = container.read(announcementControllerProvider);
    final cache = await container
        .read(announcementLocalCacheDataSourceProvider)
        .loadState();

    expect(state.announcements, hasLength(1));
    expect(state.announcements.first.title, '登录页公告');
    expect(cache.announcements, hasLength(1));
    expect(cache.announcements.first.title, '登录页公告');
  });

  test('刷新失败时保留旧缓存公告', () async {
    final cachedAnnouncement = Announcement(
      id: 'announcement-1',
      title: '缓存公告',
      content: '这是一条缓存公告。',
      isPinned: false,
      createdAt: DateTime(2026, 5, 17),
      updatedAt: DateTime(2026, 5, 17),
    );

    when(
      () => repository.fetchLoginAnnouncements(),
    ).thenThrow(Exception('network failed'));

    final container = ProviderContainer(
      overrides: [
        localKvStoreProvider.overrideWithValue(localKvStore),
        announcementRepositoryProvider.overrideWithValue(repository),
        announcementInitialStateProvider.overrideWithValue(
          AnnouncementState(
            announcements: [cachedAnnouncement],
            lastSuccessfulRefreshAt: DateTime(2026, 5, 17, 10),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(announcementControllerProvider.notifier).refresh();

    final state = container.read(announcementControllerProvider);
    expect(state.announcements, hasLength(1));
    expect(state.announcements.first.title, '缓存公告');
  });
}
