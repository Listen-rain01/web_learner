import '../../domain/entities/exam_category_entity.dart';

/// 考试类别数据模型
class ExamCategoryModel extends ExamCategoryEntity {
  const ExamCategoryModel({
    required super.examTypeStyleId,
    required super.styleName,
    required super.code,
    required super.departmentId,
  });

  factory ExamCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExamCategoryModel(
      examTypeStyleId: (json['ExamTypeStyleId'] as num).toInt(),
      styleName: json['StyleName'] as String? ?? '',
      code: json['Code'] as String? ?? '',
      departmentId: json['DepartmentId'] as String? ?? '',
    );
  }
}
