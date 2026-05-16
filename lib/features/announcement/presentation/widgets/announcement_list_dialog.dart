import 'package:flutter/material.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';
import 'package:web_learner/features/announcement/presentation/announcement_ui_tokens.dart';

class AnnouncementListDialog extends StatelessWidget {
  const AnnouncementListDialog({
    required this.announcements,
    super.key,
  });

  final List<Announcement> announcements;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dividerColor = colorScheme.outlineVariant.withValues(alpha: 0.85);

    return Dialog(
      insetPadding: AnnouncementUiTokens.dialogInset,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
          maxHeight: 620,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: Column(
                children: [
                  Text(
                    '公告',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: dividerColor),
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: announcements.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: dividerColor,
                ),
                itemBuilder: (context, index) {
                  final announcement = announcements[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                announcement.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            if (announcement.isPinned) ...[
                              const SizedBox(width: 10),
                              Container(
                                padding: AnnouncementUiTokens.badgePadding,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AnnouncementUiTokens.badgeRadius,
                                  ),
                                ),
                                child: Text(
                                  '置顶',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatUpdatedAt(announcement.updatedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          announcement.content.trim(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.65,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${announcements.length} 条公告',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
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
