import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/app/app.dart';
import 'package:web_learner/core/di/core_providers.dart';
import 'package:web_learner/core/storage/local_kv_store.dart';
import 'package:web_learner/features/announcement/application/announcement_controller.dart';
import 'package:web_learner/features/announcement/data/local/announcement_local_cache_data_source.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localKvStore = LocalKvStore();
  final cacheDataSource = AnnouncementLocalCacheDataSource(
    localKvStore: localKvStore,
  );
  final initialAnnouncementState = await cacheDataSource.loadState();

  final container = ProviderContainer(
    overrides: [
      localKvStoreProvider.overrideWithValue(localKvStore),
      announcementInitialStateProvider.overrideWithValue(
        initialAnnouncementState,
      ),
    ],
  );

  unawaited(container.read(announcementControllerProvider.notifier).refresh());

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
