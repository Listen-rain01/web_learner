/// API 常量配置
class ApiConstants {
  ApiConstants._();

  /// 基础 URL
  static const String baseUrl = 'http://61.150.84.25:100';

  /// 连接超时时间（毫秒）
  static const int connectTimeout = 30000;

  /// 接收超时时间（毫秒）
  static const int receiveTimeout = 30000;

  /// 发送超时时间（毫秒）
  static const int sendTimeout = 30000;

  // ==================== API 端点 ====================

  /// 登录接口
  static const String login = '/PersonWap/GetPersonInfo';

  /// 登出接口
  static const String logout = '/api/auth/logout';

  /// 刷新 Token 接口
  static const String refreshToken = '/api/auth/refresh';
}
