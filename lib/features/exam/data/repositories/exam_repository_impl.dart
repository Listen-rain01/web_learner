import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/exam_remote_datasource.dart';
import '../../domain/entities/exam_category_entity.dart';
import '../../domain/entities/exam_library_entity.dart';
import '../../domain/entities/exam_year_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/repositories/exam_repository.dart';

part 'exam_repository_impl.g.dart';

class ExamRepositoryImpl implements ExamRepository {
  const ExamRepositoryImpl(this._dataSource);

  final ExamRemoteDataSource _dataSource;

  @override
  Future<List<UnitEntity>> getUnits({required String pid}) =>
      _dataSource.getUnits(pid: pid);

  @override
  Future<List<ExamCategoryEntity>> getCategories({
    required String pid,
    required String unitId,
  }) =>
      _dataSource.getCategories(pid: pid, unitId: unitId);

  @override
  Future<List<ExamYearEntity>> getYears({
    required String examTypeStyleId,
    required String code,
    required String departmentId,
    required String unitId,
  }) =>
      _dataSource.getYears(
        examTypeStyleId: examTypeStyleId,
        code: code,
        departmentId: departmentId,
        unitId: unitId,
      );

  @override
  Future<List<ExamLibraryEntity>> getLibraries({
    required String year,
    required String examTypeStyleId,
    required String departmentId,
    required String unitId,
  }) =>
      _dataSource.getLibraries(
        year: year,
        examTypeStyleId: examTypeStyleId,
        departmentId: departmentId,
        unitId: unitId,
      );

  @override
  Future<void> saveLibrary({
    required String pid,
    required String examTypeId,
  }) =>
      _dataSource.saveLibrary(pid: pid, examTypeId: examTypeId);

  @override
  Future<String?> getCurrentLibraryName({required String pid}) =>
      _dataSource.getCurrentLibraryName(pid: pid);
}

@riverpod
ExamRepository examRepository(Ref ref) {
  return ExamRepositoryImpl(ref.watch(examRemoteDataSourceProvider));
}
