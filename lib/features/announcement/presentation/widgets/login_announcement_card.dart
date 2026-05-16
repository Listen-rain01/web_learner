import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_learner/features/announcement/application/announcement_controller.dart';
import 'package:web_learner/features/announcement/domain/entities/announcement.dart';
import 'package:web_learner/features/announcement/presentation/announcement_ui_tokens.dart';
import 'package:web_learner/features/announcement/presentation/widgets/announcement_list_dialog.dart';

class LoginAnnouncementCard extends ConsumerWidget {
  const LoginAnnouncementCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(loginAnnouncementsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = announcements.isEmpty ? null : announcements.first;
    final barBackground = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    final barBorder = colorScheme.outlineVariant.withValues(alpha: 0.65);

    if (primary == null) {
      return const SizedBox.shrink();
    }

    final message = primary.previewText.isEmpty
        ? primary.title
        : '${primary.title}：${primary.previewText}';

    return Material(
      color: barBackground,
      child: InkWell(
        onTap: () => _showAnnouncementSheet(context, announcements),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: barBorder),
            ),
          ),
          child: SizedBox(
            height: AnnouncementUiTokens.topBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AnnouncementUiTokens.topBarHorizontalPadding,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.campaign_outlined,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AnnouncementUiTokens.topBarGap),
                  Expanded(
                    child: _MarqueeText(
                      text: message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAnnouncementSheet(
    BuildContext context,
    List<Announcement> announcements,
  ) {
    final dialogFuture = showDialog<void>(
      context: context,
      builder: (context) {
        return AnnouncementListDialog(
          announcements: announcements,
        );
      },
    );
    unawaited(dialogFuture);
  }
}

class _MarqueeText extends StatefulWidget {
  const _MarqueeText({
    required this.text,
    this.style,
  });

  final String text;
  final TextStyle? style;

  @override
  State<_MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<_MarqueeText>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final Ticker _ticker;
  Duration? _lastElapsed;
  bool _shouldAnimate = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _ticker = createTicker(_handleTick);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateAnimation());
  }

  @override
  void didUpdateWidget(covariant _MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _lastElapsed = null;
      _jumpToStart();
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateAnimation());
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTick(Duration elapsed) {
    if (!_shouldAnimate || !_scrollController.hasClients) {
      return;
    }

    final previousElapsed = _lastElapsed;
    _lastElapsed = elapsed;
    if (previousElapsed == null) {
      return;
    }

    final deltaSeconds =
        (elapsed - previousElapsed).inMicroseconds /
        Duration.microsecondsPerSecond;
    final nextOffset =
        _scrollController.offset +
        (deltaSeconds * AnnouncementUiTokens.marqueeVelocity);
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (nextOffset >= maxScrollExtent) {
      _scrollController.jumpTo(0);
      return;
    }

    _scrollController.jumpTo(nextOffset);
  }

  void _updateAnimation() {
    if (!mounted || !_scrollController.hasClients) {
      return;
    }

    final shouldAnimate = _scrollController.position.maxScrollExtent > 0;
    _shouldAnimate = shouldAnimate;
    _lastElapsed = null;

    if (shouldAnimate) {
      if (!_ticker.isActive) {
        unawaited(_ticker.start());
      }
    } else {
      _ticker.stop();
      _jumpToStart();
    }
  }

  void _jumpToStart() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                children: [
                  Text(
                    widget.text,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                    style: widget.style,
                  ),
                  const SizedBox(width: AnnouncementUiTokens.marqueeGap),
                  Text(
                    widget.text,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                    style: widget.style,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
