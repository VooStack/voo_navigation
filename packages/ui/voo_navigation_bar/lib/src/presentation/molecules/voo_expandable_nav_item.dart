import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

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
    this.animationDuration = const Duration(milliseconds: VooNavigationTokens.expandableNavAnimationDurationMs),
    this.animationCurve = Curves.easeOutCubic,
    this.maxLabelWidth = 60.0,
  });

  @override
  State<VooExpandableNavItem> createState() => _VooExpandableNavItemState();
}

class _VooExpandableNavItemState extends State<VooExpandableNavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _labelOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.animationDuration, vsync: this);

    _expandAnimation = CurvedAnimation(parent: _controller, curve: widget.animationCurve, reverseCurve: Curves.easeInCubic);

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
        style: TextStyle(fontSize: VooNavigationTokens.expandableNavLabelFontSize, fontWeight: VooNavigationTokens.expandableNavLabelFontWeight),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return (textPainter.width.ceilToDouble() + 2).clamp(0.0, widget.maxLabelWidth);
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = VooNavigationTokens.expandableNavSelectedCircleSize;

    final circleColor = widget.isSelected ? context.expandableNavSelectedCircle(widget.selectedColor) : context.expandableNavUnselectedCircle;

    final iconColor = widget.isSelected ? context.expandableNavSelectedIcon : context.expandableNavUnselectedIcon;

    final icon = widget.isSelected ? widget.item.effectiveSelectedIcon : widget.item.icon;

    final labelWidth = _measureLabelWidth();
    const spacing = 6.0;
    const circlePadding = 3.0;
    const textPadding = 10.0;

    final isLabelStart = widget.labelPosition == VooExpandableLabelPosition.start;
    final containerHeight = circleSize + (circlePadding * 2);

    Widget buildIconCircle() {
      return Container(
        width: circleSize,
        height: circleSize,
        margin: EdgeInsets.all(circlePadding),
        decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
        child: Center(
          child: IconTheme(
            data: IconThemeData(color: iconColor, size: VooNavigationTokens.iconSizeCompact),
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

          final animatedLabelWidth = labelWidth * progress;
          final animatedSpacing = spacing * progress;
          final animatedTextPadding = textPadding * progress;

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

          List<Widget> rowChildren;
          if (isLabelStart) {
            rowChildren = [
              SizedBox(width: animatedSpacing),
              SizedBox(width: animatedTextPadding),
              SizedBox(
                width: animatedLabelWidth,
                child: Align(alignment: Alignment.centerRight, child: label),
              ),
              buildIconCircle(),
            ];
          } else {
            rowChildren = [
              buildIconCircle(),
              SizedBox(width: animatedSpacing),
              SizedBox(
                width: animatedLabelWidth,
                child: Align(alignment: Alignment.centerLeft, child: label),
              ),
              SizedBox(width: animatedTextPadding),
              SizedBox(width: animatedSpacing),
            ];
          }

          return Container(
            height: containerHeight,
            decoration: BoxDecoration(
              color: progress > 0 ? context.expandableNavSelectedBackground.withValues(alpha: progress) : Colors.transparent,
              borderRadius: BorderRadius.circular(containerHeight / 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Row(crossAxisAlignment: CrossAxisAlignment.center, children: rowChildren)],
            ),
          );
        },
      ),
    );
  }
}
