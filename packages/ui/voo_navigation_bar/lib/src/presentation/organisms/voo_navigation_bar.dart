import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_action_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_context_switcher_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_multi_switcher_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_combined_switcher_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_user_profile_nav_item.dart';

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
    final margin = bottomMargin ?? 8.0;

    // Build the list of nav item widgets
    final navWidgets = _buildNavigationItems(context, items);

    final borderRadius = BorderRadius.circular(
      VooNavigationTokens.expandableNavBorderRadius,
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final maxBarWidth = screenWidth - (horizontalMargin * 2);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: margin + bottomPadding,
          left: horizontalMargin,
          right: horizontalMargin,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxBarWidth),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              height: VooNavigationTokens.expandableNavBarHeight,
              padding: EdgeInsets.symmetric(
                horizontal:
                    VooNavigationTokens.expandableNavBarPaddingHorizontal,
                vertical: VooNavigationTokens.expandableNavBarPaddingVertical,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: borderRadius,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: _addSpacingBetweenItems(navWidgets),
              ),
            ),
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

    // Check if special items are present (they'll be added at the end)
    final hasContextSwitcher = config.contextSwitcher != null &&
        items.any((item) => item.id == VooContextSwitcherNavItem.navItemId);
    final hasMultiSwitcher = config.multiSwitcher != null &&
        items.any((item) => item.id == VooMultiSwitcherNavItem.navItemId);
    final hasUserProfile = config.userProfileConfig != null &&
        items.any((item) => item.id == VooUserProfileNavItem.navItemId);
    final shouldCombineSwitchers = hasContextSwitcher && hasMultiSwitcher;

    // Filter out special items - they'll be added at the end
    final regularItems = items.where((item) =>
        item.id != VooContextSwitcherNavItem.navItemId &&
        item.id != VooMultiSwitcherNavItem.navItemId &&
        item.id != VooUserProfileNavItem.navItemId).toList();

    // Calculate available space for label expansion
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth -
        (horizontalMargin * 2) -
        (VooNavigationTokens.expandableNavBarPaddingHorizontal * 2);

    // Count total items (regular + special + action)
    var totalItems = regularItems.length;
    if (actionItem != null) totalItems++;
    if (shouldCombineSwitchers) {
      totalItems++;
    } else {
      if (hasContextSwitcher) totalItems++;
      if (hasMultiSwitcher) totalItems++;
    }
    if (hasUserProfile) totalItems++;

    // Calculate space used by collapsed items and spacing
    const circleSize = 40.0; // VooNavigationTokens.expandableNavSelectedCircleSize + padding
    const spacing = 12.0;
    final collapsedWidth = (totalItems * circleSize) + ((totalItems - 1) * spacing);

    // Remaining space for label (with buffer for animation smoothness)
    final maxLabelWidth = ((availableWidth - collapsedWidth) * 0.8).clamp(40.0, 80.0);

    // Calculate center index based on regular items only
    final centerIndex = regularItems.length ~/ 2;

    // Track whether we've passed the action item (for label positioning)
    // Default: labels expand right (end)
    // After passing action item: labels expand left (start)
    bool passedActionItem = false;

    for (var i = 0; i < regularItems.length; i++) {
      final item = regularItems[i];
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

      // Regular navigation item
      widgets.add(
        VooExpandableNavItem(
          item: item,
          isSelected: isSelected,
          selectedColor: selectedColor,
          labelPosition: labelPosition,
          maxLabelWidth: maxLabelWidth,
          onTap: () {
            if (enableFeedback) {
              HapticFeedback.lightImpact();
            }
            onNavigationItemSelected(item.id);
          },
        ),
      );
    }

    // Add action item at end if configured (before switchers)
    if (actionItem != null && actionPosition == VooActionItemPosition.end) {
      widgets.add(_buildActionItem(context));
    }

    // Add switcher(s) at the very end
    if (shouldCombineSwitchers) {
      // Combined switcher when both are present
      widgets.add(
        VooCombinedSwitcherNavItem(
          contextConfig: config.contextSwitcher!,
          multiConfig: config.multiSwitcher!,
          enableHapticFeedback: enableFeedback,
          selectedColor: selectedColor,
        ),
      );
    } else {
      // Individual switchers (context switcher first, then multi-switcher)
      if (hasContextSwitcher) {
        widgets.add(
          VooContextSwitcherExpandableNavItem(
            config: config.contextSwitcher!,
            enableHapticFeedback: enableFeedback,
            selectedColor: selectedColor,
          ),
        );
      }
      if (hasMultiSwitcher) {
        widgets.add(
          VooMultiSwitcherExpandableNavItem(
            config: config.multiSwitcher!,
            enableHapticFeedback: enableFeedback,
            selectedColor: selectedColor,
          ),
        );
      }
    }

    // Add user profile at the end if configured
    if (hasUserProfile) {
      widgets.add(
        VooUserProfileNavItem(
          config: config.userProfileConfig!,
          enableHapticFeedback: enableFeedback,
          avatarColor: selectedColor,
          isSelected: selectedId == VooUserProfileNavItem.navItemId,
          labelPosition: VooExpandableLabelPosition.start,
          maxLabelWidth: maxLabelWidth,
        ),
      );
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
