import 'package:flutter/material.dart';

/// Configuration for an action navigation item that displays a modal when tapped.
///
/// This is used in the expandable bottom navigation bar to provide
/// a central action button (e.g., a plus button) that opens a custom modal
/// with quick actions.
class VooActionNavigationItem {
  /// Unique identifier for the action item
  final String id;

  /// Icon to display when the modal is closed
  final IconData icon;

  /// Icon to display when the modal is open (optional, defaults to Icons.close)
  final IconData? activeIcon;

  /// Custom color for the icon (defaults to theme's onPrimary color)
  final Color? iconColor;

  /// Custom background color for the action button circle
  final Color? backgroundColor;

  /// Builder function that creates the modal content.
  ///
  /// The [close] callback should be called when an action is selected
  /// to close the modal.
  final Widget Function(BuildContext context, VoidCallback close) modalBuilder;

  /// Maximum height of the modal content.
  ///
  /// The modal will constrain its height to this value.
  /// Defaults to 300.0.
  final double modalMaxHeight;

  /// Whether to close the modal when tapping outside of it.
  ///
  /// Defaults to true.
  final bool closeOnTapOutside;

  /// Custom tooltip for the action button
  final String? tooltip;

  /// Sort order for positioning (lower values position earlier/left)
  final int sortOrder;

  /// Position of the action item in the navigation bar.
  ///
  /// If null, the item will be positioned in the center.
  final VooActionItemPosition position;

  const VooActionNavigationItem({
    required this.id,
    required this.icon,
    required this.modalBuilder,
    this.activeIcon,
    this.iconColor,
    this.backgroundColor,
    this.modalMaxHeight = 300.0,
    this.closeOnTapOutside = true,
    this.tooltip,
    this.sortOrder = 0,
    this.position = VooActionItemPosition.center,
  });

  /// Creates a copy of this item with the given fields replaced
  VooActionNavigationItem copyWith({
    String? id,
    IconData? icon,
    IconData? activeIcon,
    Color? iconColor,
    Color? backgroundColor,
    Widget Function(BuildContext context, VoidCallback close)? modalBuilder,
    double? modalMaxHeight,
    bool? closeOnTapOutside,
    String? tooltip,
    int? sortOrder,
    VooActionItemPosition? position,
  }) {
    return VooActionNavigationItem(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      modalBuilder: modalBuilder ?? this.modalBuilder,
      modalMaxHeight: modalMaxHeight ?? this.modalMaxHeight,
      closeOnTapOutside: closeOnTapOutside ?? this.closeOnTapOutside,
      tooltip: tooltip ?? this.tooltip,
      sortOrder: sortOrder ?? this.sortOrder,
      position: position ?? this.position,
    );
  }

  /// Gets the effective active icon (defaults to close icon)
  IconData get effectiveActiveIcon => activeIcon ?? Icons.close;
}

/// Position of the action item in the expandable bottom navigation bar.
enum VooActionItemPosition {
  /// Position the action item at the start (left) of the navigation bar
  start,

  /// Position the action item in the center of the navigation bar
  center,

  /// Position the action item at the end (right) of the navigation bar
  end,
}
