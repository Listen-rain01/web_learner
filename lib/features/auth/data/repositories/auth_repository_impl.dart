import 'package:web_learner/core/network/session_cookie_store.dart';
import 'package:web_learner/features/auth/data/models/login_request.dart';
import 'package:web_learner/features/auth/data/remote/auth_remote_data_source.dart';
import 'package:web_learner/features/auth/domain/entities/auth_session.dart';
import 'package:web_learner/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SessionCookieStore sessionCookieStore,
  })  : _remoteDataSource = remoteDataSource,
        _sessionCookieStore = sessionCookieStore;

  final AuthRemoteDataSource _remoteDataSource;
  final SessionCookieStore _sessionCookieStore;

  AuthSession? _currentSession;

  @override
  AuthSession? get currentSession => _currentSession;

  @override
  Future<AuthSession> signIn({
    required String account,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      LoginRequest(
        idCard: account,
        password: password,
      ),
    );

    final session = AuthSession(
      pid: result.pid,
      userName: result.userName,
      siteCode: result.siteCode,
      passwordDigest: result.passwordDigest,
      loggedInAt: DateTime.now(),
    );
    _currentSession = session;
    return session;
  }

  @override
  Future<void> signOut() async {
    _currentSession = null;
    await _sessionCookieStore.clear();
  }
}
