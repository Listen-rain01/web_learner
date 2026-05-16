/// 承载老系统登录接口需要的账号凭据。
class LoginRequest {
  const LoginRequest({
    required this.idCard,
    required this.password,
  });

  final String idCard;
  final String password;
}
