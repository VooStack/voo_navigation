import 'package:flutter/material.dart';

/// Configuration for an action navigation item that displays a modal when tapped.
///
/// This is used in the expandable bottom navigation bar to provide
/// a central action button (e.g., a plus button) that opens a custom modal
/// with quick actions.
class VooActionNavigationItem {
  /// Unique identifier for the action item
  final String id;

  /// Icon widget to display when the modal is closed
  final Widget icon;

  /// Icon widget to display when the modal is open (optional, defaults to close icon)
  final Widget? activeIcon;

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
  /// Note: [navItemIndex] takes precedence over this if specified.
  final VooActionItemPosition position;

  /// Explicit index position (0-based) in the mobile bottom navigation bar.
  /// When set, the action item will be inserted at this position instead of
  /// using [position]. Valid values are 0 to 4 (max 5 items in bottom nav).
  /// If null, falls back to [position] behavior.
  final int? navItemIndex;

  const VooActionNavigationItem({
    required this.id,
    required this.icon,
    this.activeIcon,
    required this.modalBuilder,
    this.backgroundColor,
    this.modalMaxHeight = 300.0,
    this.closeOnTapOutside = true,
    this.tooltip,
    this.sortOrder = 0,
    this.position = VooActionItemPosition.center,
    this.navItemIndex,
  });

  /// Creates a copy of this item with the given fields replaced
  VooActionNavigationItem copyWith({
    String? id,
    Widget? icon,
    Widget? activeIcon,
    Color? backgroundColor,
    Widget Function(BuildContext context, VoidCallback close)? modalBuilder,
    double? modalMaxHeight,
    bool? closeOnTapOutside,
    String? tooltip,
    int? sortOrder,
    VooActionItemPosition? position,
    int? navItemIndex,
  }) {
    return VooActionNavigationItem(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      modalBuilder: modalBuilder ?? this.modalBuilder,
      modalMaxHeight: modalMaxHeight ?? this.modalMaxHeight,
      closeOnTapOutside: closeOnTapOutside ?? this.closeOnTapOutside,
      tooltip: tooltip ?? this.tooltip,
      sortOrder: sortOrder ?? this.sortOrder,
      position: position ?? this.position,
      navItemIndex: navItemIndex ?? this.navItemIndex,
    );
  }

  /// Gets the effective active icon (defaults to close icon)
  Widget get effectiveActiveIcon => activeIcon ?? const Icon(Icons.close);
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
