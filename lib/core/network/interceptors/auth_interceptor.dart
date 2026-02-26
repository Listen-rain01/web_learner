import 'package:dio/dio.dart';

/// 认证拦截器
/// 用于在请求头中添加 Token
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: 从本地存储获取 Token
    // final token = await StorageService.getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 处理 401 未授权错误
    if (err.response?.statusCode == 401) {
      // TODO: Token 过期，尝试刷新或跳转到登录页
      // 1. 尝试刷新 Token
      // 2. 如果刷新失败，清除本地数据并跳转到登录页
    }

    super.onError(err, handler);
  }
}
