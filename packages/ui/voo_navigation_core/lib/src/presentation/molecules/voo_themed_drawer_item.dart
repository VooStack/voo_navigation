import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_animated_badge.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A themed drawer navigation item
///
/// Specialized for horizontal drawer navigation with full labels
class VooThemedDrawerItem extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The navigation item data
  final VooNavigationItem item;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when the item is tapped
  final VoidCallback? onTap;

  /// Custom selected color
  final Color? selectedColor;

  /// Whether this is a child item (indented)
  final bool isChild;

  const VooThemedDrawerItem({
    super.key,
    required this.theme,
    required this.item,
    required this.isSelected,
    this.onTap,
    this.selectedColor,
    this.isChild = false,
  });

  @override
  State<VooThemedDrawerItem> createState() => _VooThemedDrawerItemState();
}

class _VooThemedDrawerItemState extends State<VooThemedDrawerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.vooSpacing;

    final selectedColor =
        widget.selectedColor ?? widget.theme.resolveIndicatorColor(context);
    final unselectedColor = colorScheme.onSurfaceVariant;
    final effectiveColor = widget.isSelected ? selectedColor : unselectedColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.item.isEnabled ? widget.onTap : null,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: widget.theme.animationDuration,
          curve: widget.theme.animationCurve,
          margin: EdgeInsets.symmetric(
            horizontal: spacing.sm,
            vertical: spacing.xxs,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ).copyWith(
            left: widget.isChild ? spacing.xl : spacing.md,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? selectedColor.withValues(alpha: 0.12)
                : _isHovered
                    ? colorScheme.onSurface.withValues(alpha: 0.04)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Edge indicator for selected
              if (widget.isSelected)
                Container(
                  width: 3,
                  height: 24,
                  margin: EdgeInsets.only(right: spacing.sm),
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),

              // Icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    widget.isSelected
                        ? widget.item.effectiveSelectedIcon
                        : widget.item.icon,
                    color: effectiveColor,
                    size: 24,
                  ),
                  if (widget.item.hasBadge)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: VooAnimatedBadge(
                        item: widget.item,
                        isSelected: widget.isSelected,
                      ),
                    ),
                ],
              ),

              SizedBox(width: spacing.md),

              // Label
              Expanded(
                child: Text(
                  widget.item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: effectiveColor,
                        fontWeight:
                            widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              // Trailing badge count
              if (widget.item.badgeCount != null && widget.item.badgeCount! > 0)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.xs,
                    vertical: spacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.item.badgeCount! > 99
                        ? '99+'
                        : widget.item.badgeCount.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.w600,
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
