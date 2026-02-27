import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/announcement_repository_impl.dart';
import '../../domain/entities/announcement_entity.dart';

part 'announcement_provider.g.dart';

@riverpod
Stream<AnnouncementEntity?> announcement(Ref ref) {
  final repo = ref.watch(announcementRepositoryProvider);
  return repo.watchLatestAnnouncement();
}
