/// 表示老系统登录接口解析后的结果。
class LoginResult {
  const LoginResult({
    required this.pid,
    required this.userName,
    required this.passwordDigest,
    required this.siteCode,
    required this.rawResponse,
  });

  final String pid;
  final String userName;
  final String passwordDigest;
  final String siteCode;
  final String rawResponse;
}
