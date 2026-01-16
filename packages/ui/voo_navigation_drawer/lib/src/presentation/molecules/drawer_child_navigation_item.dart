import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
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

    // Calculate line position to align with parent icon center
    // Parent icon center = itemPaddingHorizontal + iconSizeDefault/2
    // Line center should be at the same position
    const double lineWidth = 2;
    const double lineMarginLeft = VooNavigationTokens.iconSizeDefault / 2 - lineWidth / 2; // 8dp

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: Padding(
        padding: const EdgeInsets.only(left: VooNavigationTokens.itemPaddingHorizontal),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thin vertical line indicator - highlights when selected
              // Positioned to align with section icon center
              if (showVerticalLine)
                Container(
                  width: lineWidth,
                  margin: EdgeInsets.only(
                    left: lineMarginLeft,
                    right: context.vooSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor
                        : unselectedColor.withValues(alpha: VooNavigationTokens.opacityBorderSubtle),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              // Item content
              Expanded(
                child: InkWell(
                  onTap: item.isEnabled ? () => onItemTap(item) : null,
                  borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
                  child: AnimatedContainer(
                    duration: context.vooAnimation.durationFast,
                    padding: const EdgeInsets.symmetric(
                      horizontal: VooNavigationTokens.itemPaddingHorizontal,
                      vertical: VooNavigationTokens.itemChildPaddingVertical,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.navSelectedBackground(selectedColor)
                          : isHovered
                              ? context.navHoverBackground
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
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
                                  : unselectedColor.withValues(alpha: VooNavigationTokens.opacityMutedIcon),
                              fontWeight: isSelected ? VooNavigationTokens.labelFontWeightSelected : FontWeight.w400,
                              fontSize: VooNavigationTokens.labelFontSize,
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
