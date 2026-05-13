import 'package:web_learner/features/announcement/data/remote/announcement_remote_data_source.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';
import 'package:web_learner/features/announcement/domain/repositories/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  const AnnouncementRepositoryImpl({
    required AnnouncementRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AnnouncementRemoteDataSource _remoteDataSource;

  @override
  Future<List<Announcement>> fetchLoginAnnouncements() async {
    final records = await _remoteDataSource.fetchAnnouncements();
    return records.map((record) => record.toEntity()).toList(growable: false);
  }
}
