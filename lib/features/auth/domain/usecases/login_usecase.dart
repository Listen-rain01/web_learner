import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// 登录用例
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({required String idCard, required String password}) {
    return _repository.login(idCard: idCard, password: password);
  }
}
