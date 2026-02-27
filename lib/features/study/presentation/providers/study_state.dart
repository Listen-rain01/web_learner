import '../../domain/entities/knowledge_type_entity.dart';
import '../../domain/entities/study_material_entity.dart';

enum StudyStep { typeList, childTypeList, materialList }

class StudyState {
  const StudyState({
    this.step = StudyStep.typeList,
    this.types = const [],
    this.childTypes = const [],
    this.materials = const [],
    this.selectedType,
    this.selectedChildType,
    this.isLoading = false,
    this.errorMessage,
    this.readingResult,
  });

  final StudyStep step;
  final List<KnowledgeTypeEntity> types;
  final List<KnowledgeTypeEntity> childTypes;
  final List<StudyMaterialEntity> materials;
  final KnowledgeTypeEntity? selectedType;
  final KnowledgeTypeEntity? selectedChildType;
  final bool isLoading;
  final String? errorMessage;

  /// null = 未操作, true = 成功, false = 失败/已达上限
  final String? readingResult;

  StudyState copyWith({
    StudyStep? step,
    List<KnowledgeTypeEntity>? types,
    List<KnowledgeTypeEntity>? childTypes,
    List<StudyMaterialEntity>? materials,
    KnowledgeTypeEntity? selectedType,
    KnowledgeTypeEntity? selectedChildType,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? readingResult,
    bool clearReadingResult = false,
  }) {
    return StudyState(
      step: step ?? this.step,
      types: types ?? this.types,
      childTypes: childTypes ?? this.childTypes,
      materials: materials ?? this.materials,
      selectedType: selectedType ?? this.selectedType,
      selectedChildType: selectedChildType ?? this.selectedChildType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      readingResult: clearReadingResult ? null : readingResult ?? this.readingResult,
    );
  }
}
