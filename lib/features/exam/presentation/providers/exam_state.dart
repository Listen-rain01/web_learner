import '../../domain/entities/exam_category_entity.dart';
import '../../domain/entities/exam_library_entity.dart';
import '../../domain/entities/exam_year_entity.dart';
import '../../domain/entities/unit_entity.dart';

/// 题库切换流程步骤
enum ExamSelectionStep { unit, category, year, library }

/// 题库页面状态
class ExamState {
  const ExamState({
    this.currentLibrary,
    this.currentLibraryName,
    this.isLoading = false,
    this.errorMessage,
    // 级联选择中间状态
    this.units = const [],
    this.allUnitIds = '',
    this.categories = const [],
    this.years = const [],
    this.libraries = const [],
    this.selectedUnit,
    this.selectedCategory,
    this.selectedYear,
    this.selectionStep = ExamSelectionStep.unit,
    this.selectionLoading = false,
  });

  /// 当前已设置的题库
  final ExamLibraryEntity? currentLibrary;

  /// 从服务器加载的当前题库名称（格式 "examTypeId|examTypeName"）
  final String? currentLibraryName;

  /// 页面整体加载状态
  final bool isLoading;

  /// 错误信息
  final String? errorMessage;

  // ── 级联选择数据 ──
  final List<UnitEntity> units;

  /// 所有单位 ID 逗号拼接（用于 GetAllChildTypeEx 和 GetExamTypeListExOne 的 unitids 参数）
  final String allUnitIds;
  final List<ExamCategoryEntity> categories;
  final List<ExamYearEntity> years;
  final List<ExamLibraryEntity> libraries;

  final UnitEntity? selectedUnit;
  final ExamCategoryEntity? selectedCategory;
  final ExamYearEntity? selectedYear;

  /// 当前级联步骤
  final ExamSelectionStep selectionStep;

  /// 级联列表加载中
  final bool selectionLoading;

  ExamState copyWith({
    ExamLibraryEntity? currentLibrary,
    String? currentLibraryName,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    List<UnitEntity>? units,
    String? allUnitIds,
    List<ExamCategoryEntity>? categories,
    List<ExamYearEntity>? years,
    List<ExamLibraryEntity>? libraries,
    UnitEntity? selectedUnit,
    ExamCategoryEntity? selectedCategory,
    ExamYearEntity? selectedYear,
    ExamSelectionStep? selectionStep,
    bool? selectionLoading,
  }) {
    return ExamState(
      currentLibrary: currentLibrary ?? this.currentLibrary,
      currentLibraryName: currentLibraryName ?? this.currentLibraryName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      units: units ?? this.units,
      allUnitIds: allUnitIds ?? this.allUnitIds,
      categories: categories ?? this.categories,
      years: years ?? this.years,
      libraries: libraries ?? this.libraries,
      selectedUnit: selectedUnit ?? this.selectedUnit,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedYear: selectedYear ?? this.selectedYear,
      selectionStep: selectionStep ?? this.selectionStep,
      selectionLoading: selectionLoading ?? this.selectionLoading,
    );
  }
}
