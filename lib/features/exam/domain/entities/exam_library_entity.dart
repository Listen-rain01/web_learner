/// 题库实体（来自 GetExamTypeListExOne）
class ExamLibraryEntity {
  const ExamLibraryEntity({
    required this.examTypeId,
    required this.examTypeName,
    required this.departmentName,
    required this.questionCount,
    required this.oneQuestionCount,
    required this.moreQuestionCount,
    required this.checkQuestionCount,
  });

  /// 题库 ID
  final String examTypeId;

  /// 题库名称
  final String examTypeName;

  /// 所属部门名称
  final String departmentName;

  /// 总题数
  final int questionCount;

  /// 单选题数
  final int oneQuestionCount;

  /// 多选题数
  final int moreQuestionCount;

  /// 判断题数
  final int checkQuestionCount;
}
