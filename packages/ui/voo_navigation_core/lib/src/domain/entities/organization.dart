import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents an organization for the organization switcher
class VooOrganization extends Equatable {
  /// Unique identifier for the organization
  final String id;

  /// Display name of the organization
  final String name;

  /// Optional subtitle (e.g., "12 members", "Pro Plan")
  final String? subtitle;

  /// URL for the organization avatar/logo
  final String? avatarUrl;

  /// Custom widget for the avatar (takes precedence over avatarUrl)
  final Widget? avatarWidget;

  /// Fallback color for initials when no avatar is provided
  final Color? avatarColor;

  /// Whether this organization is currently selected
  final bool isSelected;

  /// Additional metadata for custom use
  final Map<String, dynamic>? metadata;

  const VooOrganization({
    required this.id,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.avatarWidget,
    this.avatarColor,
    this.isSelected = false,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    subtitle,
    avatarUrl,
    avatarColor,
    isSelected,
  ];

  /// Creates a copy of this organization with the given fields replaced
  VooOrganization copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? avatarUrl,
    Widget? avatarWidget,
    Color? avatarColor,
    bool? isSelected,
    Map<String, dynamic>? metadata,
  }) => VooOrganization(
    id: id ?? this.id,
    name: name ?? this.name,
    subtitle: subtitle ?? this.subtitle,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    avatarWidget: avatarWidget ?? this.avatarWidget,
    avatarColor: avatarColor ?? this.avatarColor,
    isSelected: isSelected ?? this.isSelected,
    metadata: metadata ?? this.metadata,
  );

  /// Gets the initials from the organization name
  String get initials {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';
    if (words.length == 1) {
      return words.first.substring(0, words.first.length.clamp(0, 2)).toUpperCase();
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

/// Style configuration for the organization switcher
class VooOrganizationSwitcherStyle {
  /// Width of the dropdown menu
  final double? dropdownWidth;

  /// Maximum height of the dropdown menu
  final double? maxDropdownHeight;

  /// Border radius of the dropdown and trigger
  final BorderRadius? borderRadius;

  /// Background color of the dropdown
  final Color? backgroundColor;

  /// Color for the selected organization item
  final Color? selectedColor;

  /// Color when hovering over an organization item
  final Color? hoverColor;

  /// Text style for organization name
  final TextStyle? titleStyle;

  /// Text style for organization subtitle
  final TextStyle? subtitleStyle;

  /// Padding inside the dropdown items
  final EdgeInsets? itemPadding;

  /// Padding inside the trigger button
  final EdgeInsets? triggerPadding;

  /// Decoration for the dropdown
  final BoxDecoration? dropdownDecoration;

  /// Decoration for the trigger button
  final BoxDecoration? triggerDecoration;

  /// Size of the avatar
  final double avatarSize;

  /// Size of the avatar in compact mode
  final double compactAvatarSize;

  const VooOrganizationSwitcherStyle({
    this.dropdownWidth,
    this.maxDropdownHeight,
    this.borderRadius,
    this.backgroundColor,
    this.selectedColor,
    this.hoverColor,
    this.titleStyle,
    this.subtitleStyle,
    this.itemPadding,
    this.triggerPadding,
    this.dropdownDecoration,
    this.triggerDecoration,
    this.avatarSize = 40,
    this.compactAvatarSize = 32,
  });

  /// Creates a copy with the given fields replaced
  VooOrganizationSwitcherStyle copyWith({
    double? dropdownWidth,
    double? maxDropdownHeight,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? selectedColor,
    Color? hoverColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    EdgeInsets? itemPadding,
    EdgeInsets? triggerPadding,
    BoxDecoration? dropdownDecoration,
    BoxDecoration? triggerDecoration,
    double? avatarSize,
    double? compactAvatarSize,
  }) => VooOrganizationSwitcherStyle(
    dropdownWidth: dropdownWidth ?? this.dropdownWidth,
    maxDropdownHeight: maxDropdownHeight ?? this.maxDropdownHeight,
    borderRadius: borderRadius ?? this.borderRadius,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    selectedColor: selectedColor ?? this.selectedColor,
    hoverColor: hoverColor ?? this.hoverColor,
    titleStyle: titleStyle ?? this.titleStyle,
    subtitleStyle: subtitleStyle ?? this.subtitleStyle,
    itemPadding: itemPadding ?? this.itemPadding,
    triggerPadding: triggerPadding ?? this.triggerPadding,
    dropdownDecoration: dropdownDecoration ?? this.dropdownDecoration,
    triggerDecoration: triggerDecoration ?? this.triggerDecoration,
    avatarSize: avatarSize ?? this.avatarSize,
    compactAvatarSize: compactAvatarSize ?? this.compactAvatarSize,
  );
}

/// Position of the organization switcher in the navigation
enum VooOrganizationSwitcherPosition {
  /// In the header area
  header,
  /// In the footer area
  footer,
  /// Before the navigation items
  beforeItems,
}
