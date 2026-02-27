import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/knowledge_type_entity.dart';
import '../../domain/entities/study_material_entity.dart';
import '../providers/study_provider.dart' show studyProvider;
import '../providers/study_state.dart';

/// 阅读学习区块，嵌入 ExamPage 占位区域
class StudySection extends ConsumerWidget {
  const StudySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 显示完成阅读结果 snackbar
    ref.listen(studyProvider.select((s) => s.readingResult), (_, result) {
      if (result == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
      ref.read(studyProvider.notifier).clearReadingResult();
    });

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              children: [
                Icon(Icons.menu_book_outlined, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '阅读学习',
                  style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const Spacer(),
                if (state.step != StudyStep.typeList)
                  TextButton.icon(
                    onPressed: () => ref.read(studyProvider.notifier).goBack(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 14),
                    label: const Text('返回'),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 12),
          // 内容区
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.errorMessage != null)
            _ErrorView(
              message: state.errorMessage!,
              onRetry: () => ref.invalidate(studyProvider),
            )
          else
            _StepContent(state: state),
        ],
      ),
    );
  }
}

// ── 错误视图 ──────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('重试')),
        ],
      ),
    );
  }
}

// ── 步骤内容 ──────────────────────────────────────────────────

class _StepContent extends ConsumerWidget {
  const _StepContent({required this.state});
  final StudyState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (state.step) {
      case StudyStep.typeList:
        return _TypeList(types: state.types);
      case StudyStep.childTypeList:
        return _TypeList(types: state.childTypes);
      case StudyStep.materialList:
        return _MaterialList(materials: state.materials);
    }
  }
}

// ── 类型列表（一级 / 子分类共用） ─────────────────────────────

class _TypeList extends ConsumerWidget {
  const _TypeList({required this.types});
  final List<KnowledgeTypeEntity> types;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = ref.read(studyProvider.notifier);
    final isChild = ref.read(studyProvider).step == StudyStep.childTypeList;

    if (types.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            '暂无数据',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: types.map((type) {
          return ActionChip(
            label: Text(type.typeName),
            onPressed: () => isChild
                ? notifier.selectChildType(type)
                : notifier.selectType(type),
          );
        }).toList(),
      ),
    );
  }
}

// ── 资料列表 ──────────────────────────────────────────────────

class _MaterialList extends ConsumerWidget {
  const _MaterialList({required this.materials});
  final List<StudyMaterialEntity> materials;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (materials.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text('暂无学习资料', style: TextStyle(color: colorScheme.onSurfaceVariant)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: materials.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 16),
      itemBuilder: (context, index) {
        final m = materials[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(Icons.article_outlined, color: colorScheme.primary),
          title: Text(m.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            '阅读 ${m.readCount} 次  ·  ${m.createTime.split(' ').first}',
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showMaterialSheet(context, ref, m),
        );
      },
    );
  }

  void _showMaterialSheet(BuildContext context, WidgetRef ref, StudyMaterialEntity m) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _MaterialSheet(material: m, ref: ref),
    );
  }
}

// ── 资料详情底部弹窗 ──────────────────────────────────────────

class _MaterialSheet extends StatelessWidget {
  const _MaterialSheet({required this.material, required this.ref});
  final StudyMaterialEntity material;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(material.title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            '创建时间：${material.createTime}',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          Text(
            '阅读次数：${material.readCount}',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('完成阅读'),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(studyProvider.notifier).completeReading(material);
              },
            ),
          ),
        ],
      ),
    );
  }
}
