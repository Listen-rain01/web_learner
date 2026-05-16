import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:web_learner/core/config/app_environment.dart';
import 'package:web_learner/core/network/session_cookie_store.dart';

/// 创建已配置完成的老系统 Dio 客户端。
class ApiClientFactory {
  const ApiClientFactory({
    required AppEnvironment environment,
    required SessionCookieStore sessionCookieStore,
  }) : _environment = environment,
       _sessionCookieStore = sessionCookieStore;

  final AppEnvironment _environment;
  final SessionCookieStore _sessionCookieStore;

  /// 创建带持久化 Cookie 会话能力的 Dio 实例。
  Future<Dio> create() async {
    final jar = await _sessionCookieStore.loadJar();
    final dio = Dio(
      BaseOptions(
        baseUrl: _environment.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {'Accept': '*/*'},
      ),
    );

    dio.interceptors.add(CookieManager(jar));
    return dio;
  }
}
