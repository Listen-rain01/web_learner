import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/login_request.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

/// 认证 Repository 实现
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<UserEntity> login({required String idCard, required String password}) async {
    final response = await _dataSource.login(
      LoginRequest(idCard: idCard, password: password),
    );

    if (!response.isSuccess) {
      throw AppException(response.errorMessage ?? '登录失败');
    }

    return UserEntity(
      userId: response.userId!,
      userName: response.userName!,
      token: response.token!,
    );
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
}
