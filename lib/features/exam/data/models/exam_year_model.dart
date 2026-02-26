import '../../domain/entities/exam_year_entity.dart';

/// 年份数据模型
class ExamYearModel extends ExamYearEntity {
  const ExamYearModel({
    required super.year,
    required super.styleName,
    required super.departmentId,
  });

  factory ExamYearModel.fromJson(Map<String, dynamic> json) {
    return ExamYearModel(
      year: json['Year'] as String? ?? '',
      styleName: json['StyleName'] as String? ?? '',
      departmentId: json['DepartmentId'] as String? ?? '',
    );
  }

  /// 过滤有效数据：Level=3 且 Year 不为空
  static bool isValid(Map<String, dynamic> json) {
    return (json['Level'] as num?)?.toInt() == 3 &&
        (json['Year'] as String?)?.isNotEmpty == true;
  }
}
