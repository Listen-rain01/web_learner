import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/core/di/core_providers.dart';
import 'package:web_learner/core/errors/app_exception.dart';
import 'package:web_learner/features/auth/application/auth_state.dart';
import 'package:web_learner/features/auth/application/saved_account_credential.dart';
import 'package:web_learner/features/auth/di/auth_providers.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// 管理登录状态、记住账号数据与密码可见性。
class AuthController extends Notifier<AuthState> {
  static const _savedCredentialsKey = 'auth.saved_credentials';
  static const _rememberAccountKey = 'auth.remember_account';

  @override
  AuthState build() {
    unawaited(Future<void>.microtask(_loadPreferences));
    final repository = ref.watch(authRepositoryProvider);
    return AuthState(session: repository.currentSession);
  }

  /// 执行登录，并在启用时更新本地记住账号数据。
  Future<void> signIn({
    required String account,
    required String password,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      errorMessage: null,
      showAccountSuggestions: false,
    );

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .signIn(
            account: account,
            password: password,
          );

      await _persistCredential(
        idCard: account.trim(),
        password: password,
      );

      state = state.copyWith(
        session: session,
        isSubmitting: false,
        errorMessage: null,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
      );
    } on Exception {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: '登录失败，请稍后重试。',
      );
    }
  }

  /// 清理当前应用会话与基于 Cookie 的后端会话。
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AuthState();
  }

  /// 清理当前界面展示的登录错误信息。
  void clearError() {
    if (state.errorMessage == null) {
      return;
    }
    state = state.copyWith(errorMessage: null);
  }

  /// 切换是否记住登录成功的账号。
  void toggleRememberAccount() {
    final nextValue = !state.rememberAccount;
    state = state.copyWith(rememberAccount: nextValue);
    unawaited(_saveRememberAccount(nextValue));
  }

  /// 切换登录页密码输入框的可见性。
  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  /// 在存在数据时展开记住账号建议列表。
  void showAccountSuggestions() {
    if (state.savedAccounts.isEmpty) {
      return;
    }
    state = state.copyWith(showAccountSuggestions: true);
  }

  /// 收起记住账号建议列表。
  void hideAccountSuggestions() {
    if (!state.showAccountSuggestions) {
      return;
    }
    state = state.copyWith(showAccountSuggestions: false);
  }

  /// 返回选中的记住账号凭据，并关闭建议面板。
  SavedAccountCredential? selectAccount(String idCard) {
    final credential = state.savedAccounts
        .cast<SavedAccountCredential?>()
        .firstWhere(
          (item) => item?.idCard == idCard,
          orElse: () => null,
        );

    state = state.copyWith(showAccountSuggestions: false);
    return credential;
  }

  /// 从本地安全存储中移除一个记住账号。
  Future<void> removeAccount(String idCard) async {
    final updatedAccounts = state.savedAccounts
        .where((account) => account.idCard != idCard)
        .toList(growable: false);

    state = state.copyWith(
      savedAccounts: updatedAccounts,
      showAccountSuggestions: updatedAccounts.isNotEmpty,
    );

    await _writeSavedCredentials(updatedAccounts);
  }

  Future<void> _loadPreferences() async {
    final rememberValue = await ref
        .read(localKvStoreProvider)
        .read(
          _rememberAccountKey,
        );
    final savedValue = await ref
        .read(secureKvStoreProvider)
        .read(
          _savedCredentialsKey,
        );

    final rememberAccount = rememberValue != 'false';
    final savedAccounts = _decodeSavedCredentials(savedValue);

    state = state.copyWith(
      rememberAccount: rememberAccount,
      savedAccounts: savedAccounts,
    );
  }

  Future<void> _saveRememberAccount(bool value) {
    return ref
        .read(localKvStoreProvider)
        .write(
          key: _rememberAccountKey,
          value: value.toString(),
        );
  }

  Future<void> _persistCredential({
    required String idCard,
    required String password,
  }) async {
    await _saveRememberAccount(state.rememberAccount);

    // 关闭记住账号后，即使后端会话已经登录成功，也不能再写入本地凭据。
    if (!state.rememberAccount || idCard.isEmpty) {
      return;
    }

    final updatedAccounts = [
      SavedAccountCredential(idCard: idCard, password: password),
      ...state.savedAccounts.where((account) => account.idCard != idCard),
    ];

    state = state.copyWith(savedAccounts: updatedAccounts);
    await _writeSavedCredentials(updatedAccounts);
  }

  Future<void> _writeSavedCredentials(
    List<SavedAccountCredential> accounts,
  ) {
    final encoded = jsonEncode(
      accounts.map((account) => account.toMap()).toList(growable: false),
    );

    return ref
        .read(secureKvStoreProvider)
        .write(
          key: _savedCredentialsKey,
          value: encoded,
        );
  }

  List<SavedAccountCredential> _decodeSavedCredentials(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is List) {
        return decoded
            .whereType<Map<dynamic, dynamic>>()
            .map((item) {
              return SavedAccountCredential.fromMap(
                Map<String, dynamic>.from(item),
              );
            })
            .where((item) {
              return item.idCard.trim().isNotEmpty;
            })
            .toList(growable: false);
      }
    } on FormatException catch (error) {
      // 本地缓存损坏不能阻塞登录页继续加载。
      ref
          .read(appLoggerProvider)
          .warning(
            'saved credentials decode failed: ${error.message}',
          );
    }

    return const [];
  }
}
