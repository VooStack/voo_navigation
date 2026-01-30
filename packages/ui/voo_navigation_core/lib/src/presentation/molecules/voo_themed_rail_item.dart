import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_animated_badge.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_edge_bar_indicator.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A themed rail navigation item with edge indicator
///
/// Specialized for vertical rail navigation with optional edge bar
class VooThemedRailItem extends StatefulWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The navigation item data
  final VooNavigationDestination item;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when the item is tapped
  final VoidCallback? onTap;

  /// Whether to show the label
  final bool showLabel;

  /// Whether to show the edge indicator
  final bool showEdgeIndicator;

  /// Custom selected color
  final Color? selectedColor;

  /// Width of the rail item
  final double width;

  const VooThemedRailItem({
    super.key,
    required this.theme,
    required this.item,
    required this.isSelected,
    this.onTap,
    this.showLabel = false,
    this.showEdgeIndicator = true,
    this.selectedColor,
    this.width = 72,
  });

  @override
  State<VooThemedRailItem> createState() => _VooThemedRailItemState();
}

class _VooThemedRailItemState extends State<VooThemedRailItem> {
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
        child: SizedBox(
          width: widget.width,
          child: Row(
            children: [
              // Edge indicator
              if (widget.showEdgeIndicator)
                VooEdgeBarIndicator(
                  theme: widget.theme,
                  isSelected: widget.isSelected,
                  color: selectedColor,
                ),

              // Item content
              Expanded(
                child: AnimatedContainer(
                  duration: widget.theme.animationDuration,
                  curve: widget.theme.animationCurve,
                  padding: EdgeInsets.symmetric(
                    vertical: spacing.sm,
                    horizontal: spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _isHovered && !widget.isSelected
                        ? colorScheme.onSurface.withValues(alpha: 0.04)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: effectiveColor,
                              size: 24,
                            ),
                            child: widget.isSelected
                                ? widget.item.effectiveSelectedIcon
                                : widget.item.icon,
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

                      // Label
                      if (widget.showLabel) ...[
                        SizedBox(height: spacing.xxs),
                        Text(
                          widget.item.label,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: effectiveColor,
                                    fontWeight: widget.isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
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
