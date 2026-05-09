import '../entities/auth_session.dart';

abstract class AuthRepository {
  AuthSession? get currentSession;

  Future<AuthSession> signIn({
    required String account,
    required String password,
  });

  Future<void> signOut();
}
