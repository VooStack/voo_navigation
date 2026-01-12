import 'package:flutter/material.dart';

/// Dot badge indicator widget
class VooBadgeDot extends StatelessWidget {
  /// Background color of the dot
  final Color bgColor;

  /// Size of the dot
  final double dotSize;

  /// Optional border
  final BoxBorder? border;

  /// Optional shadow
  final List<BoxShadow>? boxShadow;

  const VooBadgeDot({
    super.key,
    required this.bgColor,
    required this.dotSize,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.4),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
      ),
    );
  }
}
