import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_sliding_pill.dart';

/// A sliding pill indicator for bottom navigation
///
/// Smoothly animates position when selection changes
class VooSlidingPillIndicator extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// Total number of items
  final int itemCount;

  /// Currently selected index
  final int selectedIndex;

  /// Height of the indicator
  final double height;

  /// Vertical offset from top
  final double topOffset;

  /// Custom indicator color (overrides theme)
  final Color? color;

  const VooSlidingPillIndicator({
    super.key,
    required this.theme,
    required this.itemCount,
    required this.selectedIndex,
    this.height = 4,
    this.topOffset = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    final indicatorColor = color ?? theme.resolveIndicatorColor(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / itemCount;
        final pillWidth = itemWidth * 0.65;
        final leftPosition =
            (itemWidth * selectedIndex) + (itemWidth - pillWidth) / 2;

        return AnimatedPositioned(
          duration: theme.animationDuration,
          curve: theme.animationCurve,
          left: leftPosition,
          top: topOffset,
          child: VooSlidingPill(
            theme: theme,
            indicatorColor: indicatorColor,
            pillWidth: pillWidth,
            height: height,
          ),
        );
      },
    );
  }
}
