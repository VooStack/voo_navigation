import 'package:flutter/material.dart';

/// Dot badge indicator widget. Flat by default in the minimal aesthetic —
/// callers can still pass a custom [boxShadow] to opt into a glow.
class VooBadgeDot extends StatelessWidget {
  /// Background color of the dot
  final Color bgColor;

  /// Size of the dot
  final double dotSize;

  /// Optional border
  final BoxBorder? border;

  /// Optional shadow (defaults to none).
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
        boxShadow: boxShadow,
      ),
    );
  }
}
