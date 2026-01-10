import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a notification item for the notifications bell
class VooNotificationItem extends Equatable {
  /// Unique identifier for the notification
  final String id;

  /// Title/headline of the notification
  final String title;

  /// Optional subtitle/description
  final String? subtitle;

  /// When the notification was created
  final DateTime? timestamp;

  /// Icon for the notification type
  final IconData? icon;

  /// Custom icon widget (takes precedence over icon)
  final Widget? iconWidget;

  /// Color for the icon
  final Color? iconColor;

  /// Background color for the icon container
  final Color? iconBackgroundColor;

  /// Whether the notification has been read
  final bool isRead;

  /// Whether this is an urgent/important notification
  final bool isUrgent;

  /// Callback when the notification is tapped
  final VoidCallback? onTap;

  /// Callback when the notification is dismissed
  final VoidCallback? onDismiss;

  /// Additional metadata for custom use
  final Map<String, dynamic>? metadata;

  /// Optional action buttons for the notification
  final List<VooNotificationAction>? actions;

  const VooNotificationItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.timestamp,
    this.icon,
    this.iconWidget,
    this.iconColor,
    this.iconBackgroundColor,
    this.isRead = false,
    this.isUrgent = false,
    this.onTap,
    this.onDismiss,
    this.metadata,
    this.actions,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    timestamp,
    icon,
    iconColor,
    isRead,
    isUrgent,
  ];

  /// Creates a copy of this notification with the given fields replaced
  VooNotificationItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    IconData? icon,
    Widget? iconWidget,
    Color? iconColor,
    Color? iconBackgroundColor,
    bool? isRead,
    bool? isUrgent,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    Map<String, dynamic>? metadata,
    List<VooNotificationAction>? actions,
  }) => VooNotificationItem(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    timestamp: timestamp ?? this.timestamp,
    icon: icon ?? this.icon,
    iconWidget: iconWidget ?? this.iconWidget,
    iconColor: iconColor ?? this.iconColor,
    iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
    isRead: isRead ?? this.isRead,
    isUrgent: isUrgent ?? this.isUrgent,
    onTap: onTap ?? this.onTap,
    onDismiss: onDismiss ?? this.onDismiss,
    metadata: metadata ?? this.metadata,
    actions: actions ?? this.actions,
  );

  /// Returns a human-readable relative time string
  String get relativeTime {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final difference = now.difference(timestamp!);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }
    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    }
    return '${(difference.inDays / 30).floor()}mo ago';
  }
}

/// Action button for a notification
class VooNotificationAction {
  /// Label for the action button
  final String label;

  /// Callback when the action is tapped
  final VoidCallback? onTap;

  /// Whether this is a primary action
  final bool isPrimary;

  const VooNotificationAction({
    required this.label,
    this.onTap,
    this.isPrimary = false,
  });
}

/// Style configuration for the notifications bell
class VooNotificationsBellStyle {
  /// Size of the bell icon
  final double? iconSize;

  /// Color of the bell icon
  final Color? iconColor;

  /// Background color of the badge
  final Color? badgeColor;

  /// Text color of the badge
  final Color? badgeTextColor;

  /// Width of the dropdown
  final double? dropdownWidth;

  /// Maximum height of the dropdown
  final double? maxDropdownHeight;

  /// Border radius of the dropdown
  final BorderRadius? borderRadius;

  /// Background color of the dropdown
  final Color? backgroundColor;

  /// Text style for notification title
  final TextStyle? titleStyle;

  /// Text style for notification subtitle
  final TextStyle? subtitleStyle;

  /// Text style for timestamp
  final TextStyle? timestampStyle;

  /// Color for unread notification background
  final Color? unreadBackgroundColor;

  /// Color for urgent notification indicator
  final Color? urgentColor;

  /// Padding inside notification items
  final EdgeInsets? itemPadding;

  const VooNotificationsBellStyle({
    this.iconSize,
    this.iconColor,
    this.badgeColor,
    this.badgeTextColor,
    this.dropdownWidth,
    this.maxDropdownHeight,
    this.borderRadius,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.timestampStyle,
    this.unreadBackgroundColor,
    this.urgentColor,
    this.itemPadding,
  });

  /// Creates a copy with the given fields replaced
  VooNotificationsBellStyle copyWith({
    double? iconSize,
    Color? iconColor,
    Color? badgeColor,
    Color? badgeTextColor,
    double? dropdownWidth,
    double? maxDropdownHeight,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    TextStyle? timestampStyle,
    Color? unreadBackgroundColor,
    Color? urgentColor,
    EdgeInsets? itemPadding,
  }) => VooNotificationsBellStyle(
    iconSize: iconSize ?? this.iconSize,
    iconColor: iconColor ?? this.iconColor,
    badgeColor: badgeColor ?? this.badgeColor,
    badgeTextColor: badgeTextColor ?? this.badgeTextColor,
    dropdownWidth: dropdownWidth ?? this.dropdownWidth,
    maxDropdownHeight: maxDropdownHeight ?? this.maxDropdownHeight,
    borderRadius: borderRadius ?? this.borderRadius,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    titleStyle: titleStyle ?? this.titleStyle,
    subtitleStyle: subtitleStyle ?? this.subtitleStyle,
    timestampStyle: timestampStyle ?? this.timestampStyle,
    unreadBackgroundColor: unreadBackgroundColor ?? this.unreadBackgroundColor,
    urgentColor: urgentColor ?? this.urgentColor,
    itemPadding: itemPadding ?? this.itemPadding,
  );
}
