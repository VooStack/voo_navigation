import 'package:flutter/material.dart';

/// Left edge accent bar indicator for selected items
class VooEdgeIndicator extends StatelessWidget {
  /// Whether the indicator is visible
  final bool isActive;

  /// The color of the indicator
  final Color color;

  /// Height of the indicator (usually matches item height)
  final double height;

  /// Width of the indicator bar
  final double width;

  /// Border radius
  final BorderRadius? borderRadius;

  const VooEdgeIndicator({
    super.key,
    required this.isActive,
    required this.color,
    this.height = 32,
    this.width = 3,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: width,
      height: isActive ? height : 0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ??
            BorderRadius.only(
              topRight: Radius.circular(width),
              bottomRight: Radius.circular(width),
            ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ]
            : null,
      ),
    );
  }
}
