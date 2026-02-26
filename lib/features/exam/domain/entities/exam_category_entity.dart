/// 考试类别实体（来自 GetAllTypeEx）
class ExamCategoryEntity {
  const ExamCategoryEntity({
    required this.examTypeStyleId,
    required this.styleName,
    required this.code,
    required this.departmentId,
  });

  final int examTypeStyleId;
  final String styleName;
  final String code;
  final String departmentId;
}
