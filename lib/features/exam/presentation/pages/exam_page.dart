import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/exam_category_entity.dart';
import '../../domain/entities/exam_library_entity.dart';
import '../../domain/entities/exam_year_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../providers/exam_provider.dart';
import '../providers/exam_state.dart';
import '../../../../features/study/presentation/widgets/study_section.dart';

/// 题库页面
class ExamPage extends ConsumerWidget {
  const ExamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examState = ref.watch(examProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
        children: [
          // 当前题库卡片
          _CurrentLibraryCard(
            library: examState.currentLibrary,
            currentLibraryName: examState.currentLibraryName,
            isLoading: examState.isLoading,
            onSwitch: () => _showSelectionSheet(context, ref),
          ),

          const SizedBox(height: 16),

          // 阅读学习区块
          const StudySection(),
        ],
      ),
    );
  }

  void _showSelectionSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _SelectionSheet(),
    );
  }
}

// ── 当前题库卡片 ──────────────────────────────────────────────

class _CurrentLibraryCard extends StatelessWidget {
  const _CurrentLibraryCard({
    required this.library,
    required this.currentLibraryName,
    required this.isLoading,
    required this.onSwitch,
  });

  final ExamLibraryEntity? library;
  final String? currentLibraryName;
  final bool isLoading;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '当前题库',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (library != null) ...[
            Text(
              library!.examTypeName,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              library!.departmentName,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatChip(label: '单选', count: library!.oneQuestionCount),
                const SizedBox(width: 8),
                _StatChip(label: '多选', count: library!.moreQuestionCount),
                const SizedBox(width: 8),
                _StatChip(label: '判断', count: library!.checkQuestionCount),
                const Spacer(),
                Text(
                  '共 ${library!.questionCount} 题',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ] else if (currentLibraryName != null) ...[
            Text(
              currentLibraryName!.split('|').last,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else
            Text(
              '未选择题库',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: onSwitch,
              child: const Text('切换题库'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.count});
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label $count',
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

// ── 级联选择底部弹窗 ──────────────────────────────────────────

class _SelectionSheet extends ConsumerStatefulWidget {
  const _SelectionSheet();

  @override
  ConsumerState<_SelectionSheet> createState() => _SelectionSheetState();
}

class _SelectionSheetState extends ConsumerState<_SelectionSheet> {
  static const _stepLabels = ['单位', '类别', '年份', '题库'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(examProvider.notifier).resetSelection();
    });
  }

  @override
  Widget build(BuildContext context) {
    final examState = ref.watch(examProvider);
    final stepIndex = examState.selectionStep.index;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (sheetContext, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (stepIndex > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () =>
                          ref.read(examProvider.notifier).goBack(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (stepIndex > 0) const SizedBox(width: 8),
                  Text(
                    '选择${_stepLabels[stepIndex]}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  _StepBreadcrumb(step: examState.selectionStep),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            if (examState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  examState.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
                ),
              ),
            Expanded(
              child: examState.selectionLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _StepList(
                      examState: examState,
                      scrollController: scrollController,
                      onClose: () => Navigator.of(context).pop(),
                      onSuccess: () {
                        final messenger = ScaffoldMessenger.of(context);
                        Navigator.of(context).pop();
                        messenger.showSnackBar(
                          const SnackBar(content: Text('题库设置成功')),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _StepBreadcrumb extends StatelessWidget {
  const _StepBreadcrumb({required this.step});
  final ExamSelectionStep step;

  static const _labels = ['单位', '类别', '年份', '题库'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final current = step.index;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Icon(Icons.chevron_right, size: 14,
              color: colorScheme.outlineVariant);
        }
        final idx = i ~/ 2;
        final active = idx == current;
        return Text(
          _labels[idx],
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        );
      }),
    );
  }
}

class _StepList extends ConsumerWidget {
  const _StepList({
    required this.examState,
    required this.scrollController,
    required this.onClose,
    required this.onSuccess,
  });

  final ExamState examState;
  final ScrollController scrollController;
  final VoidCallback onClose;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (examState.selectionStep) {
      case ExamSelectionStep.unit:
        return _buildList<UnitEntity>(
          context: context,
          items: examState.units,
          emptyLabel: '暂无可用单位',
          labelOf: (e) => e.name,
          subtitleOf: (_) => null,
          onTap: (e) => ref.read(examProvider.notifier).selectUnit(e),
        );
      case ExamSelectionStep.category:
        return _buildList<ExamCategoryEntity>(
          context: context,
          items: examState.categories,
          emptyLabel: '暂无考试类别',
          labelOf: (e) => e.styleName,
          subtitleOf: (_) => null,
          onTap: (e) => ref.read(examProvider.notifier).selectCategory(e),
        );
      case ExamSelectionStep.year:
        return _buildList<ExamYearEntity>(
          context: context,
          items: examState.years,
          emptyLabel: '暂无年份数据',
          labelOf: (e) => e.styleName,
          subtitleOf: (_) => null,
          onTap: (e) => ref.read(examProvider.notifier).selectYear(e),
        );
      case ExamSelectionStep.library:
        return _buildList<ExamLibraryEntity>(
          context: context,
          items: examState.libraries,
          emptyLabel: '该年份暂无题库',
          labelOf: (e) => e.examTypeName,
          subtitleOf: (e) => '${e.departmentName}  共 ${e.questionCount} 题',
          onTap: (e) async {
            final ok = await ref.read(examProvider.notifier).selectLibrary(e);
            if (ok && context.mounted) {
              onSuccess();
            }
          },
        );
    }
  }

  Widget _buildList<T>({
    required BuildContext context,
    required List<T> items,
    required String emptyLabel,
    required String Function(T) labelOf,
    required String? Function(T) subtitleOf,
    required void Function(T) onTap,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }
    return ListView.separated(
      controller: scrollController,
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        final subtitle = subtitleOf(item);
        return ListTile(
          title: Text(labelOf(item)),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onTap(item),
        );
      },
    );
  }
}
