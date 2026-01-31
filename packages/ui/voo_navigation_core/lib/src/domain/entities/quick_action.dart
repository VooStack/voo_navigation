import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a quick action item for the quick actions menu
class VooQuickAction extends Equatable {
  /// Unique identifier for the action
  final String id;

  /// Display label for the action
  final String label;

  /// Icon for the action
  final IconData? icon;

  /// Custom icon widget (takes precedence over icon)
  final Widget? iconWidget;

  /// Color for the icon
  final Color? iconColor;

  /// Callback when the action is tapped
  final VoidCallback? onTap;

  /// Keyboard shortcut hint (e.g., "⌘N")
  final String? shortcut;

  /// Whether the action is enabled
  final bool isEnabled;

  /// Whether this is a dangerous/destructive action (shows in red)
  final bool isDangerous;

  /// Child actions for nested menus
  final List<VooQuickAction>? children;

  /// Optional description shown below the label
  final String? description;

  /// Additional metadata for custom use
  final Map<String, dynamic>? metadata;

  /// Number of columns this action spans in grid layout (default: 1)
  final int gridColumnSpan;

  /// Background color for this action in grid layout
  final Color? gridBackgroundColor;

  /// Icon background color for this action in grid layout
  final Color? gridIconBackgroundColor;

  /// Custom height for this action in grid layout
  final double? gridHeight;

  const VooQuickAction({
    required this.id,
    required this.label,
    this.icon,
    this.iconWidget,
    this.iconColor,
    this.onTap,
    this.shortcut,
    this.isEnabled = true,
    this.isDangerous = false,
    this.children,
    this.description,
    this.metadata,
    this.gridColumnSpan = 1,
    this.gridBackgroundColor,
    this.gridIconBackgroundColor,
    this.gridHeight,
  });

  @override
  List<Object?> get props => [
    id,
    label,
    icon,
    iconColor,
    shortcut,
    isEnabled,
    isDangerous,
    children,
    gridColumnSpan,
    gridBackgroundColor,
    gridIconBackgroundColor,
    gridHeight,
  ];

  /// Creates a copy of this action with the given fields replaced
  VooQuickAction copyWith({
    String? id,
    String? label,
    IconData? icon,
    Widget? iconWidget,
    Color? iconColor,
    VoidCallback? onTap,
    String? shortcut,
    bool? isEnabled,
    bool? isDangerous,
    List<VooQuickAction>? children,
    String? description,
    Map<String, dynamic>? metadata,
    int? gridColumnSpan,
    Color? gridBackgroundColor,
    Color? gridIconBackgroundColor,
    double? gridHeight,
  }) => VooQuickAction(
    id: id ?? this.id,
    label: label ?? this.label,
    icon: icon ?? this.icon,
    iconWidget: iconWidget ?? this.iconWidget,
    iconColor: iconColor ?? this.iconColor,
    onTap: onTap ?? this.onTap,
    shortcut: shortcut ?? this.shortcut,
    isEnabled: isEnabled ?? this.isEnabled,
    isDangerous: isDangerous ?? this.isDangerous,
    children: children ?? this.children,
    description: description ?? this.description,
    metadata: metadata ?? this.metadata,
    gridColumnSpan: gridColumnSpan ?? this.gridColumnSpan,
    gridBackgroundColor: gridBackgroundColor ?? this.gridBackgroundColor,
    gridIconBackgroundColor: gridIconBackgroundColor ?? this.gridIconBackgroundColor,
    gridHeight: gridHeight ?? this.gridHeight,
  );

  /// Whether this action has children (submenu)
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Factory for creating a divider
  factory VooQuickAction.divider({String? id}) => VooQuickAction(
    id: id ?? 'divider_${DateTime.now().millisecondsSinceEpoch}',
    label: '',
  );

  /// Whether this action is a divider
  bool get isDivider => label.isEmpty;
}

/// Style configuration for the quick actions menu
class VooQuickActionsStyle {
  /// Size of the icons
  final double? iconSize;

  /// Color of the trigger button
  final Color? triggerColor;

  /// Background color of the trigger button
  final Color? triggerBackgroundColor;

  /// Width of the dropdown menu
  final double? dropdownWidth;

  /// Border radius of the dropdown
  final BorderRadius? borderRadius;

  /// Background color of the dropdown
  final Color? backgroundColor;

  /// Color when hovering over an item
  final Color? hoverColor;

  /// Color for dangerous/destructive actions
  final Color? dangerColor;

  /// Text style for action labels
  final TextStyle? labelStyle;

  /// Text style for action descriptions
  final TextStyle? descriptionStyle;

  /// Text style for keyboard shortcuts
  final TextStyle? shortcutStyle;

  /// Padding inside action items
  final EdgeInsets? itemPadding;

  /// Size of the trigger button
  final double? triggerSize;

  const VooQuickActionsStyle({
    this.iconSize,
    this.triggerColor,
    this.triggerBackgroundColor,
    this.dropdownWidth,
    this.borderRadius,
    this.backgroundColor,
    this.hoverColor,
    this.dangerColor,
    this.labelStyle,
    this.descriptionStyle,
    this.shortcutStyle,
    this.itemPadding,
    this.triggerSize,
  });

  /// Creates a copy with the given fields replaced
  VooQuickActionsStyle copyWith({
    double? iconSize,
    Color? triggerColor,
    Color? triggerBackgroundColor,
    double? dropdownWidth,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? hoverColor,
    Color? dangerColor,
    TextStyle? labelStyle,
    TextStyle? descriptionStyle,
    TextStyle? shortcutStyle,
    EdgeInsets? itemPadding,
    double? triggerSize,
  }) => VooQuickActionsStyle(
    iconSize: iconSize ?? this.iconSize,
    triggerColor: triggerColor ?? this.triggerColor,
    triggerBackgroundColor: triggerBackgroundColor ?? this.triggerBackgroundColor,
    dropdownWidth: dropdownWidth ?? this.dropdownWidth,
    borderRadius: borderRadius ?? this.borderRadius,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    hoverColor: hoverColor ?? this.hoverColor,
    dangerColor: dangerColor ?? this.dangerColor,
    labelStyle: labelStyle ?? this.labelStyle,
    descriptionStyle: descriptionStyle ?? this.descriptionStyle,
    shortcutStyle: shortcutStyle ?? this.shortcutStyle,
    itemPadding: itemPadding ?? this.itemPadding,
    triggerSize: triggerSize ?? this.triggerSize,
  );
}

/// Position of the quick actions in the navigation
enum VooQuickActionsPosition {
  /// As a floating action button
  fab,
  /// In the header area
  header,
  /// In the footer area
  footer,
}
