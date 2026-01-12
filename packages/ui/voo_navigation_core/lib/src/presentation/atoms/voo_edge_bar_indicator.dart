import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// A vertical edge indicator for navigation rails
///
/// Displays a colored bar on the left edge of selected items
class VooEdgeBarIndicator extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// Whether the indicator is active
  final bool isSelected;

  /// Height of the indicator
  final double height;

  /// Width of the indicator bar
  final double width;

  /// Custom indicator color (overrides theme)
  final Color? color;

  const VooEdgeBarIndicator({
    super.key,
    required this.theme,
    required this.isSelected,
    this.height = 32,
    this.width = 3,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? theme.resolveIndicatorColor(context);

    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      width: width,
      height: isSelected ? height : 0,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(width),
          bottomRight: Radius.circular(width),
        ),
      ),
    );
  }
}
