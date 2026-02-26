import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

part 'auth_remote_datasource.g.dart';

/// 认证远程数据源
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  /// 登录
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toFormData(),
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain, // 响应为纯文本
        ),
      );

      // 解析管道分隔的文本响应
      final responseText = response.data as String;
      return LoginResponse.fromPipeText(responseText);
    } on DioException catch (e) {
      // 处理网络错误
      if (e.response != null) {
        return LoginResponse(
          isSuccess: false,
          errorMessage: '服务器错误: ${e.response?.statusCode}',
        );
      } else {
        return LoginResponse(
          isSuccess: false,
          errorMessage: '网络连接失败: ${e.message}',
        );
      }
    } catch (e) {
      return LoginResponse(
        isSuccess: false,
        errorMessage: '未知错误: $e',
      );
    }
  }
}

/// 认证远程数据源 Provider
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRemoteDataSource(dio);
}
