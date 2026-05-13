import 'package:flutter/material.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';
import 'package:web_learner/features/announcement/presentation/announcement_ui_tokens.dart';

class AnnouncementListSheet extends StatelessWidget {
  const AnnouncementListSheet({
    required this.announcements,
    super.key,
  });

  final List<Announcement> announcements;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardBackground = colorScheme.primary.withValues(
      alpha: AnnouncementUiTokens.surfaceTintOpacity,
    );
    final cardBorder = colorScheme.primary.withValues(
      alpha: AnnouncementUiTokens.outlineOpacity,
    );

    return SafeArea(
      child: Padding(
        padding: AnnouncementUiTokens.sheetPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '公告列表',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: announcements.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AnnouncementUiTokens.listItemGap),
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return Card(
                    color: cardBackground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AnnouncementUiTokens.itemRadius,
                      ),
                      side: BorderSide(color: cardBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  announcement.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (announcement.isPinned)
                                Container(
                                  padding: AnnouncementUiTokens.badgePadding,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(
                                      AnnouncementUiTokens.badgeRadius,
                                    ),
                                  ),
                                  child: Text(
                                    '置顶',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _formatUpdatedAt(announcement.updatedAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AnnouncementUiTokens.contentGap),
                          Text(
                            announcement.content.trim(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatUpdatedAt(DateTime value) {
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '更新时间 $month-$day $hour:$minute';
  }
}
