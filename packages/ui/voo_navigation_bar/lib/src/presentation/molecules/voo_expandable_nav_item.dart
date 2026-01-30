import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

/// Position of the label relative to the icon in expanded state
enum VooExpandableLabelPosition {
  /// Label appears after the icon (to the right in LTR) - expands right
  end,

  /// Label appears before the icon (to the left in LTR) - expands left
  start,
}

/// A navigation item for the expandable bottom navigation bar.
///
/// When selected, the item expands to show the label, pushing other items aside.
/// The icon stays centered within its circle, and the background pill expands
/// to accommodate the label.
class VooExpandableNavItem extends StatefulWidget {
  final VooNavigationDestination item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final VooExpandableLabelPosition labelPosition;
  final Duration animationDuration;
  final Curve animationCurve;

  /// Maximum width for the label. Defaults to 60dp.
  final double maxLabelWidth;

  const VooExpandableNavItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.labelPosition = VooExpandableLabelPosition.end,
    this.animationDuration = const Duration(
      milliseconds: VooNavigationTokens.expandableNavAnimationDurationMs,
    ),
    this.animationCurve = Curves.easeOutCubic,
    this.maxLabelWidth = 60.0,
  });

  @override
  State<VooExpandableNavItem> createState() => _VooExpandableNavItemState();
}

class _VooExpandableNavItemState extends State<VooExpandableNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _labelOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Use different curves for expand vs collapse to sync animations:
    // - Expand (forward): easeOutCubic - slow start, fast finish
    // - Collapse (reverse): easeInCubic - fast start, slow finish
    // This ensures collapsing item frees up space as expanding item grows
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
      reverseCurve: Curves.easeInCubic,
    );

    _labelOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(VooExpandableNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _measureLabelWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.item.label,
        style: TextStyle(
          fontSize: VooNavigationTokens.expandableNavLabelFontSize,
          fontWeight: VooNavigationTokens.expandableNavLabelFontWeight,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return (textPainter.width.ceilToDouble() + 2).clamp(0.0, widget.maxLabelWidth);
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = VooNavigationTokens.expandableNavSelectedCircleSize;

    final circleColor = widget.isSelected
        ? context.expandableNavSelectedCircle(widget.selectedColor)
        : context.expandableNavUnselectedCircle;

    final iconColor = widget.isSelected
        ? context.expandableNavSelectedIcon
        : context.expandableNavUnselectedIcon;

    final icon = widget.isSelected
        ? widget.item.effectiveSelectedIcon
        : widget.item.icon;

    final labelWidth = _measureLabelWidth();
    const spacing = 8.0;       // Space between circle and text
    const circlePadding = 4.0; // Constant padding around circle (both sides)
    const textPadding = 12.0;  // Space from text to edge of pill

    final isLabelStart = widget.labelPosition == VooExpandableLabelPosition.start;
    final containerHeight = circleSize + (circlePadding * 2);

    // Build the icon circle widget
    Widget buildIconCircle() {
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: circleColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(
              color: iconColor,
              size: VooNavigationTokens.iconSizeCompact,
            ),
            child: icon,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _expandAnimation.value.clamp(0.0, 1.0);
          final labelProgress = _labelOpacity.value.clamp(0.0, 1.0);

          // Calculate animated values (circlePadding stays constant for symmetry)
          final animatedLabelWidth = labelWidth * progress;
          final animatedSpacing = spacing * progress;
          final animatedTextPadding = textPadding * progress;

          // Build label widget
          final label = Opacity(
            opacity: labelProgress,
            child: Text(
              widget.item.label,
              style: TextStyle(
                color: context.expandableNavSelectedLabel,
                fontSize: VooNavigationTokens.expandableNavLabelFontSize,
                fontWeight: VooNavigationTokens.expandableNavLabelFontWeight,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
            ),
          );

          // Build row contents based on label position
          // Circle always has consistent padding on both sides
          List<Widget> rowChildren;
          if (isLabelStart) {
            // Label on left, circle on right
            rowChildren = [
              SizedBox(width: animatedTextPadding),
              SizedBox(
                width: animatedLabelWidth,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: label,
                ),
              ),
              SizedBox(width: animatedSpacing),
              const SizedBox(width: circlePadding),
              buildIconCircle(),
              const SizedBox(width: circlePadding),
            ];
          } else {
            // Circle on left, label on right
            rowChildren = [
              const SizedBox(width: circlePadding),
              buildIconCircle(),
              const SizedBox(width: circlePadding),
              SizedBox(width: animatedSpacing),
              SizedBox(
                width: animatedLabelWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: label,
                ),
              ),
              SizedBox(width: animatedTextPadding),
            ];
          }

          return Container(
            height: containerHeight,
            decoration: BoxDecoration(
              color: progress > 0
                  ? context.expandableNavSelectedBackground.withValues(alpha: progress)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(containerHeight / 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: rowChildren,
            ),
          );
        },
      ),
    );
  }
}
