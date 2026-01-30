import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Section header with expansion tile for navigation rail
class VooRailSectionHeader extends StatelessWidget {
  /// Navigation item representing the section
  final VooNavigationDestination item;

  /// Child widgets for the expanded section
  final List<Widget> children;

  /// Whether the rail is in extended mode
  final bool extended;

  /// Whether a child of this section is currently selected
  final bool hasSelectedChild;

  /// Callback when section is tapped (compact mode)
  final VoidCallback? onTap;

  /// Selected item color (from config)
  final Color? selectedItemColor;

  /// Unselected item color (from config)
  final Color? unselectedItemColor;

  const VooRailSectionHeader({
    super.key,
    required this.item,
    required this.children,
    this.extended = false,
    this.hasSelectedChild = false,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;

    if (extended) {
      // Extended mode: Show label with children
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing.xs,
          horizontal: spacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with label
            Padding(
              padding: EdgeInsets.only(
                left: spacing.xs,
                bottom: spacing.xxs,
                top: spacing.xs,
              ),
              child: Text(
                item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // Children items
            if (item.isExpanded) ...children,
          ],
        ),
      );
    } else {
      // Compact mode: Icon-only with tooltip - NO children shown
      // Children are only visible when the drawer is expanded
      final effectiveSelectedColor = selectedItemColor ?? theme.colorScheme.primary;
      final effectiveUnselectedColor = unselectedItemColor ?? theme.colorScheme.onSurfaceVariant;
      final isDark = theme.brightness == Brightness.dark;

      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: spacing.xxs,
          horizontal: spacing.sm,
        ),
        child: Tooltip(
          message: item.label,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(context.vooRadius.md),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.vooRadius.md),
                color: hasSelectedChild
                    ? effectiveSelectedColor.withValues(alpha: isDark ? 0.2 : 0.12)
                    : Colors.transparent,
              ),
              child: Center(
                child: IconTheme(
                  data: IconThemeData(
                    color: hasSelectedChild
                        ? effectiveSelectedColor
                        : effectiveUnselectedColor,
                    size: 24,
                  ),
                  child: hasSelectedChild || item.isExpanded
                      ? item.selectedIcon ?? item.icon
                      : item.icon,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
