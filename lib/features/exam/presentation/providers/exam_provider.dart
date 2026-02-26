import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/user_session_provider.dart';
import '../../data/repositories/exam_repository_impl.dart';
import '../../domain/entities/exam_category_entity.dart';
import '../../domain/entities/exam_library_entity.dart';
import '../../domain/entities/exam_year_entity.dart';
import '../../domain/entities/unit_entity.dart';
import 'exam_state.dart';

part 'exam_provider.g.dart';

@riverpod
class ExamNotifier extends _$ExamNotifier {
  @override
  ExamState build() {
    _loadCurrentLibrary();
    return const ExamState(isLoading: true);
  }

  String get _pid => ref.read(userSessionProvider)?.userId ?? '';

  Future<void> _loadCurrentLibrary() async {
    try {
      final name = await ref
          .read(examRepositoryProvider)
          .getCurrentLibraryName(pid: _pid);
      state = state.copyWith(currentLibraryName: name, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 打开切换弹窗时调用：重置并加载单位列表
  Future<void> resetSelection() async {
    state = state.copyWith(
      selectionStep: ExamSelectionStep.unit,
      units: [],
      categories: [],
      years: [],
      libraries: [],
      selectionLoading: true,
      clearError: true,
    );
    try {
      final units = await ref
          .read(examRepositoryProvider)
          .getUnits(pid: _pid);
      final allUnitIds = units.map((u) => u.id).join(',');
      state = state.copyWith(units: units, allUnitIds: allUnitIds, selectionLoading: false);
    } catch (e) {
      state = state.copyWith(
        selectionLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// 用户选择单位 → 加载考试类别
  Future<void> selectUnit(UnitEntity unit) async {
    state = state.copyWith(
      selectedUnit: unit,
      selectionStep: ExamSelectionStep.category,
      selectionLoading: true,
      clearError: true,
    );
    try {
      final categories = await ref
          .read(examRepositoryProvider)
          .getCategories(pid: _pid, unitId: unit.id);
      state = state.copyWith(categories: categories, selectionLoading: false);
    } catch (e) {
      state = state.copyWith(
        selectionLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// 用户选择考试类别 → 加载年份
  Future<void> selectCategory(ExamCategoryEntity category) async {
    state = state.copyWith(
      selectedCategory: category,
      selectionStep: ExamSelectionStep.year,
      selectionLoading: true,
      clearError: true,
    );
    try {
      final years = await ref.read(examRepositoryProvider).getYears(
            examTypeStyleId: category.examTypeStyleId.toString(),
            code: category.code,
            departmentId: category.departmentId,
            unitId: state.allUnitIds,
          );
      state = state.copyWith(years: years, selectionLoading: false);
    } catch (e) {
      state = state.copyWith(
        selectionLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// 用户选择年份 → 加载题库列表
  Future<void> selectYear(ExamYearEntity year) async {
    state = state.copyWith(
      selectedYear: year,
      selectionStep: ExamSelectionStep.library,
      selectionLoading: true,
      clearError: true,
    );
    try {
      final category = state.selectedCategory!;
      final libraries = await ref.read(examRepositoryProvider).getLibraries(
            year: year.year,
            examTypeStyleId: category.examTypeStyleId.toString(),
            departmentId: year.departmentId,
            unitId: state.allUnitIds,
          );
      state = state.copyWith(libraries: libraries, selectionLoading: false);
    } catch (e) {
      state = state.copyWith(
        selectionLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// 用户选择题库 → 保存并更新当前题库
  Future<bool> selectLibrary(ExamLibraryEntity library) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref.read(examRepositoryProvider).saveLibrary(
            pid: _pid,
            examTypeId: library.examTypeId,
          );
      state = state.copyWith(
        currentLibrary: library,
        currentLibraryName: '${library.examTypeId}|${library.examTypeName}',
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  /// 返回上一步
  void goBack() {
    final prev = ExamSelectionStep.values[state.selectionStep.index - 1];
    state = state.copyWith(selectionStep: prev);
  }
}
