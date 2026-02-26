import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/esdt_encryption.dart';
import '../models/profile_model.dart';

part 'profile_remote_datasource.g.dart';

/// 个人信息远程数据源
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ProfileModel> getProfile({required String userId}) async {
    final response = await _dio.post(
      ApiConstants.myBaseInfo,
      data: {
        'pid': EsdtEncryption.encrypt(userId),
        'sstype': '0',
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
      ),
    );
    return ProfileModel.fromHtml(response.data as String);
  }
}

@riverpod
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return ProfileRemoteDataSource(dio);
}
