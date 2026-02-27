import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/home_info_provider.dart';
import '../../domain/entities/accumulate_entity.dart';
import '../providers/accumulate_provider.dart';
import '../providers/accumulate_state.dart';

class AccumulatePage extends ConsumerWidget {
  const AccumulatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accumulateProvider);
    final homeInfo = ref.watch(homeInfoProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait<void>([
            ref.read(accumulateProvider.notifier).refresh(),
            ref.read(homeInfoProvider.notifier).refresh(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            _HomeInfoHeader(homeInfo: homeInfo),
            // 积分任务列表
            if (state.isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null)
              SliverFillRemaining(
                child: _ErrorView(
                  message: state.errorMessage!,
                  onRetry: () => ref.invalidate(accumulateProvider),
                ),
              )
            else
              _TaskList(state: state),
          ],
        ),
      ),
    );
  }
}

// ── 顶部信息头 ────────────────────────────────────────────────

class _HomeInfoHeader extends StatelessWidget {
  const _HomeInfoHeader({required this.homeInfo});
  final HomeInfo? homeInfo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.tertiary,
            ],
          ),
        ),
        padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        homeInfo?.userName ?? '',
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 14,
                            color: colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              homeInfo?.currentLibraryName ?? '加载中...',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimary.withValues(alpha: 0.8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        homeInfo?.todayScore ?? '-',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '今日积分',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('重试')),
          ],
        ),
      ),
    );
  }
}

// ── 任务列表 ──────────────────────────────────────────────────

class _TaskList extends StatelessWidget {
  const _TaskList({required this.state});
  final AccumulateState state;

  @override
  Widget build(BuildContext context) {
    if (state.items.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            '暂无积分任务',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      sliver: SliverList.separated(
        itemCount: state.items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) =>
            _TaskCard(item: state.items[index]),
      ),
    );
  }
}

// ── 任务卡片 ──────────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.item});
  final AccumulateEntity item;

  static const _criterionIcons = <String, IconData>{
    'CheckIn': Icons.login_outlined,
    'StudyKnowledge': Icons.menu_book_outlined,
    'Course': Icons.play_circle_outline,
    'MobileExercises': Icons.edit_note_outlined,
    'StudyTime': Icons.timer_outlined,
    'MockExam': Icons.assignment_outlined,
    'MobileExam': Icons.quiz_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final icon = _criterionIcons[item.criterion] ?? Icons.star_outline;
    final progress = item.maxAccumulate > 0
        ? (item.curAccumulate / item.maxAccumulate).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.isCompleted
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.isCompleted
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: item.isCompleted
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.accumulateName,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.curAccumulateState.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.curAccumulateState,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${item.curAccumulate}/${item.maxAccumulate}分',
                style: textTheme.labelMedium?.copyWith(
                  color: item.isCompleted
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                item.isCompleted ? colorScheme.primary : colorScheme.secondary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.accumulateRule,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton(
                onPressed: item.isCompleted ? null : () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(_buttonLabel(item.criterion, item.isCompleted)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buttonLabel(String criterion, bool completed) {
    switch (criterion) {
      case 'CheckIn':
        return completed ? '已签到' : '去签到';
      case 'StudyKnowledge':
      case 'Course':
        return completed ? '已学习' : '去学习';
      default:
        return completed ? '已完成' : '去练习';
    }
  }
}
