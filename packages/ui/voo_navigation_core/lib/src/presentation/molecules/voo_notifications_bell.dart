import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/notification_item.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_badge.dart';
import 'package:voo_navigation_core/src/presentation/molecules/notifications_bell_dropdown_content.dart';

/// A notification bell with dropdown list
class VooNotificationsBell extends StatefulWidget {
  /// List of notifications
  final List<VooNotificationItem> notifications;

  /// Override for unread count badge
  final int? unreadCount;

  /// Callback when a notification is tapped
  final ValueChanged<VooNotificationItem>? onNotificationTap;

  /// Callback when a notification is dismissed
  final ValueChanged<VooNotificationItem>? onNotificationDismiss;

  /// Callback when mark all as read is tapped
  final VoidCallback? onMarkAllRead;

  /// Callback when view all is tapped
  final VoidCallback? onViewAll;

  /// Maximum visible notifications in dropdown
  final int maxVisibleNotifications;

  /// Whether to show mark all as read button
  final bool showMarkAllRead;

  /// Whether to show view all button
  final bool showViewAllButton;

  /// Message to show when no notifications
  final String? emptyStateMessage;

  /// Style configuration
  final VooNotificationsBellStyle? style;

  /// Whether to show in compact mode
  final bool compact;

  /// Custom notification item builder
  final Widget Function(VooNotificationItem, VoidCallback onTap, VoidCallback? onDismiss)?
      notificationBuilder;

  /// Custom empty state widget
  final Widget? emptyStateWidget;

  /// Custom header widget
  final Widget? headerWidget;

  /// Custom footer widget
  final Widget? footerWidget;

  /// Tooltip text
  final String? tooltip;

  const VooNotificationsBell({
    super.key,
    required this.notifications,
    this.unreadCount,
    this.onNotificationTap,
    this.onNotificationDismiss,
    this.onMarkAllRead,
    this.onViewAll,
    this.maxVisibleNotifications = 5,
    this.showMarkAllRead = true,
    this.showViewAllButton = true,
    this.emptyStateMessage,
    this.style,
    this.compact = false,
    this.notificationBuilder,
    this.emptyStateWidget,
    this.headerWidget,
    this.footerWidget,
    this.tooltip,
  });

  @override
  State<VooNotificationsBell> createState() => _VooNotificationsBellState();
}

class _VooNotificationsBellState extends State<VooNotificationsBell>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int get _unreadCount =>
      widget.unreadCount ??
      widget.notifications.where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() {
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    final style = widget.style ?? const VooNotificationsBellStyle();
    final dropdownWidth = style.dropdownWidth ?? 360;
    final maxHeight = style.maxDropdownHeight ?? 480;

    // Position dropdown to the left if it would overflow right edge
    double left = offset.dx + size.width / 2 - dropdownWidth / 2;
    if (left + dropdownWidth > screenSize.width - 16) {
      left = screenSize.width - dropdownWidth - 16;
    }
    if (left < 16) left = 16;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown
          Positioned(
            left: left,
            top: offset.dy + size.height + 8,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.topCenter,
              child: VooNotificationsBellDropdownContent(
                style: style,
                width: dropdownWidth,
                maxHeight: maxHeight,
                notifications: widget.notifications,
                maxVisibleNotifications: widget.maxVisibleNotifications,
                headerWidget: widget.headerWidget,
                emptyStateWidget: widget.emptyStateWidget,
                emptyStateMessage: widget.emptyStateMessage,
                footerWidget: widget.footerWidget,
                showViewAllButton: widget.showViewAllButton,
                showMarkAllRead: widget.showMarkAllRead,
                unreadCount: _unreadCount,
                onMarkAllRead: widget.onMarkAllRead,
                onViewAll: widget.onViewAll,
                onRemoveOverlay: _removeOverlay,
                onMarkNeedsBuild: () => _overlayEntry?.markNeedsBuild(),
                notificationBuilder: widget.notificationBuilder,
                onNotificationTap: _handleNotificationTap,
                onNotificationDismiss: widget.onNotificationDismiss != null
                    ? _handleNotificationDismiss
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(VooNotificationItem notification) {
    widget.onNotificationTap?.call(notification);
    notification.onTap?.call();
  }

  void _handleNotificationDismiss(VooNotificationItem notification) {
    widget.onNotificationDismiss?.call(notification);
    notification.onDismiss?.call();
    _overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = widget.style ?? const VooNotificationsBellStyle();

    final iconSize = widget.compact ? 20.0 : (style.iconSize ?? 24.0);

    return Tooltip(
      message: widget.tooltip ?? 'Notifications',
      child: InkWell(
        onTap: _toggleDropdown,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: VooBadgeWrapper(
            badge: VooBadge.count(
              count: _unreadCount,
              backgroundColor: style.badgeColor,
              foregroundColor: style.badgeTextColor,
            ),
            child: Icon(
              _isOpen ? Icons.notifications : Icons.notifications_outlined,
              size: iconSize,
              color: _isOpen
                  ? colorScheme.primary
                  : (style.iconColor ?? colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationsBellHeader extends StatelessWidget {
  final VooNotificationsBellStyle style;
  final bool showMarkAllRead;
  final int unreadCount;
  final VoidCallback? onMarkAllRead;
  final VoidCallback onMarkNeedsBuild;

  const _NotificationsBellHeader({
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

class _NotificationsBellEmptyState extends StatelessWidget {
  final VooNotificationsBellStyle style;
  final String? emptyStateMessage;

  const _NotificationsBellEmptyState({
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

class _NotificationsBellFooter extends StatelessWidget {
  final VooNotificationsBellStyle style;
  final VoidCallback? onViewAll;
  final VoidCallback onRemoveOverlay;

  const _NotificationsBellFooter({
    required this.style,
    this.onViewAll,
    required this.onRemoveOverlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: TextButton(
        onPressed: () {
          onRemoveOverlay();
          onViewAll?.call();
        },
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                style.borderRadius?.bottomLeft.x ?? 16,
              ),
              bottomRight: Radius.circular(
                style.borderRadius?.bottomRight.x ?? 16,
              ),
            ),
          ),
        ),
        child: Text(
          'View all notifications',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatefulWidget {
  final VooNotificationItem notification;
  final VooNotificationsBellStyle style;
  final VoidCallback onTap;
  final VoidCallback? onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.style,
    required this.onTap,
    this.onDismiss,
  });

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
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
