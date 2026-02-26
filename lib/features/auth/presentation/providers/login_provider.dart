import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/validators.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

part 'login_provider.g.dart';

/// 登录状态管理
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() {
    return const LoginState();
  }

  /// 更新身份证号
  void updateIdCard(String value) {
    state = state.copyWith(
      idCard: value,
      clearIdCardError: true,
      clearErrorMessage: true,
    );
  }

  /// 更新密码
  void updatePassword(String value) {
    state = state.copyWith(
      password: value,
      clearPasswordError: true,
      clearErrorMessage: true,
    );
  }

  /// 切换记住账号
  void toggleRememberAccount() {
    state = state.copyWith(rememberAccount: !state.rememberAccount);
  }

  /// 切换密码可见性
  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  /// 验证表单
  bool validateForm() {
    final idCardError = Validators.idCard(state.idCard);
    final passwordError = Validators.password(state.password);

    state = state.copyWith(
      idCardError: idCardError,
      passwordError: passwordError,
    );

    return idCardError == null && passwordError == null;
  }

  /// 执行登录
  Future<bool> login() async {
    if (!validateForm()) return false;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final useCase = LoginUseCase(ref.read(authRepositoryProvider));
      final user = await useCase(idCard: state.idCard, password: state.password);

      debugPrint('登录成功: ${user.userName}');

      state = state.copyWith(isLoading: false, clearErrorMessage: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  /// 清除所有错误
  void clearErrors() {
    state = state.clearErrors();
  }
}
