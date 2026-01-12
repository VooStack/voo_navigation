import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// A themed indicator widget that adapts to the navigation theme
///
/// Renders a pill-style indicator with the theme's settings.
///
/// ```dart
/// VooThemedIndicator(
///   theme: config.effectiveTheme,
///   isSelected: isCurrentItem,
///   child: Icon(Icons.home),
/// )
/// ```
class VooThemedIndicator extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// Whether the indicator is active/selected
  final bool isSelected;

  /// The content to display (usually icon + label)
  final Widget child;

  /// Custom indicator color (overrides theme)
  final Color? color;

  /// Width of the indicator
  final double? width;

  /// Height of the indicator
  final double? height;

  const VooThemedIndicator({
    super.key,
    required this.theme,
    required this.isSelected,
    required this.child,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return child;
    }

    final indicatorColor = color ?? theme.resolveIndicatorColor(context);

    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: indicatorColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
