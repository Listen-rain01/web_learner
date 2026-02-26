import '../../domain/entities/exam_library_entity.dart';

/// 题库数据模型
class ExamLibraryModel extends ExamLibraryEntity {
  const ExamLibraryModel({
    required super.examTypeId,
    required super.examTypeName,
    required super.departmentName,
    required super.questionCount,
    required super.oneQuestionCount,
    required super.moreQuestionCount,
    required super.checkQuestionCount,
  });

  factory ExamLibraryModel.fromJson(Map<String, dynamic> json) {
    return ExamLibraryModel(
      examTypeId: json['ExamTypeId'] as String? ?? '',
      examTypeName: json['ExamTypeName'] as String? ?? '',
      departmentName: json['DepartmentName'] as String? ?? '',
      questionCount: (json['QuestionCount'] as num?)?.toInt() ?? 0,
      oneQuestionCount: (json['OneQuestionCount'] as num?)?.toInt() ?? 0,
      moreQuestionCount: (json['MoreQuestionCount'] as num?)?.toInt() ?? 0,
      checkQuestionCount: (json['CheckQuestionCount'] as num?)?.toInt() ?? 0,
    );
  }
}
