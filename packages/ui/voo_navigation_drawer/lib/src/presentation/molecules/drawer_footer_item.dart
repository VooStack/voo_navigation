import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Single footer item widget for navigation drawer
class VooDrawerFooterItem extends StatelessWidget {
  /// The navigation item
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Whether the item is currently hovered
  final bool isHovered;

  /// Callback when hover state changes
  final void Function(bool isHovered) onHoverChanged;

  const VooDrawerFooterItem({
    super.key,
    required this.item,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = item.id == selectedId;

    final unselectedColor = config.unselectedItemColor ?? theme.colorScheme.onSurface;
    final selectedColor = config.selectedItemColor ?? theme.colorScheme.primary;

    final iconColor = isSelected
        ? (item.selectedIconColor ?? selectedColor)
        : (item.iconColor ?? unselectedColor.withValues(alpha: 0.7));

    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: unselectedColor,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    );

    return Semantics(
      label: item.effectiveSemanticLabel,
      button: true,
      enabled: item.isEnabled,
      selected: isSelected,
      child: MouseRegion(
        onEnter: (_) => onHoverChanged(true),
        onExit: (_) => onHoverChanged(false),
        child: InkWell(
          key: item.key,
          onTap: item.isEnabled ? () => onItemTap(item) : null,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: context.vooAnimation.durationFast,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedColor.withValues(alpha: 0.1)
                  : isHovered
                      ? unselectedColor.withValues(alpha: 0.04)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.effectiveSelectedIcon : item.icon,
                  color: iconColor,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: labelStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
