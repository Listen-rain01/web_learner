import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/features/announcement/application/announcement_controller.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';
import 'package:web_learner/features/announcement/presentation/announcement_ui_tokens.dart';
import 'package:web_learner/features/announcement/presentation/widgets/announcement_list_sheet.dart';

class LoginAnnouncementCard extends ConsumerWidget {
  const LoginAnnouncementCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementAsync = ref.watch(loginAnnouncementsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardBackground = colorScheme.primary.withValues(
      alpha: AnnouncementUiTokens.surfaceTintOpacity,
    );
    final cardBorder = colorScheme.primary.withValues(
      alpha: AnnouncementUiTokens.outlineOpacity,
    );

    return announcementAsync.when(
      data: (announcements) {
        if (announcements.isEmpty) {
          return const SizedBox.shrink();
        }

        final primary = announcements.first;
        return Padding(
          padding: AnnouncementUiTokens.cardMargin,
          child: Card(
            color: cardBackground,
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AnnouncementUiTokens.cardRadius,
              ),
              side: BorderSide(color: cardBorder),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(
                AnnouncementUiTokens.cardRadius,
              ),
              onTap: () => _showAnnouncementSheet(context, announcements),
              child: Padding(
                padding: AnnouncementUiTokens.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '系统公告',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (primary.isPinned)
                          _PinnedBadge(theme: theme),
                      ],
                    ),
                    const SizedBox(height: AnnouncementUiTokens.headerGap),
                    Text(
                      primary.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AnnouncementUiTokens.contentGap),
                    Text(
                      primary.previewText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: AnnouncementUiTokens.actionGap),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            _showAnnouncementSheet(context, announcements),
                        child: Text(
                          announcements.length > 1 ? '查看全部' : '查看详情',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () {
        return Padding(
          padding: AnnouncementUiTokens.cardMargin,
          child: Card(
            color: cardBackground,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AnnouncementUiTokens.cardRadius,
              ),
              side: BorderSide(color: cardBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '正在加载公告...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  void _showAnnouncementSheet(
    BuildContext context,
    List<Announcement> announcements,
  ) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: AnnouncementListSheet(
              announcements: announcements,
            ),
          );
        },
      ),
    );
  }
}

class _PinnedBadge extends StatelessWidget {
  const _PinnedBadge({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AnnouncementUiTokens.badgePadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AnnouncementUiTokens.badgeRadius),
      ),
      child: Text(
        '置顶',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
