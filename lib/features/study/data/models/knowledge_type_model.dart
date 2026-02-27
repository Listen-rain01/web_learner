import '../../domain/entities/knowledge_type_entity.dart';

class KnowledgeTypeModel extends KnowledgeTypeEntity {
  const KnowledgeTypeModel({
    required super.knowledgeTypeId,
    required super.typeName,
    required super.departmentId,
  });

  factory KnowledgeTypeModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeTypeModel(
      knowledgeTypeId: json['KnowledgeTypeId'] as String? ?? '',
      typeName: json['TypeName'] as String? ?? '',
      departmentId: json['DepartmentId'] as String? ?? '1',
    );
  }
}
