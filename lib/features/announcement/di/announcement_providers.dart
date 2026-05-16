import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/core/di/core_providers.dart';
import 'package:web_learner/core/supabase/supabase_client_provider.dart';
import 'package:web_learner/features/announcement/data/local/announcement_local_cache_data_source.dart';
import 'package:web_learner/features/announcement/data/remote/announcement_remote_data_source.dart';
import 'package:web_learner/features/announcement/data/repositories/announcement_repository_impl.dart';
import 'package:web_learner/features/announcement/domain/repositories/announcement_repository.dart';

final announcementLocalCacheDataSourceProvider =
    Provider<AnnouncementLocalCacheDataSource>((ref) {
      return AnnouncementLocalCacheDataSource(
        localKvStore: ref.watch(localKvStoreProvider),
      );
    });

final announcementRemoteDataSourceProvider =
    Provider<AnnouncementRemoteDataSource>((ref) {
      return AnnouncementRemoteDataSource(
        client: ref.watch(supabaseClientProvider),
      );
    });

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepositoryImpl(
    remoteDataSource: ref.watch(announcementRemoteDataSourceProvider),
  );
});
