import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/user_session_provider.dart';
import '../../data/repositories/study_repository_impl.dart';
import '../../domain/entities/knowledge_type_entity.dart';
import '../../domain/entities/study_material_entity.dart';
import 'study_state.dart';

part 'study_provider.g.dart';

@riverpod
class StudyNotifier extends _$StudyNotifier {
  @override
  StudyState build() {
    _loadTypes();
    return const StudyState(isLoading: true);
  }

  String get _pid => ref.read(userSessionProvider)?.userId ?? '';

  Future<void> _loadTypes() async {
    try {
      final types = await ref.read(studyRepositoryProvider).getTypes(pid: _pid);
      state = state.copyWith(types: types, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// 用户选择一级类型 → 加载子分类，若无子分类直接加载资料
  Future<void> selectType(KnowledgeTypeEntity type) async {
    state = state.copyWith(
      selectedType: type,
      isLoading: true,
      clearError: true,
    );
    try {
      final children = await ref.read(studyRepositoryProvider).getChildTypes(
            typeId: type.knowledgeTypeId,
            departmentId: type.departmentId,
          );
      if (children.isNotEmpty) {
        state = state.copyWith(
          step: StudyStep.childTypeList,
          childTypes: children,
          isLoading: false,
        );
      } else {
        // 无子分类，直接加载资料
        await _loadMaterials(
          typeId: type.knowledgeTypeId,
          departmentId: type.departmentId,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// 用户选择子分类 → 加载资料
  Future<void> selectChildType(KnowledgeTypeEntity childType) async {
    state = state.copyWith(
      selectedChildType: childType,
      isLoading: true,
      clearError: true,
    );
    await _loadMaterials(
      typeId: childType.knowledgeTypeId,
      departmentId: childType.departmentId,
    );
  }

  Future<void> _loadMaterials({
    required String typeId,
    required String departmentId,
  }) async {
    try {
      final materials = await ref.read(studyRepositoryProvider).getMaterials(
            typeId: typeId,
            departmentId: departmentId,
            pid: _pid,
          );
      state = state.copyWith(
        step: StudyStep.materialList,
        materials: materials,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// 完成阅读
  Future<void> completeReading(StudyMaterialEntity material) async {
    try {
      final success = await ref.read(studyRepositoryProvider).completeReading(
            pid: _pid,
            subjectId: material.knowledgeSubjectId,
          );
      state = state.copyWith(
        readingResult: success ? '阅读完成，已获得学分！' : '今日完成阅读次数已满，请明天再来',
      );
    } catch (e) {
      state = state.copyWith(
        readingResult: '操作失败：${e.toString().replaceFirst('Exception: ', '')}',
      );
    }
  }

  void clearReadingResult() => state = state.copyWith(clearReadingResult: true);

  /// 返回上一步
  void goBack() {
    if (state.step == StudyStep.materialList) {
      final hasChildren = state.childTypes.isNotEmpty;
      state = state.copyWith(
        step: hasChildren ? StudyStep.childTypeList : StudyStep.typeList,
        materials: [],
        clearError: true,
      );
    } else if (state.step == StudyStep.childTypeList) {
      state = state.copyWith(
        step: StudyStep.typeList,
        childTypes: [],
        clearError: true,
      );
    }
  }
}
