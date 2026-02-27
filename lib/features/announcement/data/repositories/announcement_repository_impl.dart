import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/announcement_entity.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/announcement_remote_datasource.dart';

part 'announcement_repository_impl.g.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  const AnnouncementRepositoryImpl(this._dataSource);

  final AnnouncementRemoteDataSource _dataSource;

  @override
  Stream<AnnouncementEntity?> watchLatestAnnouncement() {
    return _dataSource
        .watchLatestAnnouncement()
        .map((model) => model?.toEntity());
  }
}

@riverpod
AnnouncementRepository announcementRepository(Ref ref) {
  return AnnouncementRepositoryImpl(
    ref.watch(announcementRemoteDataSourceProvider),
  );
}
