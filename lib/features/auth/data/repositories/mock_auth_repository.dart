import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  AuthSession? _session;

  @override
  AuthSession? get currentSession => _session;

  @override
  Future<AuthSession> signIn({
    required String account,
    required String password,
  }) async {
    final normalizedAccount = account.trim();
    final normalizedPassword = password.trim();

    if (normalizedAccount.isEmpty || normalizedPassword.isEmpty) {
      throw const AppException('Account and password are required.');
    }

    final displayName = normalizedAccount.length > 4
        ? 'Learner ${normalizedAccount.substring(normalizedAccount.length - 4)}'
        : 'Learner';

    _session = AuthSession(
      userId: normalizedAccount,
      displayName: displayName,
      signedInAt: DateTime.now(),
    );

    return _session!;
  }

  @override
  Future<void> signOut() async {
    _session = null;
  }
}
