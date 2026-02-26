import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/profile_remote_datasource.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_repository_impl.g.dart';

/// 个人信息 Repository 实现
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileRemoteDataSource _dataSource;

  @override
  Future<ProfileEntity> getProfile({required String userId}) async {
    final model = await _dataSource.getProfile(userId: userId);
    return model.toEntity();
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(dataSource);
}
