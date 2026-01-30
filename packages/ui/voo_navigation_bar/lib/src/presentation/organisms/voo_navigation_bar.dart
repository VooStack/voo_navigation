import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_action_nav_item.dart';

/// An expandable bottom navigation bar with pill-shaped design.
///
/// Features:
/// - Dark pill-shaped container with subtle border
/// - Selected item expands to show colored circle icon + label in a container
/// - Unselected items display as dark circles with muted icons
/// - Optional action item (e.g., plus button) with custom modal
/// - Items are distributed evenly across the bar
///
/// Example:
/// ```dart
/// VooNavigationBar(
///   config: config,
///   selectedId: 'home',
///   onNavigationItemSelected: (id) => setState(() => _selectedId = id),
///   actionItem: VooActionNavigationItem(
///     id: 'add',
///     icon: Icons.add,
///     modalBuilder: (context, close) => Column(
///       children: [
///         ListTile(title: Text('New Note'), onTap: close),
///         ListTile(title: Text('New Task'), onTap: close),
///       ],
///     ),
///   ),
/// )
/// ```
class VooNavigationBar extends StatelessWidget {
  /// Navigation configuration containing the items to display
  final VooNavigationConfig config;

  /// Currently selected navigation item ID
  final String selectedId;

  /// Callback when a navigation item is selected
  final void Function(String itemId) onNavigationItemSelected;

  /// Optional action item that displays a modal when tapped
  final VooActionNavigationItem? actionItem;

  /// Bottom margin for the navigation bar
  final double? bottomMargin;

  /// Custom background color for the navigation bar
  final Color? backgroundColor;

  /// Custom border color for the navigation bar
  final Color? borderColor;

  /// Color for the selected item circle
  final Color? selectedColor;

  /// Whether to enable haptic feedback on item selection
  final bool enableFeedback;

  /// Horizontal margin for the navigation bar
  final double horizontalMargin;

  const VooNavigationBar({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.actionItem,
    this.bottomMargin,
    this.backgroundColor,
    this.borderColor,
    this.selectedColor,
    this.enableFeedback = true,
    this.horizontalMargin = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final items = config.mobilePriorityItems;

    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? context.expandableNavBackground;
    final border = borderColor ?? context.expandableNavBorder;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final margin = bottomMargin ?? 24.0;

    // Build the list of nav item widgets
    final navWidgets = _buildNavigationItems(context, items);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: margin + bottomPadding),
        child: Container(
          height: VooNavigationTokens.expandableNavBarHeight,
          padding: EdgeInsets.symmetric(
            horizontal: VooNavigationTokens.expandableNavBarPaddingHorizontal,
            vertical: VooNavigationTokens.expandableNavBarPaddingVertical,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(
              VooNavigationTokens.expandableNavBorderRadius,
            ),
            border: Border.all(
              color: border,
              width: VooNavigationTokens.expandableNavBorderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _addSpacingBetweenItems(navWidgets),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems(
    BuildContext context,
    List<VooNavigationDestination> items,
  ) {
    final widgets = <Widget>[];

    // Determine action item position
    final actionPosition = actionItem?.position ?? VooActionItemPosition.center;
    final centerIndex = items.length ~/ 2;

    // Track whether we've passed the action item (for label positioning)
    bool passedActionItem = actionItem == null ||
        actionPosition == VooActionItemPosition.end;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isSelected = item.id == selectedId;

      // Insert action item at appropriate position
      if (actionItem != null) {
        if (actionPosition == VooActionItemPosition.start && i == 0) {
          widgets.add(_buildActionItem(context));
          passedActionItem = true;
        } else if (actionPosition == VooActionItemPosition.center && i == centerIndex) {
          widgets.add(_buildActionItem(context));
          passedActionItem = true;
        }
      }

      // Determine label position based on whether we've passed the action item
      // Items after action item should have label on the left (start)
      final labelPosition = passedActionItem
          ? VooExpandableLabelPosition.start
          : VooExpandableLabelPosition.end;

      // Check for special nav items (context switcher, multi-switcher)
      if (item.id == VooContextSwitcherNavItem.navItemId &&
          config.contextSwitcher != null) {
        widgets.add(
          VooContextSwitcherNavItem(
            config: config.contextSwitcher!,
            isSelected: false,
            isCompact: true,
            useFloatingStyle: true,
            enableHapticFeedback: enableFeedback,
          ),
        );
      } else if (item.id == VooMultiSwitcherNavItem.navItemId &&
          config.multiSwitcher != null) {
        widgets.add(
          VooMultiSwitcherNavItem(
            config: config.multiSwitcher!,
            isSelected: false,
            isCompact: true,
            useFloatingStyle: true,
            enableHapticFeedback: enableFeedback,
          ),
        );
      } else {
        // Regular navigation item
        widgets.add(
          VooExpandableNavItem(
            item: item,
            isSelected: isSelected,
            selectedColor: selectedColor,
            labelPosition: labelPosition,
            onTap: () {
              if (enableFeedback) {
                HapticFeedback.lightImpact();
              }
              onNavigationItemSelected(item.id);
            },
          ),
        );
      }
    }

    // Add action item at end if configured
    if (actionItem != null && actionPosition == VooActionItemPosition.end) {
      widgets.add(_buildActionItem(context));
    }

    return widgets;
  }

  Widget _buildActionItem(BuildContext context) {
    return VooActionNavItem(
      actionItem: actionItem!,
      enableHapticFeedback: enableFeedback,
      circleColor: selectedColor,
    );
  }

  /// Adds fixed spacing between navigation items.
  List<Widget> _addSpacingBetweenItems(List<Widget> widgets) {
    if (widgets.isEmpty) return widgets;

    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        // Fixed spacing between items
        result.add(const SizedBox(width: 12));
      }
    }
    return result;
  }
}
