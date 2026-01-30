import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Single footer item widget for navigation drawer
class VooDrawerFooterItem extends StatelessWidget {
  /// The navigation item
  final VooNavigationDestination item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when item is tapped
  final void Function(VooNavigationDestination item) onItemTap;

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
        : (item.iconColor ?? unselectedColor.withValues(alpha: VooNavigationTokens.opacityMutedIcon));

    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: unselectedColor,
      fontWeight: isSelected ? VooNavigationTokens.labelFontWeightSelected : VooNavigationTokens.labelFontWeight,
      fontSize: VooNavigationTokens.labelFontSize,
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
          borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: context.vooAnimation.durationFast,
            padding: const EdgeInsets.symmetric(
              horizontal: VooNavigationTokens.itemPaddingHorizontal,
              vertical: VooNavigationTokens.itemPaddingVertical,
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
                Icon(
                  isSelected ? item.effectiveSelectedIcon : item.icon,
                  color: iconColor,
                  size: VooNavigationTokens.iconSizeDefault,
                ),
                const SizedBox(width: VooNavigationTokens.iconLabelSpacing),
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
