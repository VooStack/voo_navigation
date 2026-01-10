import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a search action for the search bar
class VooSearchAction extends Equatable {
  /// Unique identifier for the action
  final String id;

  /// Display label for the action
  final String label;

  /// Icon for the action
  final IconData? icon;

  /// Custom icon widget (takes precedence over icon)
  final Widget? iconWidget;

  /// Callback when the action is selected
  final VoidCallback? onTap;

  /// Keyboard shortcut hint (e.g., "⌘N")
  final String? shortcut;

  /// Additional keywords for search matching
  final List<String>? keywords;

  /// Optional description shown below the label
  final String? description;

  /// Category for grouping actions
  final String? category;

  /// Additional metadata for custom use
  final Map<String, dynamic>? metadata;

  const VooSearchAction({
    required this.id,
    required this.label,
    this.icon,
    this.iconWidget,
    this.onTap,
    this.shortcut,
    this.keywords,
    this.description,
    this.category,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    label,
    icon,
    shortcut,
    keywords,
    category,
  ];

  /// Creates a copy of this action with the given fields replaced
  VooSearchAction copyWith({
    String? id,
    String? label,
    IconData? icon,
    Widget? iconWidget,
    VoidCallback? onTap,
    String? shortcut,
    List<String>? keywords,
    String? description,
    String? category,
    Map<String, dynamic>? metadata,
  }) => VooSearchAction(
    id: id ?? this.id,
    label: label ?? this.label,
    icon: icon ?? this.icon,
    iconWidget: iconWidget ?? this.iconWidget,
    onTap: onTap ?? this.onTap,
    shortcut: shortcut ?? this.shortcut,
    keywords: keywords ?? this.keywords,
    description: description ?? this.description,
    category: category ?? this.category,
    metadata: metadata ?? this.metadata,
  );

  /// Checks if this action matches the given query
  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    if (label.toLowerCase().contains(lowerQuery)) return true;
    if (description?.toLowerCase().contains(lowerQuery) ?? false) return true;
    if (category?.toLowerCase().contains(lowerQuery) ?? false) return true;
    if (keywords != null) {
      for (final keyword in keywords!) {
        if (keyword.toLowerCase().contains(lowerQuery)) return true;
      }
    }
    return false;
  }

  /// Whether this action is a divider
  bool get isDivider => label.isEmpty && icon == null && iconWidget == null;

  /// Factory for creating a divider
  factory VooSearchAction.divider({String? id}) => VooSearchAction(
    id: id ?? 'divider_${DateTime.now().millisecondsSinceEpoch}',
    label: '',
  );
}

/// Style configuration for the search bar
class VooSearchBarStyle {
  /// Width of the search bar
  final double? width;

  /// Height of the search bar
  final double? height;

  /// Border radius of the search bar
  final BorderRadius? borderRadius;

  /// Background color of the search bar
  final Color? backgroundColor;

  /// Background color when focused
  final Color? focusedBackgroundColor;

  /// Color of the search icon
  final Color? iconColor;

  /// Text style for the search input
  final TextStyle? textStyle;

  /// Text style for the hint text
  final TextStyle? hintStyle;

  /// Padding inside the search bar
  final EdgeInsets? padding;

  /// Decoration for the search bar
  final BoxDecoration? decoration;

  /// Decoration when focused
  final BoxDecoration? focusedDecoration;

  /// Border color
  final Color? borderColor;

  /// Border color when focused
  final Color? focusedBorderColor;

  /// Width of the dropdown results
  final double? dropdownWidth;

  /// Maximum height of the dropdown results
  final double? maxDropdownHeight;

  /// Background color of the dropdown
  final Color? dropdownBackgroundColor;

  /// Text style for result items
  final TextStyle? resultItemStyle;

  /// Text style for keyboard shortcuts in results
  final TextStyle? shortcutStyle;

  const VooSearchBarStyle({
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.focusedBackgroundColor,
    this.iconColor,
    this.textStyle,
    this.hintStyle,
    this.padding,
    this.decoration,
    this.focusedDecoration,
    this.borderColor,
    this.focusedBorderColor,
    this.dropdownWidth,
    this.maxDropdownHeight,
    this.dropdownBackgroundColor,
    this.resultItemStyle,
    this.shortcutStyle,
  });

  /// Creates a copy with the given fields replaced
  VooSearchBarStyle copyWith({
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? focusedBackgroundColor,
    Color? iconColor,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    EdgeInsets? padding,
    BoxDecoration? decoration,
    BoxDecoration? focusedDecoration,
    Color? borderColor,
    Color? focusedBorderColor,
    double? dropdownWidth,
    double? maxDropdownHeight,
    Color? dropdownBackgroundColor,
    TextStyle? resultItemStyle,
    TextStyle? shortcutStyle,
  }) => VooSearchBarStyle(
    width: width ?? this.width,
    height: height ?? this.height,
    borderRadius: borderRadius ?? this.borderRadius,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    focusedBackgroundColor: focusedBackgroundColor ?? this.focusedBackgroundColor,
    iconColor: iconColor ?? this.iconColor,
    textStyle: textStyle ?? this.textStyle,
    hintStyle: hintStyle ?? this.hintStyle,
    padding: padding ?? this.padding,
    decoration: decoration ?? this.decoration,
    focusedDecoration: focusedDecoration ?? this.focusedDecoration,
    borderColor: borderColor ?? this.borderColor,
    focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
    dropdownWidth: dropdownWidth ?? this.dropdownWidth,
    maxDropdownHeight: maxDropdownHeight ?? this.maxDropdownHeight,
    dropdownBackgroundColor: dropdownBackgroundColor ?? this.dropdownBackgroundColor,
    resultItemStyle: resultItemStyle ?? this.resultItemStyle,
    shortcutStyle: shortcutStyle ?? this.shortcutStyle,
  );
}

/// Position of the search bar in the navigation
enum VooSearchBarPosition {
  /// In the header area
  header,
  /// In the app bar
  appBar,
  /// Before the navigation items
  beforeItems,
}
