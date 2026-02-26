import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 日志拦截器
/// 用于打印请求和响应信息，方便调试
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('┌─────────────────────────────────────────────────────────────');
    debugPrint('│ 🚀 REQUEST [${options.method}] ${options.uri}');
    if (kDebugMode && options.data != null) {
      debugPrint('│ Body: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      debugPrint('│ Query: ${options.queryParameters}');
    }
    debugPrint('└─────────────────────────────────────────────────────────────');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('┌─────────────────────────────────────────────────────────────');
    debugPrint('│ ✅ RESPONSE [${response.statusCode}] ${response.requestOptions.uri}');
    debugPrint('│ Data: ${response.data}');
    debugPrint('└─────────────────────────────────────────────────────────────');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('┌─────────────────────────────────────────────────────────────');
    debugPrint('│ ❌ ERROR [${err.response?.statusCode}] ${err.requestOptions.uri}');
    debugPrint('│ Message: ${err.message}');
    if (err.response?.data != null) {
      debugPrint('│ Error Data: ${err.response?.data}');
    }
    debugPrint('└─────────────────────────────────────────────────────────────');
    super.onError(err, handler);
  }
}
