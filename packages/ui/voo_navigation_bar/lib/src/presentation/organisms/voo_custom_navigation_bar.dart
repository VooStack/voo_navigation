import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/context_switcher_nav_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_nav_item.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_custom_navigation_item.dart';

class VooCustomNavigationBar extends StatelessWidget {
  final List<VooNavigationItem> items;

  final int selectedIndex;

  final VooNavigationConfig config;

  final List<Animation<double>> scaleAnimations;

  final double? height;

  final bool showLabels;

  final bool showSelectedLabels;

  final bool enableFeedback;

  final void Function(String itemId) onItemSelected;

  const VooCustomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.config,
    required this.scaleAnimations,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex;

          if (item.id == VooContextSwitcherNavItem.navItemId && config.contextSwitcher != null) {
            return Expanded(
              child: VooContextSwitcherNavItem(config: config.contextSwitcher!, isSelected: false, isCompact: true, useFloatingStyle: true, enableHapticFeedback: enableFeedback),
            );
          }

          if (item.id == VooMultiSwitcherNavItem.navItemId && config.multiSwitcher != null) {
            return Expanded(
              child: VooMultiSwitcherNavItem(config: config.multiSwitcher!, isSelected: false, isCompact: true, useFloatingStyle: true, enableHapticFeedback: enableFeedback),
            );
          }

          return Expanded(
            child: VooCustomNavigationItem(
              item: item,
              isSelected: isSelected,
              index: index,
              config: config,
              scaleAnimation: scaleAnimations[index],
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
