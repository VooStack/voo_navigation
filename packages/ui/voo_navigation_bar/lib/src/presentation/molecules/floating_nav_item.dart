import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';

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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.effectiveSelectedIcon : item.icon,
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
