import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/notification_item.dart';

/// Header for notifications bell dropdown
class VooNotificationsBellHeader extends StatelessWidget {
  /// Style configuration
  final VooNotificationsBellStyle style;

  /// Whether to show mark all as read button
  final bool showMarkAllRead;

  /// Unread count
  final int unreadCount;

  /// Callback when mark all as read is tapped
  final VoidCallback? onMarkAllRead;

  /// Callback to mark overlay as needing rebuild
  final VoidCallback onMarkNeedsBuild;

  const VooNotificationsBellHeader({
    super.key,
    required this.style,
    required this.showMarkAllRead,
    required this.unreadCount,
    this.onMarkAllRead,
    required this.onMarkNeedsBuild,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notifications',
            style: style.titleStyle ??
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (showMarkAllRead && unreadCount > 0)
            TextButton(
              onPressed: () {
                onMarkAllRead?.call();
                onMarkNeedsBuild();
              },
              child: Text(
                'Mark all as read',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
