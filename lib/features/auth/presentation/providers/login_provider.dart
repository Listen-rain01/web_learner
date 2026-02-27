import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/user_session_provider.dart';
import '../../../../core/storage/saved_accounts_storage.dart';
import '../../../../core/utils/validators.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'login_state.dart';

part 'login_provider.g.dart';

/// 登录状态管理
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() {
    _loadSavedAccounts();
    return const LoginState();
  }

  Future<void> _loadSavedAccounts() async {
    final accounts = await SavedAccountsStorage.loadAccounts();
    final lastIdCard = await SavedAccountsStorage.loadLastIdCard();
    final lastPassword = await SavedAccountsStorage.loadLastPassword();
    final rememberAccount = await SavedAccountsStorage.loadRememberAccount();
    state = state.copyWith(
      savedAccounts: accounts,
      idCard: lastIdCard ?? '',
      password: lastPassword ?? '',
      rememberAccount: rememberAccount,
    );
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

  /// 显示账号下拉建议
  void showSuggestions() {
    if (state.savedAccounts.isNotEmpty) {
      state = state.copyWith(showAccountSuggestions: true);
    }
  }

  /// 隐藏账号下拉建议
  void hideSuggestions() {
    state = state.copyWith(showAccountSuggestions: false);
  }

  /// 选择一个已保存的账号（自动填入对应密码）
  Future<void> selectAccount(String idCard) async {
    final password = await SavedAccountsStorage.loadPasswordForAccount(idCard);
    state = state.copyWith(
      idCard: idCard,
      password: password ?? '',
      showAccountSuggestions: false,
      clearIdCardError: true,
      clearErrorMessage: true,
    );
  }

  /// 删除一个已保存的账号
  Future<void> removeAccount(String idCard) async {
    await SavedAccountsStorage.removeAccount(idCard);
    final accounts = List<String>.from(state.savedAccounts)..remove(idCard);
    state = state.copyWith(
      savedAccounts: accounts,
      showAccountSuggestions: accounts.isNotEmpty,
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
    if (!validateForm()) return false;

    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(idCard: state.idCard, password: state.password);

      debugPrint('登录成功: ${user.userName}');

      ref.read(userSessionProvider.notifier).setUser(user);

      if (state.rememberAccount) {
        await SavedAccountsStorage.saveAccount(state.idCard);
        await SavedAccountsStorage.saveLastLogin(
          idCard: state.idCard,
          password: state.password,
          rememberAccount: true,
        );
        final accounts = await SavedAccountsStorage.loadAccounts();
        state = state.copyWith(savedAccounts: accounts);
      } else {
        await SavedAccountsStorage.clearLastLogin();
      }

      state = state.copyWith(isLoading: false, clearErrorMessage: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// 清除所有错误
  void clearErrors() {
    state = state.clearErrors();
  }
}
