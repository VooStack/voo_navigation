import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';

/// Represents a group of navigation items with a title and optional styling.
///
/// Use sections to organize navigation items into logical groups with headers.
/// Sections can be expanded/collapsed and support custom styling.
///
/// Example:
/// ```dart
/// VooNavigationSection(
///   id: 'main_section',
///   title: 'Main',
///   items: [
///     VooNavigationItem(id: 'home', label: 'Home', icon: Icons.home, route: '/'),
///     VooNavigationItem(id: 'dashboard', label: 'Dashboard', icon: Icons.dashboard, route: '/dashboard'),
///   ],
/// )
/// ```
class VooNavigationSection extends Equatable {
  /// Unique identifier for the section
  final String id;

  /// Display title for the section header
  final String title;

  /// Optional icon displayed before the title
  final IconData? icon;

  /// Navigation items within this section
  final List<VooNavigationItem> items;

  /// Whether the section is initially expanded
  final bool isExpanded;

  /// Whether the section can be collapsed/expanded by the user
  final bool isCollapsible;

  /// Whether to show a divider line before this section
  final bool showDividerBefore;

  /// Whether to show a divider line after this section
  final bool showDividerAfter;

  /// Custom text style for the section title
  final TextStyle? titleStyle;

  /// Custom widget to display at the end of the section header
  final Widget? trailingWidget;

  /// Custom padding for the section
  final EdgeInsetsGeometry? padding;

  /// Whether this section is visible
  final bool isVisible;

  /// Sort order for the section (lower values appear first)
  final int sortOrder;

  /// Semantic label for accessibility
  final String? semanticLabel;

  const VooNavigationSection({
    required this.id,
    required this.title,
    required this.items,
    this.icon,
    this.isExpanded = true,
    this.isCollapsible = true,
    this.showDividerBefore = false,
    this.showDividerAfter = false,
    this.titleStyle,
    this.trailingWidget,
    this.padding,
    this.isVisible = true,
    this.sortOrder = 0,
    this.semanticLabel,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        icon,
        items,
        isExpanded,
        isCollapsible,
        showDividerBefore,
        showDividerAfter,
        isVisible,
        sortOrder,
      ];

  /// Creates a copy of this section with the given fields replaced
  VooNavigationSection copyWith({
    String? id,
    String? title,
    IconData? icon,
    List<VooNavigationItem>? items,
    bool? isExpanded,
    bool? isCollapsible,
    bool? showDividerBefore,
    bool? showDividerAfter,
    TextStyle? titleStyle,
    Widget? trailingWidget,
    EdgeInsetsGeometry? padding,
    bool? isVisible,
    int? sortOrder,
    String? semanticLabel,
  }) =>
      VooNavigationSection(
        id: id ?? this.id,
        title: title ?? this.title,
        icon: icon ?? this.icon,
        items: items ?? this.items,
        isExpanded: isExpanded ?? this.isExpanded,
        isCollapsible: isCollapsible ?? this.isCollapsible,
        showDividerBefore: showDividerBefore ?? this.showDividerBefore,
        showDividerAfter: showDividerAfter ?? this.showDividerAfter,
        titleStyle: titleStyle ?? this.titleStyle,
        trailingWidget: trailingWidget ?? this.trailingWidget,
        padding: padding ?? this.padding,
        isVisible: isVisible ?? this.isVisible,
        sortOrder: sortOrder ?? this.sortOrder,
        semanticLabel: semanticLabel ?? this.semanticLabel,
      );

  /// Gets the effective semantic label
  String get effectiveSemanticLabel =>
      semanticLabel ?? '$title section with ${items.length} items';

  /// Whether this section has any visible items
  bool get hasVisibleItems => items.any((item) => item.isVisible);

  /// Gets visible items in this section
  List<VooNavigationItem> get visibleItems =>
      items.where((item) => item.isVisible).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  /// Converts this section to a VooNavigationItem for backward compatibility
  ///
  /// This allows sections to be used with existing code that expects items
  VooNavigationItem toNavigationItem() => VooNavigationItem(
        id: id,
        label: title,
        icon: icon ?? Icons.folder_outlined,
        selectedIcon: icon ?? Icons.folder,
        children: items,
        isExpanded: isExpanded,
        isVisible: isVisible,
        sortOrder: sortOrder,
        semanticLabel: effectiveSemanticLabel,
      );
}
