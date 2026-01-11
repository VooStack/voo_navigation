import 'package:flutter/widgets.dart';

/// InheritedWidget that provides collapse state to descendants.
///
/// This allows child widgets like [VooUserProfileFooter] and [VooOrganizationSwitcher]
/// to automatically detect whether they're in a collapsed navigation context
/// and adjust their appearance accordingly.
///
/// Example usage:
/// ```dart
/// VooCollapseState(
///   isCollapsed: true,
///   onToggleCollapse: () => toggleCollapse(),
///   child: MyNavigationContent(),
/// )
/// ```
///
/// Child widgets can access the state using:
/// ```dart
/// final isCollapsed = VooCollapseState.isCollapsedOf(context);
/// ```
class VooCollapseState extends InheritedWidget {
  /// Whether the navigation is currently collapsed.
  final bool isCollapsed;

  /// Optional callback to toggle the collapse state.
  final VoidCallback? onToggleCollapse;

  const VooCollapseState({
    super.key,
    required this.isCollapsed,
    this.onToggleCollapse,
    required super.child,
  });

  /// Returns the [VooCollapseState] from the closest ancestor, or null if none exists.
  static VooCollapseState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VooCollapseState>();
  }

  /// Returns the [VooCollapseState] from the closest ancestor.
  ///
  /// Throws if no [VooCollapseState] is found in the widget tree.
  static VooCollapseState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, 'No VooCollapseState found in context');
    return state!;
  }

  /// Returns whether the navigation is collapsed.
  ///
  /// If no [VooCollapseState] exists in the widget tree, returns [defaultValue]
  /// (defaults to false, meaning expanded).
  static bool isCollapsedOf(BuildContext context, {bool defaultValue = false}) {
    return maybeOf(context)?.isCollapsed ?? defaultValue;
  }

  /// Returns the toggle callback if available.
  static VoidCallback? toggleCallbackOf(BuildContext context) {
    return maybeOf(context)?.onToggleCollapse;
  }

  @override
  bool updateShouldNotify(VooCollapseState oldWidget) {
    return isCollapsed != oldWidget.isCollapsed ||
        onToggleCollapse != oldWidget.onToggleCollapse;
  }
}
