import '../entities/knowledge_type_entity.dart';
import '../entities/study_material_entity.dart';

abstract class StudyRepository {
  Future<List<KnowledgeTypeEntity>> getTypes({required String pid});

  Future<List<KnowledgeTypeEntity>> getChildTypes({
    required String typeId,
    required String departmentId,
  });

  Future<List<StudyMaterialEntity>> getMaterials({
    required String typeId,
    required String departmentId,
    required String pid,
  });

  Future<bool> completeReading({
    required String pid,
    required String subjectId,
  });
}
