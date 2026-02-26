/// 登录响应模型
class LoginResponse {
  const LoginResponse({
    required this.isSuccess,
    this.userId,
    this.userName,
    this.token,
    this.errorMessage,
  });

  /// 是否登录成功
  final bool isSuccess;

  /// 用户 ID（UUID 格式）
  final String? userId;

  /// 用户真实姓名
  final String? userName;

  /// 会话令牌（MD5 格式）
  final String? token;

  /// 错误信息
  final String? errorMessage;

  /// 从管道分隔的文本解析响应
  ///
  /// 成功响应格式：|userId|userName|token
  /// 失败响应格式：errorMessage|
  factory LoginResponse.fromPipeText(String text) {
    final parts = text.split('|');

    if (parts.isEmpty) {
      return const LoginResponse(
        isSuccess: false,
        errorMessage: '响应格式错误',
      );
    }

    // 第一个字段为空表示成功
    if (parts[0].isEmpty) {
      // 成功响应至少有 4 个部分：空字符串、userId、userName、token
      if (parts.length < 4) {
        return const LoginResponse(
          isSuccess: false,
          errorMessage: '响应数据不完整',
        );
      }

      return LoginResponse(
        isSuccess: true,
        userId: parts[1],
        userName: parts[2],
        token: parts[3],
      );
    } else {
      // 失败响应，第一个字段是错误信息
      return LoginResponse(
        isSuccess: false,
        errorMessage: parts[0],
      );
    }
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'LoginResponse(success: true, userId: $userId, userName: $userName, token: $token)';
    } else {
      return 'LoginResponse(success: false, error: $errorMessage)';
    }
  }
}
