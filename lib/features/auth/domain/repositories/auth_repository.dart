import 'package:web_learner/features/auth/domain/entities/auth_session.dart';

/// 定义应用层需要的认证操作。
abstract class AuthRepository {
  /// 返回当前内存中的已登录会话，没有则为空。
  AuthSession? get currentSession;

  /// 使用给定的老系统账号和密码登录。
  Future<AuthSession> signIn({
    required String account,
    required String password,
  });

  /// 登出当前应用会话。
  Future<void> signOut();
}
