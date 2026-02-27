import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/esdt_encryption.dart';
import '../models/knowledge_type_model.dart';
import '../models/study_material_model.dart';

part 'study_remote_datasource.g.dart';

class StudyRemoteDataSource {
  const StudyRemoteDataSource(this._dio);

  final Dio _dio;

  /// 接口1：获取知识类型列表（pid = 加密用户ID）
  Future<List<KnowledgeTypeModel>> getTypes({required String pid}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.getAllTypeOne,
      queryParameters: {'pid': EsdtEncryption.encrypt(pid)},
    );
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data.cast<Map<String, dynamic>>().map(KnowledgeTypeModel.fromJson).toList();
  }

  /// 接口2：获取知识子分类（pid = 加密typeId，did = 加密departmentId）
  Future<List<KnowledgeTypeModel>> getChildTypes({
    required String typeId,
    required String departmentId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.getAllChildTypeOne,
      queryParameters: {
        'pid': EsdtEncryption.encrypt(typeId),
        'did': EsdtEncryption.encrypt(departmentId),
      },
    );
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data.cast<Map<String, dynamic>>().map(KnowledgeTypeModel.fromJson).toList();
  }

  /// 接口3：获取学习资料列表（所有参数不加密）
  Future<List<StudyMaterialModel>> getMaterials({
    required String typeId,
    required String departmentId,
    required String pid,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.getStudyOne,
      queryParameters: {
        'typeid': typeId,
        'DepartmentId': departmentId,
        'pid': pid,
        'rows': '20',
        'page': '1',
      },
    );
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data.cast<Map<String, dynamic>>().map(StudyMaterialModel.fromJson).toList();
  }

  /// 接口4：完成阅读（pid = 加密用户ID，zsid = 加密资料ID）
  Future<bool> completeReading({
    required String pid,
    required String subjectId,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.studyKnowledgeOne,
      queryParameters: {
        'pid': EsdtEncryption.encrypt(pid),
        'zsid': EsdtEncryption.encrypt(subjectId),
      },
    );
    final raw = response.data;
    final Map<String, dynamic> map = raw is String
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : raw is Map
            ? Map<String, dynamic>.from(raw)
            : {};
    return map['success'] as bool? ?? false;
  }
}

@riverpod
StudyRemoteDataSource studyRemoteDataSource(Ref ref) {
  return StudyRemoteDataSource(ref.watch(dioClientProvider));
}
