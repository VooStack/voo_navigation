import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Sliding pill indicator widget
class VooSlidingPill extends StatelessWidget {
  /// Navigation theme
  final VooNavigationTheme theme;

  /// Indicator color
  final Color indicatorColor;

  /// Width of the pill
  final double pillWidth;

  /// Height of the pill
  final double height;

  const VooSlidingPill({
    super.key,
    required this.theme,
    required this.indicatorColor,
    required this.pillWidth,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pillWidth,
      height: height,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
