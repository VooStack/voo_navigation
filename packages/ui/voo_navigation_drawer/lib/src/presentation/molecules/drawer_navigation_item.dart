import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
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
    final iconColor = isSelected
        ? (item.selectedIconColor ?? config.selectedItemColor ?? theme.colorScheme.primary)
        : (item.iconColor ?? config.unselectedItemColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.8));

    // Resolve label style from item or theme, using config colors when provided
    final selectedLabelColor = config.selectedItemColor ?? theme.colorScheme.primary;
    final unselectedLabelColor = config.unselectedItemColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.85);

    final defaultLabelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isSelected ? selectedLabelColor : unselectedLabelColor,
      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
      fontSize: 13,
    );
    final labelStyle = isSelected
        ? (item.selectedLabelStyle ?? defaultLabelStyle)
        : (item.labelStyle ?? defaultLabelStyle);

    Widget itemContent = AnimatedContainer(
      duration: context.vooAnimation.durationFast,
      padding: EdgeInsets.symmetric(
        horizontal: context.vooSpacing.xs + 2,
        vertical: context.vooSpacing.xxs + 2,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.onSurface.withValues(alpha: 0.08)
            : isHovered
            ? theme.colorScheme.onSurface.withValues(alpha: 0.04)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(context.vooRadius.md),
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
                size: 18,
              ),
            ),

          SizedBox(width: context.vooSpacing.xs),

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
            SizedBox(width: context.vooSpacing.sm),
            VooDrawerModernBadge(item: item, isSelected: isSelected),
          ],

          // Trailing widget
          if (item.trailingWidget != null) ...[
            SizedBox(width: context.vooSpacing.sm),
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
        child: Padding(
          key: item.key,
          padding: EdgeInsets.only(bottom: 1),
          child: InkWell(
            onTap: item.isEnabled ? () => onItemTap(item) : null,
            borderRadius: BorderRadius.circular(context.vooRadius.lg),
            child: itemContent,
          ),
        ),
      ),
    );
  }
}
