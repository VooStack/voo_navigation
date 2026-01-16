import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_modern_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Navigation item widget for drawer
class VooDrawerNavigationItem extends StatelessWidget {
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

  const VooDrawerNavigationItem({
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

    // Resolve colors from item, config, or theme (in that priority order)
    final unselectedColor = config.unselectedItemColor ?? theme.colorScheme.onSurface;
    final selectedColor = config.selectedItemColor ?? theme.colorScheme.primary;

    final iconColor = isSelected
        ? (item.selectedIconColor ?? selectedColor)
        : (item.iconColor ?? unselectedColor.withValues(alpha: VooNavigationTokens.opacityMutedIcon));

    // Resolve label style
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: unselectedColor,
      fontWeight: isSelected ? VooNavigationTokens.labelFontWeightSelected : VooNavigationTokens.labelFontWeight,
      fontSize: VooNavigationTokens.labelFontSize,
    );

    Widget itemContent = AnimatedContainer(
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
          // Leading widget or Icon
          if (item.leadingWidget != null)
            item.leadingWidget!
          else
            AnimatedSwitcher(
              duration: context.vooAnimation.durationFast,
              child: Icon(
                isSelected ? item.effectiveSelectedIcon : item.icon,
                key: ValueKey(isSelected),
                color: iconColor,
                size: VooNavigationTokens.iconSizeDefault,
              ),
            ),

          const SizedBox(width: VooNavigationTokens.iconLabelSpacing),

          // Label
          Expanded(
            child: Text(
              item.label,
              style: labelStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Modern badge
          if (item.hasBadge) ...[
            SizedBox(width: context.vooSpacing.xs),
            VooDrawerModernBadge(item: item, isSelected: isSelected),
          ],

          // Trailing widget
          if (item.trailingWidget != null) ...[
            SizedBox(width: context.vooSpacing.xs),
            item.trailingWidget!,
          ],
        ],
      ),
    );

    // Wrap with tooltip if provided
    if (item.tooltip != null) {
      itemContent = Tooltip(
        message: item.effectiveTooltip,
        child: itemContent,
      );
    }

    // Wrap with semantics for accessibility
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
          child: itemContent,
        ),
      ),
    );
  }
}
