import '../entities/user_entity.dart';

/// 认证 Repository 抽象接口
abstract interface class AuthRepository {
  Future<UserEntity> login({required String idCard, required String password});
  Stream<bool> watchBanStatus(String idCard);
}
