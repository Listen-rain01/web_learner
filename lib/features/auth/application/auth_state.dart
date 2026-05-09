import '../domain/entities/auth_session.dart';

class AuthState {
  const AuthState({
    this.session,
    this.isBusy = false,
    this.errorMessage,
  });

  final AuthSession? session;
  final bool isBusy;
  final String? errorMessage;

  bool get isAuthenticated => session != null;

  AuthState copyWith({
    AuthSession? session,
    bool? isBusy,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      session: session ?? this.session,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
