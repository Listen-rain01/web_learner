import 'dart:math';

import 'package:dio/dio.dart';
import 'package:web_learner/core/config/app_environment.dart';
import 'package:web_learner/core/errors/app_exception.dart';
import 'package:web_learner/core/network/api_client_factory.dart';
import 'package:web_learner/core/network/request_encoder.dart';
import 'package:web_learner/features/auth/data/models/login_request.dart';
import 'package:web_learner/features/auth/data/models/login_result.dart';

/// 调用老系统登录接口并规范化它的自定义响应格式。
class AuthRemoteDataSource {
  AuthRemoteDataSource({
    required ApiClientFactory apiClientFactory,
    required AppEnvironment environment,
    required AppRequestEncoder requestEncoder,
    Random? random,
  }) : _apiClientFactory = apiClientFactory,
       _environment = environment,
       _requestEncoder = requestEncoder,
       _random = random ?? Random();

  final ApiClientFactory _apiClientFactory;
  final AppEnvironment _environment;
  final AppRequestEncoder _requestEncoder;
  final Random _random;

  /// 使用老系统账号凭据发起登录。
  ///
  /// 当后端拒绝请求或返回非预期载荷时抛出 [AppException]。
  Future<LoginResult> login(LoginRequest request) async {
    final dio = await _apiClientFactory.create();
    final captcha = (_random.nextInt(18) + 1).toString();

    final response = await dio.post<String>(
      '/PersonWap/GetPersonInfo',
      data: {
        // 登录接口要求身份证号和密码都先做 Esdt 编码。
        'idcard': _requestEncoder.esdt(request.idCard),
        'openid': '',
        'yzm': captcha,
        'pwd': _requestEncoder.esdt(request.password),
        'style': '0',
        'auto': 'false',
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
        headers: {
          'Origin': _environment.origin,
          'Referer': _environment.loginReferer,
        },
      ),
    );

    final rawResponse = response.data?.trim() ?? '';
    if (rawResponse.startsWith('|')) {
      final parts = rawResponse.split('|');
      // 成功响应固定以 "|" 开头，后续位置依次承载 pid、姓名、
      // 密码摘要和站点编码。
      if (parts.length >= 5) {
        return LoginResult(
          pid: parts[1],
          userName: parts[2],
          passwordDigest: parts[3],
          siteCode: parts[4],
          rawResponse: rawResponse,
        );
      }

      throw const AppException('登录响应格式异常，请稍后重试。');
    }

    final message = rawResponse.endsWith('|')
        ? rawResponse.substring(0, rawResponse.length - 1)
        : rawResponse;
    throw AppException(
      message.isEmpty ? '登录失败，请稍后重试。' : message,
    );
  }
}
