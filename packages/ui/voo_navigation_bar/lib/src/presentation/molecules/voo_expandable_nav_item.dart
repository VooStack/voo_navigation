import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/atoms/voo_expandable_nav_item_layout.dart';

enum VooExpandableLabelPosition { end, start }

class VooExpandableNavItem extends StatefulWidget {
  final VooNavigationDestination item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final VooExpandableLabelPosition labelPosition;
  final Duration animationDuration;
  final Curve animationCurve;
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

  @override
  Widget build(BuildContext context) {
    // Get colors based on selection state
    final circleColor = widget.isSelected
        ? context.expandableNavSelectedCircle(widget.selectedColor)
        : context.expandableNavUnselectedCircle;

    final iconColor = widget.isSelected
        ? context.expandableNavSelectedIcon
        : context.expandableNavUnselectedIcon;

    final icon =
        widget.isSelected ? widget.item.effectiveSelectedIcon : widget.item.icon;

    // Measure label width
    final labelWidth = VooExpandableNavItemLayout.measureLabelWidth(
      widget.item.label,
      widget.maxLabelWidth,
    );

    // Build the icon circle using shared layout
    final circle = VooExpandableNavItemLayout.buildCircle(
      color: circleColor,
      child: IconTheme(
        data: IconThemeData(
          color: iconColor,
          size: VooNavigationTokens.iconSizeCompact,
        ),
        child: icon,
      ),
    );

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _expandAnimation.value.clamp(0.0, 1.0);
          final labelProgress = _labelOpacity.value.clamp(0.0, 1.0);

          // Calculate animated values
          final animatedLabelWidth =
              labelWidth * progress;
          final animatedSpacing =
              VooExpandableNavItemLayout.spacing * progress;
          final animatedTextPadding =
              VooExpandableNavItemLayout.textPadding * progress;

          // Build label using shared layout
          final label = VooExpandableNavItemLayout.buildLabel(
            text: widget.item.label,
            opacity: labelProgress,
            color: context.expandableNavSelectedLabel,
          );

          // Build row children using shared layout (single source of truth)
          final rowChildren = VooExpandableNavItemLayout.buildRowChildren(
            circle: circle,
            label: label,
            animatedLabelWidth: animatedLabelWidth,
            animatedSpacing: animatedSpacing,
            animatedTextPadding: animatedTextPadding,
            labelPosition: widget.labelPosition,
          );

          // Build container using shared layout
          return VooExpandableNavItemLayout.buildContainer(
            rowChildren: rowChildren,
            progress: progress,
            selectedBackgroundColor: context.expandableNavSelectedBackground,
          );
        },
      ),
    );
  }
}
