import '../../domain/entities/study_material_entity.dart';

class StudyMaterialModel extends StudyMaterialEntity {
  const StudyMaterialModel({
    required super.knowledgeSubjectId,
    required super.title,
    required super.rootUrl,
    super.imageUrl,
    required super.readCount,
    required super.createTime,
  });

  factory StudyMaterialModel.fromJson(Map<String, dynamic> json) {
    return StudyMaterialModel(
      knowledgeSubjectId: json['KnowledgeSubjectId'] as String? ?? '',
      title: json['Title'] as String? ?? '',
      rootUrl: json['RootUrl'] as String? ?? '',
      imageUrl: json['ImageUrl'] as String?,
      readCount: json['ReadCount'] as int? ?? 0,
      createTime: json['CreateTime'] as String? ?? '',
    );
  }
}
