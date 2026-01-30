import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_animated_badge.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_line_indicator.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_themed_indicator.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A themed navigation item widget
///
/// Renders a navigation item with the appropriate visual style based on theme:
/// - Handles selection state and animations
/// - Displays icon, label, and badge
/// - Supports hover states (for desktop)
/// - Applies theme-specific indicators
///
/// ```dart
/// VooThemedNavItem(
///   theme: config.effectiveTheme,
///   item: navigationItem,
///   isSelected: isCurrentItem,
///   onTap: () => handleSelect(item.id),
/// )
/// ```
class VooThemedNavItem extends StatefulWidget {
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

  /// Custom selected color (overrides theme)
  final Color? selectedColor;

  /// Custom unselected color (overrides theme)
  final Color? unselectedColor;

  /// Whether to enable haptic feedback on tap
  final bool enableHapticFeedback;

  /// Orientation of the item (vertical for rail, horizontal for bottom nav)
  final Axis orientation;

  /// Line indicator position (for minimal theme)
  final VooLineIndicatorPosition lineIndicatorPosition;

  const VooThemedNavItem({
    super.key,
    required this.theme,
    required this.item,
    required this.isSelected,
    this.onTap,
    this.showLabel = true,
    this.selectedColor,
    this.unselectedColor,
    this.enableHapticFeedback = true,
    this.orientation = Axis.vertical,
    this.lineIndicatorPosition = VooLineIndicatorPosition.bottom,
  });

  @override
  State<VooThemedNavItem> createState() => _VooThemedNavItemState();
}

class _VooThemedNavItemState extends State<VooThemedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void didUpdateWidget(VooThemedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _playBounce();
    }
  }

  void _playBounce() {
    _bounceController.forward(from: 0);
  }

  void _handleTap() {
    if (!widget.item.isEnabled) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spacing = context.vooSpacing;

    final selectedColor =
        widget.selectedColor ?? widget.theme.resolveIndicatorColor(context);
    final unselectedColor =
        widget.unselectedColor ?? colorScheme.onSurfaceVariant;

    final effectiveColor = widget.isSelected ? selectedColor : unselectedColor;

    // Build the icon with badge
    Widget iconWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedSwitcher(
          duration: widget.theme.animationDuration,
          switchInCurve: widget.theme.animationCurve,
          switchOutCurve: Curves.easeIn,
          child: Icon(
            widget.isSelected
                ? widget.item.effectiveSelectedIcon
                : widget.item.icon,
            key: ValueKey(widget.isSelected),
            color: effectiveColor,
            size: 24,
          ),
        ),
        if (widget.item.hasBadge)
          Positioned(
            top: -6,
            right: -10,
            child: VooAnimatedBadge(
              item: widget.item,
              isSelected: widget.isSelected,
            ),
          ),
      ],
    );

    // Build the content based on orientation
    Widget content;
    if (widget.orientation == Axis.vertical) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          if (widget.showLabel) ...[
            SizedBox(height: spacing.xxs),
            AnimatedDefaultTextStyle(
              duration: widget.theme.animationDuration,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: effectiveColor,
                    fontWeight:
                        widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 11,
                  ),
              child: Text(
                widget.item.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          if (widget.showLabel) ...[
            SizedBox(width: spacing.sm),
            AnimatedDefaultTextStyle(
              duration: widget.theme.animationDuration,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: effectiveColor,
                    fontWeight:
                        widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
              child: Text(
                widget.item.label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ],
      );
    }

    // Wrap with themed indicator
    content = VooThemedIndicator(
      theme: widget.theme,
      isSelected: widget.isSelected,
      child: content,
    );

    // Apply scale animation on selection
    content = AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        final scale = widget.isSelected
            ? 1.0 + (_bounceAnimation.value - 1.0) * 0.1
            : (_isPressed ? 0.95 : 1.0);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: content,
    );

    // Apply hover effect for desktop
    content = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedOpacity(
        duration: widget.theme.animationDuration,
        opacity: widget.item.isEnabled
            ? (_isHovered ? 0.9 : 1.0)
            : 0.5,
        child: content,
      ),
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.item.isEnabled ? _handleTap : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.sm),
        child: content,
      ),
    );
  }
}
