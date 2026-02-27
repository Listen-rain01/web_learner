import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/esdt_encryption.dart';
import '../models/accumulate_model.dart';

part 'accumulate_remote_datasource.g.dart';

class AccumulateRemoteDataSource {
  const AccumulateRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<AccumulateModel>> getTodayAccumulate({required String pid}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.getPersonTodayAccumulateOne,
      queryParameters: {
        'pid': EsdtEncryption.encrypt(pid),
        '_': DateTime.now().millisecondsSinceEpoch,
      },
    );
    final raw = response.data;
    final Map<String, dynamic> map = raw is String
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : raw is Map
            ? Map<String, dynamic>.from(raw)
            : {};
    final data = map['data'] as List<dynamic>? ?? [];
    return data.cast<Map<String, dynamic>>().map(AccumulateModel.fromJson).toList();
  }
}

@riverpod
AccumulateRemoteDataSource accumulateRemoteDataSource(Ref ref) {
  return AccumulateRemoteDataSource(ref.watch(dioClientProvider));
}
