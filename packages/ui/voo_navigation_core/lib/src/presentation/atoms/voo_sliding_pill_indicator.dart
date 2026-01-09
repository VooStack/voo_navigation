import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

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
          child: _SlidingPill(
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

class _SlidingPill extends StatelessWidget {
  final VooNavigationTheme theme;
  final Color indicatorColor;
  final double pillWidth;
  final double height;

  const _SlidingPill({
    required this.theme,
    required this.indicatorColor,
    required this.pillWidth,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final showGlow = theme.indicatorStyle == VooThemeIndicatorStyle.glow ||
        theme.preset == VooNavigationPreset.glassmorphism;

    return Container(
      width: pillWidth,
      height: height,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: indicatorColor.withValues(alpha: 0.4),
                  blurRadius: theme.indicatorGlowBlur,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
