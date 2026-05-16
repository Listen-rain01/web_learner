/// 保存应用内部使用的老系统已登录会话。
class AuthSession {
  const AuthSession({
    required this.pid,
    required this.userName,
    required this.siteCode,
    required this.passwordDigest,
    required this.loggedInAt,
  });

  final String pid;
  final String userName;
  final String siteCode;
  final String passwordDigest;
  final DateTime loggedInAt;

  /// 返回老系统用户的唯一标识。
  String get userId => pid;

  /// 返回当前用户优先展示的名称。
  String get displayName => userName.isEmpty ? pid : userName;
}
