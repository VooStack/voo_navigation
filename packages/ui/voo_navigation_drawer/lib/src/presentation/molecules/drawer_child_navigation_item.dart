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

  /// Whether to show vertical line on the left
  final bool showVerticalLine;

  const VooDrawerChildNavigationItem({
    super.key,
    required this.item,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.isHovered,
    required this.onHoverChanged,
    this.showVerticalLine = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = item.id == selectedId;

    // Resolve colors from config or theme
    final unselectedColor = config.unselectedItemColor ?? theme.colorScheme.onSurface;
    final selectedColor = config.selectedItemColor ?? theme.colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thin vertical line indicator - highlights when selected
              if (showVerticalLine)
                Container(
                  width: 2,
                  margin: const EdgeInsets.only(left: 2, right: 8, top: 0, bottom: 0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor
                        : unselectedColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              // Item content
              Expanded(
                child: InkWell(
                  onTap: item.isEnabled ? () => onItemTap(item) : null,
                  borderRadius: BorderRadius.circular(6),
                  child: AnimatedContainer(
                    duration: context.vooAnimation.durationFast,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
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
                        // Label - no icon for child items
                        Expanded(
                          child: Text(
                            item.label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? unselectedColor
                                  : unselectedColor.withValues(alpha: 0.7),
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                              fontSize: 13,
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
            ],
          ),
        ),
      ),
    );
  }
}
