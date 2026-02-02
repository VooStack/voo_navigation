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

  /// Whether to show the label for this specific action.
  /// If null, uses the global `showLabelsInGrid` setting.
  /// If set, overrides the global setting for this action only.
  final bool? showLabel;

  /// Custom text style for the label of this specific action.
  /// If null, uses the global style from VooQuickActionsStyle.labelStyle.
  final TextStyle? labelStyle;

  /// Whether this action represents a section with nested actions.
  /// When true, this action renders as a section header with [sectionActions].
  final bool isSection;

  /// Actions within this section (only used when [isSection] is true).
  final List<VooQuickAction>? sectionActions;

  /// Whether to enable horizontal scrolling for section actions.
  /// Only used when [isSection] is true. Defaults to true.
  final bool sectionHorizontalScroll;

  /// Height of items in the section. Only used when [isSection] is true.
  final double sectionItemHeight;

  /// Width of items in the section. Only used when [isSection] is true.
  final double sectionItemWidth;

  /// Spacing between items in the section. Only used when [isSection] is true.
  final double sectionItemSpacing;

  /// Padding for section content. Only used when [isSection] is true.
  final EdgeInsets? sectionPadding;

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
    this.showLabel,
    this.labelStyle,
    this.isSection = false,
    this.sectionActions,
    this.sectionHorizontalScroll = true,
    this.sectionItemHeight = 100,
    this.sectionItemWidth = 100,
    this.sectionItemSpacing = 8,
    this.sectionPadding,
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
    showLabel,
    labelStyle,
    isSection,
    sectionActions,
    sectionHorizontalScroll,
    sectionItemHeight,
    sectionItemWidth,
    sectionItemSpacing,
    sectionPadding,
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
    bool? showLabel,
    TextStyle? labelStyle,
    bool? isSection,
    List<VooQuickAction>? sectionActions,
    bool? sectionHorizontalScroll,
    double? sectionItemHeight,
    double? sectionItemWidth,
    double? sectionItemSpacing,
    EdgeInsets? sectionPadding,
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
    showLabel: showLabel ?? this.showLabel,
    labelStyle: labelStyle ?? this.labelStyle,
    isSection: isSection ?? this.isSection,
    sectionActions: sectionActions ?? this.sectionActions,
    sectionHorizontalScroll: sectionHorizontalScroll ?? this.sectionHorizontalScroll,
    sectionItemHeight: sectionItemHeight ?? this.sectionItemHeight,
    sectionItemWidth: sectionItemWidth ?? this.sectionItemWidth,
    sectionItemSpacing: sectionItemSpacing ?? this.sectionItemSpacing,
    sectionPadding: sectionPadding ?? this.sectionPadding,
  );

  /// Whether this action has children (submenu)
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Factory for creating a divider
  factory VooQuickAction.divider({String? id}) => VooQuickAction(
    id: id ?? 'divider_${DateTime.now().millisecondsSinceEpoch}',
    label: '',
  );

  /// Factory for creating a section with nested actions
  factory VooQuickAction.section({
    required String id,
    required String label,
    required List<VooQuickAction> actions,
    TextStyle? labelStyle,
    bool horizontalScroll = true,
    double itemHeight = 100,
    double itemWidth = 100,
    double itemSpacing = 8,
    EdgeInsets? padding,
    bool? showLabels,
  }) => VooQuickAction(
    id: id,
    label: label,
    labelStyle: labelStyle,
    isSection: true,
    sectionActions: actions,
    sectionHorizontalScroll: horizontalScroll,
    sectionItemHeight: itemHeight,
    sectionItemWidth: itemWidth,
    sectionItemSpacing: itemSpacing,
    sectionPadding: padding,
    showLabel: showLabels,
  );

  /// Whether this action is a divider
  bool get isDivider => label.isEmpty && !isSection;
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

/// Represents a section of quick actions with a label and optional horizontal scrolling
class VooQuickActionSection extends Equatable {
  /// Unique identifier for the section
  final String id;

  /// Display label for the section header
  final String label;

  /// Custom text style for the section label
  final TextStyle? labelStyle;

  /// List of actions in this section
  final List<VooQuickAction> actions;

  /// Whether to enable horizontal scrolling for this section.
  /// When true, actions are displayed in a horizontally scrolling row.
  /// When false, actions follow the parent layout (grid/list).
  final bool horizontalScroll;

  /// Height of items when horizontal scrolling is enabled. Defaults to 100.
  final double itemHeight;

  /// Width of items when horizontal scrolling is enabled. Defaults to 100.
  final double itemWidth;

  /// Spacing between items when horizontal scrolling is enabled. Defaults to 8.
  final double itemSpacing;

  /// Padding for the section content
  final EdgeInsets? padding;

  /// Whether to show labels on items in this section.
  /// If null, uses the global setting.
  final bool? showLabels;

  const VooQuickActionSection({
    required this.id,
    required this.label,
    required this.actions,
    this.labelStyle,
    this.horizontalScroll = true,
    this.itemHeight = 100,
    this.itemWidth = 100,
    this.itemSpacing = 8,
    this.padding,
    this.showLabels,
  });

  @override
  List<Object?> get props => [
    id,
    label,
    labelStyle,
    actions,
    horizontalScroll,
    itemHeight,
    itemWidth,
    itemSpacing,
    padding,
    showLabels,
  ];

  /// Creates a copy of this section with the given fields replaced
  VooQuickActionSection copyWith({
    String? id,
    String? label,
    TextStyle? labelStyle,
    List<VooQuickAction>? actions,
    bool? horizontalScroll,
    double? itemHeight,
    double? itemWidth,
    double? itemSpacing,
    EdgeInsets? padding,
    bool? showLabels,
  }) => VooQuickActionSection(
    id: id ?? this.id,
    label: label ?? this.label,
    labelStyle: labelStyle ?? this.labelStyle,
    actions: actions ?? this.actions,
    horizontalScroll: horizontalScroll ?? this.horizontalScroll,
    itemHeight: itemHeight ?? this.itemHeight,
    itemWidth: itemWidth ?? this.itemWidth,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    padding: padding ?? this.padding,
    showLabels: showLabels ?? this.showLabels,
  );
}
