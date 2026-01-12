import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Embossed-style indicator widget
class VooEmbossedIndicator extends StatelessWidget {
  /// Navigation theme
  final VooNavigationTheme theme;

  /// Whether the indicator is selected
  final bool isSelected;

  /// Indicator color
  final Color indicatorColor;

  /// Child widget
  final Widget child;

  const VooEmbossedIndicator({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.indicatorColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    final shadowOpacity = isDark ? 0.3 : 0.12;

    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? indicatorColor.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: shadowOpacity),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                  spreadRadius: -2,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: shadowOpacity * 0.5),
                  blurRadius: 4,
                  offset: const Offset(-1, -1),
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
