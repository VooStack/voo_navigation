import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_modern_badge.dart';

/// Modern icon widget with badge support for custom navigation
class VooModernIcon extends StatelessWidget {
  /// Navigation item containing icon data
  final VooNavigationItem item;

  /// Whether this item is selected
  final bool isSelected;

  /// Primary color for theming
  final Color primaryColor;

  /// Custom icon size (optional, defaults to 22/20 based on selection)
  final double? iconSize;

  const VooModernIcon({
    super.key,
    required this.item,
    required this.isSelected,
    required this.primaryColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Use custom size or default responsive sizes
    final selectedSize = iconSize ?? 22.0;
    final unselectedSize = iconSize != null ? iconSize! - 2 : 20.0;

    final icon = AnimatedSwitcher(
      duration: context.vooAnimation.durationFast,
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Icon(
        isSelected ? item.effectiveSelectedIcon : item.icon,
        key: ValueKey(isSelected),
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.8),
        size: isSelected ? selectedSize : unselectedSize,
      ),
    );

    if (item.hasBadge) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(
            top: -4,
            right: -4,
            child: VooModernBadge(
              item: item,
              isSelected: isSelected,
              primaryColor: primaryColor,
            ),
          ),
        ],
      );
    }

    return icon;
  }
}
