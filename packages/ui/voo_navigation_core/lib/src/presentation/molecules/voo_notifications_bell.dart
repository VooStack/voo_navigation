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
  final Widget Function(VooNotificationItem, VoidCallback onTap, VoidCallback? onDismiss)? notificationBuilder;

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

class _VooNotificationsBellState extends State<VooNotificationsBell> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  int get _unreadCount => widget.unreadCount ?? widget.notifications.where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack);
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
                onNotificationDismiss: widget.onNotificationDismiss != null ? _handleNotificationDismiss : null,
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
            badge: VooBadge.count(count: _unreadCount, backgroundColor: style.badgeColor, foregroundColor: style.badgeTextColor),
            child: Icon(
              _isOpen ? Icons.notifications : Icons.notifications_outlined,
              size: iconSize,
              color: _isOpen ? colorScheme.primary : (style.iconColor ?? colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}
