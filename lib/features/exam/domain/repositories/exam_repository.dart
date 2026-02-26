import '../../domain/entities/exam_category_entity.dart';
import '../../domain/entities/exam_library_entity.dart';
import '../../domain/entities/exam_year_entity.dart';
import '../../domain/entities/unit_entity.dart';

abstract class ExamRepository {
  Future<List<UnitEntity>> getUnits({required String pid});

  Future<List<ExamCategoryEntity>> getCategories({
    required String pid,
    required String unitId,
  });

  Future<List<ExamYearEntity>> getYears({
    required String examTypeStyleId,
    required String code,
    required String departmentId,
    required String unitId,
  });

  Future<List<ExamLibraryEntity>> getLibraries({
    required String year,
    required String examTypeStyleId,
    required String departmentId,
    required String unitId,
  });

  Future<void> saveLibrary({
    required String pid,
    required String examTypeId,
  });

  Future<String?> getCurrentLibraryName({required String pid});
}
