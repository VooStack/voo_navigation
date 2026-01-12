import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/notification_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/notifications_bell_empty_state.dart';
import 'package:voo_navigation_core/src/presentation/molecules/notifications_bell_footer.dart';
import 'package:voo_navigation_core/src/presentation/molecules/notifications_bell_header.dart';
import 'package:voo_navigation_core/src/presentation/molecules/notification_tile.dart';

/// Dropdown content for notifications bell
class VooNotificationsBellDropdownContent extends StatelessWidget {
  /// Style configuration
  final VooNotificationsBellStyle style;

  /// Width of the dropdown
  final double width;

  /// Maximum height of the dropdown
  final double maxHeight;

  /// List of notifications
  final List<VooNotificationItem> notifications;

  /// Maximum visible notifications
  final int maxVisibleNotifications;

  /// Custom header widget
  final Widget? headerWidget;

  /// Custom empty state widget
  final Widget? emptyStateWidget;

  /// Empty state message
  final String? emptyStateMessage;

  /// Custom footer widget
  final Widget? footerWidget;

  /// Whether to show view all button
  final bool showViewAllButton;

  /// Whether to show mark all as read button
  final bool showMarkAllRead;

  /// Unread count
  final int unreadCount;

  /// Callback when mark all as read is tapped
  final VoidCallback? onMarkAllRead;

  /// Callback when view all is tapped
  final VoidCallback? onViewAll;

  /// Callback to remove overlay
  final VoidCallback onRemoveOverlay;

  /// Callback to mark overlay as needing rebuild
  final VoidCallback onMarkNeedsBuild;

  /// Custom notification builder
  final Widget Function(VooNotificationItem, VoidCallback onTap, VoidCallback? onDismiss)? notificationBuilder;

  /// Callback when notification is tapped
  final void Function(VooNotificationItem) onNotificationTap;

  /// Callback when notification is dismissed
  final void Function(VooNotificationItem)? onNotificationDismiss;

  const VooNotificationsBellDropdownContent({
    super.key,
    required this.style,
    required this.width,
    required this.maxHeight,
    required this.notifications,
    required this.maxVisibleNotifications,
    this.headerWidget,
    this.emptyStateWidget,
    this.emptyStateMessage,
    this.footerWidget,
    required this.showViewAllButton,
    required this.showMarkAllRead,
    required this.unreadCount,
    this.onMarkAllRead,
    this.onViewAll,
    required this.onRemoveOverlay,
    required this.onMarkNeedsBuild,
    this.notificationBuilder,
    required this.onNotificationTap,
    this.onNotificationDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 8,
      borderRadius: style.borderRadius ?? BorderRadius.circular(16),
      color: style.backgroundColor ?? colorScheme.surface,
      child: Container(
        width: width,
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          borderRadius: style.borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            headerWidget ??
                VooNotificationsBellHeader(
                  style: style,
                  showMarkAllRead: showMarkAllRead,
                  unreadCount: unreadCount,
                  onMarkAllRead: onMarkAllRead,
                  onMarkNeedsBuild: onMarkNeedsBuild,
                ),

            // Notifications list
            if (notifications.isEmpty)
              emptyStateWidget ??
                  VooNotificationsBellEmptyState(
                    style: style,
                    emptyStateMessage: emptyStateMessage,
                  )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: notifications.take(maxVisibleNotifications).length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    if (notificationBuilder != null) {
                      return notificationBuilder!(
                        notification,
                        () => onNotificationTap(notification),
                        notification.onDismiss != null && onNotificationDismiss != null
                            ? () => onNotificationDismiss!(notification)
                            : null,
                      );
                    }

                    return VooNotificationTile(
                      notification: notification,
                      style: style,
                      onTap: () => onNotificationTap(notification),
                      onDismiss: onNotificationDismiss != null
                          ? () => onNotificationDismiss!(notification)
                          : null,
                    );
                  },
                ),
              ),

            // Footer
            if (footerWidget != null)
              footerWidget!
            else if (showViewAllButton && notifications.length > maxVisibleNotifications)
              VooNotificationsBellFooter(
                style: style,
                onViewAll: onViewAll,
                onRemoveOverlay: onRemoveOverlay,
              ),
          ],
        ),
      ),
    );
  }
}
