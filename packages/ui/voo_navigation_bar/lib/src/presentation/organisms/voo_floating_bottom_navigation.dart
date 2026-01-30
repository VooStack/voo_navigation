import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/floating_nav_item.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_core/src/presentation/molecules/context_switcher_nav_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_nav_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

class VooFloatingBottomNavigation extends StatelessWidget {
  final VooNavigationConfig config;
  final String selectedId;
  final void Function(String itemId) onNavigationItemSelected;
  final double? bottomMargin;
  final Color? backgroundColor;
  final bool enableHapticFeedback;

  const VooFloatingBottomNavigation({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onNavigationItemSelected,
    this.bottomMargin,
    this.backgroundColor,
    this.enableHapticFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    final items = config.mobilePriorityItems;
    final spacing = context.vooSpacing;

    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? context.floatingNavBackground;
    final margin = bottomMargin ?? (spacing.lg > 0 ? spacing.lg : 24.0);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, margin),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(VooNavigationTokens.floatingNavBorderRadius),
            boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items.map((item) {
              final isSelected = item.id == selectedId;

              if (item.id == VooContextSwitcherNavItem.navItemId && config.contextSwitcher != null) {
                return VooContextSwitcherNavItem(
                  config: config.contextSwitcher!,
                  isSelected: false,
                  isCompact: true,
                  useFloatingStyle: true,
                  enableHapticFeedback: enableHapticFeedback,
                );
              }

              if (item.id == VooMultiSwitcherNavItem.navItemId && config.multiSwitcher != null) {
                return VooMultiSwitcherNavItem(
                  config: config.multiSwitcher!,
                  isSelected: false,
                  isCompact: true,
                  useFloatingStyle: true,
                  enableHapticFeedback: enableHapticFeedback,
                );
              }

              return VooFloatingNavItem(
                item: item,
                isSelected: isSelected,
                onTap: () {
                  if (enableHapticFeedback) {
                    HapticFeedback.selectionClick();
                  }
                  onNavigationItemSelected(item.id);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
