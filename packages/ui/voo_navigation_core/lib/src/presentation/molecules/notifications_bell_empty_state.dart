import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/notification_item.dart';

/// Empty state for notifications bell dropdown
class VooNotificationsBellEmptyState extends StatelessWidget {
  /// Style configuration
  final VooNotificationsBellStyle style;

  /// Custom empty state message
  final String? emptyStateMessage;

  const VooNotificationsBellEmptyState({
    super.key,
    required this.style,
    this.emptyStateMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none,
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            emptyStateMessage ?? 'No notifications',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
