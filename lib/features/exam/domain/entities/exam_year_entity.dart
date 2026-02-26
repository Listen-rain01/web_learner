/// 年份实体（来自 GetAllChildTypeEx，Level=3 且 Year 不为空）
class ExamYearEntity {
  const ExamYearEntity({
    required this.year,
    required this.styleName,
    required this.departmentId,
  });

  /// 年份值，如 "2024"
  final String year;

  /// 显示名称，如 "2024年"
  final String styleName;

  final String departmentId;
}
