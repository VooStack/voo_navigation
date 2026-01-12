import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/notification_item.dart';

/// A single notification tile
class VooNotificationTile extends StatefulWidget {
  /// Notification data
  final VooNotificationItem notification;

  /// Style configuration
  final VooNotificationsBellStyle style;

  /// Callback when tapped
  final VoidCallback onTap;

  /// Callback when dismissed
  final VoidCallback? onDismiss;

  const VooNotificationTile({
    super.key,
    required this.notification,
    required this.style,
    required this.onTap,
    this.onDismiss,
  });

  @override
  State<VooNotificationTile> createState() => _VooNotificationTileState();
}

class _VooNotificationTileState extends State<VooNotificationTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notification = widget.notification;
    final style = widget.style;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Dismissible(
        key: Key(notification.id),
        direction: widget.onDismiss != null
            ? DismissDirection.endToStart
            : DismissDirection.none,
        onDismissed: (_) => widget.onDismiss?.call(),
        background: Container(
          color: colorScheme.error,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            Icons.delete_outline,
            color: colorScheme.onError,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            padding: style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: !notification.isRead
                ? (style.unreadBackgroundColor ??
                    colorScheme.primaryContainer.withValues(alpha: 0.3))
                : (_isHovered ? colorScheme.surfaceContainerHighest : null),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: notification.iconBackgroundColor ??
                        colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: notification.iconWidget ??
                      Icon(
                        notification.icon ?? Icons.notifications,
                        size: 20,
                        color: notification.iconColor ?? colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (notification.isUrgent)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: style.urgentColor ?? colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              notification.title,
                              style: style.titleStyle ??
                                  theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: notification.isRead
                                        ? FontWeight.w400
                                        : FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (notification.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          notification.subtitle!,
                          style: style.subtitleStyle ??
                              theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (notification.timestamp != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          notification.relativeTime,
                          style: style.timestampStyle ??
                              theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                      if (notification.actions != null &&
                          notification.actions!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: notification.actions!.map((action) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: action.isPrimary
                                  ? FilledButton(
                                      onPressed: action.onTap,
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        minimumSize: Size.zero,
                                        textStyle: theme.textTheme.labelSmall,
                                      ),
                                      child: Text(action.label),
                                    )
                                  : TextButton(
                                      onPressed: action.onTap,
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        minimumSize: Size.zero,
                                        textStyle: theme.textTheme.labelSmall,
                                      ),
                                      child: Text(action.label),
                                    ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                // Unread indicator
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(left: 8, top: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
