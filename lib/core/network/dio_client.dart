import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/api_constants.dart';
import 'interceptors/logging_interceptor.dart';

part 'dio_client.g.dart';

/// CookieJar Provider，保持登录 Session Cookie
@riverpod
CookieJar cookieJar(Ref ref) => CookieJar();

/// Dio 客户端 Provider
@riverpod
Dio dioClient(Ref ref) {
  final jar = ref.watch(cookieJarProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 添加拦截器（CookieManager 放最前，确保每次请求都带上 Session Cookie）
  dio.interceptors.addAll([
    CookieManager(jar),
    LoggingInterceptor(),
  ]);

  return dio;
}
