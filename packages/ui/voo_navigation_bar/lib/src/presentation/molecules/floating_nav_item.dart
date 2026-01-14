import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';

/// Single navigation item for the floating bottom navigation bar
class VooFloatingNavItem extends StatelessWidget {
  /// The navigation item data
  final VooNavigationItem item;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when the item is tapped
  final VoidCallback onTap;

  const VooFloatingNavItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = context.floatingNavForeground;
    final selectedColor = context.floatingNavSelectedColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 52,
        height: 52,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.effectiveSelectedIcon : item.icon,
              color: isSelected
                  ? selectedColor
                  : foreground.withValues(alpha: VooNavigationTokens.opacityDisabled),
              size: VooNavigationTokens.iconSizeCompact,
            ),
          ],
        ),
      ),
    );
  }
}
