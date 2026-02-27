import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/app_exception.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/supabase_auth_datasource.dart';
import '../../data/models/login_request.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

/// 认证 Repository 实现
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource, this._supabaseDataSource);

  final AuthRemoteDataSource _dataSource;
  final SupabaseAuthDataSource _supabaseDataSource;

  @override
  Future<UserEntity> login({required String idCard, required String password}) async {
    // 1. 登录前检查是否被禁止
    await _supabaseDataSource.checkBanned(idCard);

    // 2. 原有业务 API 登录
    final response = await _dataSource.login(
      LoginRequest(idCard: idCard, password: password),
    );

    if (!response.isSuccess) {
      throw AppException(response.errorMessage ?? '登录失败');
    }

    final user = UserEntity(
      userId: response.userId!,
      userName: response.userName!,
      token: response.token!,
      idCard: idCard,
    );

    // 3. 记录登录用户（静默，不影响主流程）
    try {
      await _supabaseDataSource.upsertUser(
        idCard: idCard,
        name: user.userName,
      );
    } catch (_) {}

    return user;
  }
  @override
  Stream<bool> watchBanStatus(String idCard) {
    return _supabaseDataSource.watchBanStatus(idCard);
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(supabaseAuthDataSourceProvider),
  );
}
