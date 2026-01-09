import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_modern_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Child navigation item widget for drawer expandable sections
class VooDrawerChildNavigationItem extends StatelessWidget {
  /// The navigation item
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Whether this item is hovered
  final bool isHovered;

  /// Callback to set hover state
  final void Function(bool isHovered) onHoverChanged;

  const VooDrawerChildNavigationItem({
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

    // Resolve colors from config or theme
    final unselectedColor = config.unselectedItemColor ?? theme.colorScheme.onSurface;

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Padding(
        padding: EdgeInsets.only(
          left: context.vooSpacing.lg + 4,
          bottom: 0,
        ),
        child: InkWell(
          onTap: item.isEnabled ? () => onItemTap(item) : null,
          borderRadius: BorderRadius.circular(context.vooRadius.xs),
          child: AnimatedContainer(
            duration: context.vooAnimation.durationFast,
            padding: EdgeInsets.symmetric(
              horizontal: context.vooSpacing.xs,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? unselectedColor.withValues(alpha: 0.06)
                  : isHovered
                  ? unselectedColor.withValues(alpha: 0.03)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(context.vooRadius.xs),
            ),
            child: Row(
              children: [
                // Label - just text, no dot or icon
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? unselectedColor
                          : unselectedColor.withValues(alpha: 0.65),
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.w400,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Badge
                if (item.hasBadge) ...[
                  SizedBox(width: context.vooSpacing.xs),
                  VooDrawerModernBadge(item: item, isSelected: isSelected),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
