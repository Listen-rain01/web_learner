import 'package:web_learner/features/auth/application/saved_account_credential.dart';
import 'package:web_learner/features/auth/domain/entities/auth_session.dart';

const _unset = Object();

class AuthState {
  const AuthState({
    this.session,
    this.isSubmitting = false,
    this.errorMessage,
    this.rememberAccount = true,
    this.showPassword = false,
    this.savedAccounts = const [],
    this.showAccountSuggestions = false,
  });

  final AuthSession? session;
  final bool isSubmitting;
  final String? errorMessage;
  final bool rememberAccount;
  final bool showPassword;
  final List<SavedAccountCredential> savedAccounts;
  final bool showAccountSuggestions;

  bool get isAuthenticated => session != null;

  AuthState copyWith({
    Object? session = _unset,
    bool? isSubmitting,
    Object? errorMessage = _unset,
    bool? rememberAccount,
    bool? showPassword,
    List<SavedAccountCredential>? savedAccounts,
    bool? showAccountSuggestions,
  }) {
    return AuthState(
      session: identical(session, _unset)
          ? this.session
          : session as AuthSession?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      rememberAccount: rememberAccount ?? this.rememberAccount,
      showPassword: showPassword ?? this.showPassword,
      savedAccounts: savedAccounts ?? this.savedAccounts,
      showAccountSuggestions:
          showAccountSuggestions ?? this.showAccountSuggestions,
    );
  }
}
