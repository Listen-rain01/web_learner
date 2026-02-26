import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/validators.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/login_request.dart';
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
    state = state.copyWith(
      rememberAccount: !state.rememberAccount,
    );
  }

  /// 切换密码可见性
  void togglePasswordVisibility() {
    state = state.copyWith(
      showPassword: !state.showPassword,
    );
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
    // 先验证表单
    if (!validateForm()) {
      return false;
    }

    // 开始加载，清除之前的错误信息
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
    );

    try {
      // 调用登录 API
      final dataSource = ref.read(authRemoteDataSourceProvider);
      final request = LoginRequest(
        idCard: state.idCard,
        password: state.password,
      );

      final response = await dataSource.login(request);

      if (response.isSuccess) {
        // 登录成功，清除所有错误
        debugPrint('登录成功: ${response.toString()}');

        // TODO: 保存用户信息和 Token
        // 1. 如果勾选了记住账号，保存到本地
        // if (state.rememberAccount) {
        //   await StorageService.saveIdCard(state.idCard);
        // }
        // 2. 保存 token 和用户信息
        // await StorageService.saveToken(response.token!);
        // await StorageService.saveUserInfo(response.userId!, response.userName!);

        state = state.copyWith(
          isLoading: false,
          clearErrorMessage: true,
        );

        return true; // 返回成功
      } else {
        // 登录失败
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.errorMessage ?? '登录失败',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '登录异常: $e',
      );
      return false;
    }
  }

  /// 清除所有错误
  void clearErrors() {
    state = state.clearErrors();
  }
}
