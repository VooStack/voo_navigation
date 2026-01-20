import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/context_switcher_nav_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_custom_navigation_item.dart';

/// Custom navigation bar with modern design
class VooCustomNavigationBar extends StatelessWidget {
  /// Navigation items to display
  final List<VooNavigationItem> items;

  /// Currently selected index
  final int selectedIndex;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Scale animations for items
  final List<Animation<double>> scaleAnimations;

  /// Rotation animations for items
  final List<Animation<double>> rotationAnimations;

  /// Custom height
  final double? height;

  /// Whether to show labels
  final bool showLabels;

  /// Whether to show selected labels only
  final bool showSelectedLabels;

  /// Whether to enable feedback
  final bool enableFeedback;

  /// Callback when item is selected
  final void Function(String itemId) onItemSelected;

  const VooCustomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.config,
    required this.scaleAnimations,
    required this.rotationAnimations,
    required this.showLabels,
    required this.showSelectedLabels,
    required this.enableFeedback,
    required this.onItemSelected,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomBarColor = theme.colorScheme.surfaceContainer;
    final isDark = theme.brightness == Brightness.dark;

    // Responsive height based on item count
    final isCompact = items.length >= 5;
    final effectiveHeight = height ?? (isCompact ? 60.0 : 65.0);

    return Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: bottomBarColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: isDark ? 0.15 : 0.1),
            blurRadius: 12,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex;

          // Check if this is the context switcher nav item
          if (item.id == VooContextSwitcherNavItem.navItemId &&
              config.contextSwitcher != null) {
            return Expanded(
              child: VooContextSwitcherNavItem(
                config: config.contextSwitcher!,
                isSelected: false, // Context switcher is never "selected"
                isCompact: true,
                useFloatingStyle: true, // Match clean icon style of nav items
                enableHapticFeedback: enableFeedback,
              ),
            );
          }

          // Check if this is the multi-switcher nav item
          if (item.id == VooMultiSwitcherNavItem.navItemId &&
              config.multiSwitcher != null) {
            return Expanded(
              child: VooMultiSwitcherNavItem(
                config: config.multiSwitcher!,
                isSelected: false, // Multi-switcher is never "selected"
                isCompact: true,
                useFloatingStyle: true, // Match clean icon style of nav items
                enableHapticFeedback: enableFeedback,
              ),
            );
          }

          return Expanded(
            child: VooCustomNavigationItem(
              item: item,
              isSelected: isSelected,
              index: index,
              config: config,
              scaleAnimation: scaleAnimations[index],
              rotationAnimation: rotationAnimations[index],
              showLabels: showLabels,
              showSelectedLabels: showSelectedLabels,
              enableFeedback: enableFeedback,
              itemCount: items.length,
              onTap: () => onItemSelected(item.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}
