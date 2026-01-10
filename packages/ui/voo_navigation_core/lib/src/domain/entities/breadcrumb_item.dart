import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a breadcrumb item for hierarchical navigation
class VooBreadcrumbItem extends Equatable {
  /// Unique identifier for the breadcrumb
  final String id;

  /// Display label for the breadcrumb
  final String label;

  /// Optional icon before the label
  final IconData? icon;

  /// Custom icon widget (takes precedence over icon)
  final Widget? iconWidget;

  /// Callback when the breadcrumb is tapped
  final VoidCallback? onTap;

  /// Route associated with this breadcrumb
  final String? route;

  /// Whether this is the current/active page
  final bool isCurrentPage;

  /// Additional metadata for custom use
  final Map<String, dynamic>? metadata;

  const VooBreadcrumbItem({
    required this.id,
    required this.label,
    this.icon,
    this.iconWidget,
    this.onTap,
    this.route,
    this.isCurrentPage = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    label,
    icon,
    route,
    isCurrentPage,
  ];

  /// Creates a copy of this breadcrumb with the given fields replaced
  VooBreadcrumbItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    Widget? iconWidget,
    VoidCallback? onTap,
    String? route,
    bool? isCurrentPage,
    Map<String, dynamic>? metadata,
  }) => VooBreadcrumbItem(
    id: id ?? this.id,
    label: label ?? this.label,
    icon: icon ?? this.icon,
    iconWidget: iconWidget ?? this.iconWidget,
    onTap: onTap ?? this.onTap,
    route: route ?? this.route,
    isCurrentPage: isCurrentPage ?? this.isCurrentPage,
    metadata: metadata ?? this.metadata,
  );

  /// Factory for creating a home breadcrumb
  factory VooBreadcrumbItem.home({
    VoidCallback? onTap,
    String? route,
  }) => VooBreadcrumbItem(
    id: 'home',
    label: 'Home',
    icon: Icons.home_outlined,
    onTap: onTap,
    route: route ?? '/',
  );
}

/// Style configuration for breadcrumbs
class VooBreadcrumbsStyle {
  /// Text style for breadcrumb items
  final TextStyle? itemStyle;

  /// Text style for the current (last) breadcrumb
  final TextStyle? currentItemStyle;

  /// Color of the separator
  final Color? separatorColor;

  /// Color when hovering over an item
  final Color? hoverColor;

  /// Padding around each breadcrumb item
  final EdgeInsets? itemPadding;

  /// Size of the icons
  final double? iconSize;

  /// Spacing between icon and label
  final double? iconSpacing;

  /// Spacing between breadcrumb items
  final double? itemSpacing;

  /// Height of the breadcrumbs container
  final double? height;

  /// Background color of the breadcrumbs container
  final Color? backgroundColor;

  /// Border radius of the breadcrumbs container
  final BorderRadius? borderRadius;

  /// Padding inside the breadcrumbs container
  final EdgeInsets? containerPadding;

  const VooBreadcrumbsStyle({
    this.itemStyle,
    this.currentItemStyle,
    this.separatorColor,
    this.hoverColor,
    this.itemPadding,
    this.iconSize,
    this.iconSpacing,
    this.itemSpacing,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.containerPadding,
  });

  /// Creates a copy with the given fields replaced
  VooBreadcrumbsStyle copyWith({
    TextStyle? itemStyle,
    TextStyle? currentItemStyle,
    Color? separatorColor,
    Color? hoverColor,
    EdgeInsets? itemPadding,
    double? iconSize,
    double? iconSpacing,
    double? itemSpacing,
    double? height,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? containerPadding,
  }) => VooBreadcrumbsStyle(
    itemStyle: itemStyle ?? this.itemStyle,
    currentItemStyle: currentItemStyle ?? this.currentItemStyle,
    separatorColor: separatorColor ?? this.separatorColor,
    hoverColor: hoverColor ?? this.hoverColor,
    itemPadding: itemPadding ?? this.itemPadding,
    iconSize: iconSize ?? this.iconSize,
    iconSpacing: iconSpacing ?? this.iconSpacing,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    height: height ?? this.height,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderRadius: borderRadius ?? this.borderRadius,
    containerPadding: containerPadding ?? this.containerPadding,
  );
}
