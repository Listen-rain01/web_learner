import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/esdt_encryption.dart';
import '../models/exam_category_model.dart';
import '../models/exam_library_model.dart';
import '../models/exam_year_model.dart';
import '../models/unit_model.dart';

part 'exam_remote_datasource.g.dart';

class ExamRemoteDataSource {
  const ExamRemoteDataSource(this._dio);

  final Dio _dio;

  /// 前置：获取单位列表（响应是 HTML，Units 在 vData 里）
  Future<List<UnitModel>> getUnits({required String pid}) async {
    final response = await _dio.post<String>(
      ApiConstants.selectExamType,
      data: {'pid': pid},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
      ),
    );
    final html = response.data ?? '';
    // 从 HTML 中提取 vData JSON: var vData={...};
    final match = RegExp(r'var vData\s*=\s*(\{.*?\});', dotAll: true)
        .firstMatch(html);
    if (match == null) return [];
    final jsonStr = match.group(1)!;
    // 简单提取 Units 字段值
    final unitsMatch = RegExp(r'"Units"\s*:\s*"([^"]*)"').firstMatch(jsonStr);
    final units = unitsMatch?.group(1) ?? '';
    return UnitModel.fromUnitsString(units);
  }

  /// 接口1：获取考试类别
  Future<List<ExamCategoryModel>> getCategories({
    required String pid,
    required String unitId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.getAllTypeEx,
      data: {
        'pid': EsdtEncryption.encrypt(pid),
        'unitid': EsdtEncryption.encrypt(unitId),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data
        .cast<Map<String, dynamic>>()
        .map(ExamCategoryModel.fromJson)
        .toList();
  }

  /// 接口2：获取子类别（年份），过滤 Level=3 且 Year 不为空
  Future<List<ExamYearModel>> getYears({
    required String examTypeStyleId,
    required String code,
    required String departmentId,
    required String unitId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.getAllChildTypeEx,
      data: {
        'Style': EsdtEncryption.encrypt(examTypeStyleId),
        'Code': EsdtEncryption.encrypt(code),
        'DepartmentId': EsdtEncryption.encrypt(departmentId),
        'unitids': EsdtEncryption.encrypt(unitId),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data
        .cast<Map<String, dynamic>>()
        .where(ExamYearModel.isValid)
        .map(ExamYearModel.fromJson)
        .toList();
  }

  /// 接口3：获取题库列表
  Future<List<ExamLibraryModel>> getLibraries({
    required String year,
    required String examTypeStyleId,
    required String departmentId,
    required String unitId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.getExamTypeListExOne,
      queryParameters: {
        'Year': year,
        'Style': examTypeStyleId,
        'DepartmentId': EsdtEncryption.encrypt(departmentId),
        'unitids': EsdtEncryption.encrypt(unitId),
        'cname': '^',
        'page': '1',
        'rows': '50',
      },
    );
    final data = response.data?['data'] as List<dynamic>? ?? [];
    return data
        .cast<Map<String, dynamic>>()
        .map(ExamLibraryModel.fromJson)
        .toList();
  }

  /// 接口4：设置题库
  Future<void> saveLibrary({
    required String pid,
    required String examTypeId,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.saveExamTypeIdsOne,
      data: {
        'pid': EsdtEncryption.encrypt(pid),
        'ExamTypeIds': EsdtEncryption.encrypt(examTypeId),
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {'X-Requested-With': 'XMLHttpRequest'},
        responseType: ResponseType.plain,
      ),
    );
    final raw = response.data;
    final Map<String, dynamic> map = raw is String
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : raw is Map
            ? Map<String, dynamic>.from(raw)
            : {};
    final success = map['success'] as bool? ?? false;
    if (!success) {
      final msg = map['message'] as String? ?? '设置题库失败';
      throw Exception(msg);
    }
  }
  /// 接口5：获取当前题库名称（返回 "examTypeId|examTypeName" 或 null）
  Future<String?> getCurrentLibraryName({required String pid}) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.getCurExamTypeOne,
      data: {'pid': EsdtEncryption.encrypt(pid)},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {'X-Requested-With': 'XMLHttpRequest'},
        responseType: ResponseType.plain,
      ),
    );
    final raw = response.data;
    final Map<String, dynamic> map = raw is String
        ? Map<String, dynamic>.from(jsonDecode(raw) as Map)
        : raw is Map
            ? Map<String, dynamic>.from(raw)
            : {};
    final success = map['success'] as bool? ?? false;
    if (!success) return null;
    return map['data'] as String?;
  }
}

@riverpod
ExamRemoteDataSource examRemoteDataSource(Ref ref) {
  return ExamRemoteDataSource(ref.watch(dioClientProvider));
}
