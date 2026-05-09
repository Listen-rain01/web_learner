import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/core/errors/app_exception.dart';
import 'package:web_learner/features/auth/application/auth_state.dart';
import 'package:web_learner/features/auth/di/auth_providers.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final repository = ref.watch(authRepositoryProvider);
    return AuthState(session: repository.currentSession);
  }

  Future<void> signIn({
    required String account,
    required String password,
  }) async {
    state = state.copyWith(isBusy: true, clearError: true);

    try {
      final session = await ref.read(authRepositoryProvider).signIn(
            account: account,
            password: password,
          );
      state = AuthState(session: session);
    } on AppException catch (error) {
      state = state.copyWith(
        isBusy: false,
        errorMessage: error.message,
      );
    } on Exception {
      state = state.copyWith(
        isBusy: false,
        errorMessage: 'Sign-in failed. Review the integration and try again.',
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
    state = state.copyWith(clearError: true);
  }
}
