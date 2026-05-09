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

  String get userId => pid;

  String get displayName => userName.isEmpty ? pid : userName;
}
