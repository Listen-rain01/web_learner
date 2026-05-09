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

class AuthController extends Notifier<AuthState> {
  static const _savedCredentialsKey = 'auth.saved_credentials';
  static const _rememberAccountKey = 'auth.remember_account';

  @override
  AuthState build() {
    unawaited(Future<void>.microtask(_loadPreferences));
    final repository = ref.watch(authRepositoryProvider);
    return AuthState(session: repository.currentSession);
  }

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
      final session = await ref.read(authRepositoryProvider).signIn(
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

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AuthState();
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }
    state = state.copyWith(errorMessage: null);
  }

  void toggleRememberAccount() {
    final nextValue = !state.rememberAccount;
    state = state.copyWith(rememberAccount: nextValue);
    unawaited(_saveRememberAccount(nextValue));
  }

  void togglePasswordVisibility() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void showAccountSuggestions() {
    if (state.savedAccounts.isEmpty) {
      return;
    }
    state = state.copyWith(showAccountSuggestions: true);
  }

  void hideAccountSuggestions() {
    if (!state.showAccountSuggestions) {
      return;
    }
    state = state.copyWith(showAccountSuggestions: false);
  }

  SavedAccountCredential? selectAccount(String idCard) {
    final credential = state.savedAccounts.cast<SavedAccountCredential?>()
        .firstWhere(
          (item) => item?.idCard == idCard,
          orElse: () => null,
        );

    state = state.copyWith(showAccountSuggestions: false);
    return credential;
  }

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
    final rememberValue = await ref.read(localKvStoreProvider).read(
          _rememberAccountKey,
        );
    final savedValue = await ref.read(secureKvStoreProvider).read(
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
    return ref.read(localKvStoreProvider).write(
          key: _rememberAccountKey,
          value: value.toString(),
        );
  }

  Future<void> _persistCredential({
    required String idCard,
    required String password,
  }) async {
    await _saveRememberAccount(state.rememberAccount);

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

    return ref.read(secureKvStoreProvider).write(
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
        return decoded.whereType<Map<dynamic, dynamic>>().map((item) {
          return SavedAccountCredential.fromMap(
            Map<String, dynamic>.from(item),
          );
        }).where((item) {
          return item.idCard.trim().isNotEmpty;
        }).toList(growable: false);
      }
    } on FormatException catch (error) {
      ref.read(appLoggerProvider).warning(
            'saved credentials decode failed: ${error.message}',
          );
    }

    return const [];
  }
}
