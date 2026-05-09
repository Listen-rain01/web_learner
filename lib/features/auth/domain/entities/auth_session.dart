class AuthSession {
  const AuthSession({
    required this.userId,
    required this.displayName,
    required this.signedInAt,
  });

  final String userId;
  final String displayName;
  final DateTime signedInAt;
}
