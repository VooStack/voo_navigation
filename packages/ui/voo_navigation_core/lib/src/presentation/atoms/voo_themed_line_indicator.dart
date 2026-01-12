import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_line_indicator.dart';

/// Line-style themed indicator widget
class VooThemedLineIndicator extends StatelessWidget {
  /// Navigation theme
  final VooNavigationTheme theme;

  /// Whether the indicator is selected
  final bool isSelected;

  /// Indicator color
  final Color indicatorColor;

  /// Position of the line
  final VooLineIndicatorPosition linePosition;

  /// Child widget
  final Widget child;

  const VooThemedLineIndicator({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.indicatorColor,
    required this.linePosition,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isHorizontal = linePosition == VooLineIndicatorPosition.bottom ||
        linePosition == VooLineIndicatorPosition.top;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: child,
        ),
        Positioned(
          left: linePosition == VooLineIndicatorPosition.left ? 0 : null,
          right: linePosition == VooLineIndicatorPosition.right ? 0 : null,
          top: linePosition == VooLineIndicatorPosition.top ? 0 : null,
          bottom: linePosition == VooLineIndicatorPosition.bottom ? 0 : null,
          child: AnimatedContainer(
            duration: theme.animationDuration,
            curve: theme.animationCurve,
            width: isHorizontal ? (isSelected ? 24 : 0) : 3,
            height: isHorizontal ? 3 : (isSelected ? 24 : 0),
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ],
    );
  }
}
