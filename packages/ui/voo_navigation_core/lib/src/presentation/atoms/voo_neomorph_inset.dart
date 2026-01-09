import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// A neomorphism inset container for pressed-in effects
///
/// Creates a container that appears to be pressed into the surface,
/// useful for input fields, selected items, or progress tracks
class VooNeomorphInset extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display
  final Widget child;

  /// Border radius for the inset
  final BorderRadius borderRadius;

  /// Padding inside the inset
  final EdgeInsetsGeometry? padding;

  /// Fixed width (optional)
  final double? width;

  /// Fixed height (optional)
  final double? height;

  /// Depth of the inset effect (0.0-1.0)
  final double depth;

  const VooNeomorphInset({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding,
    this.width,
    this.height,
    this.depth = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final surfaceColor = theme.surfaceTintColor ??
        themeData.colorScheme.surface;

    // Slightly darker/lighter background for inset
    final insetColor = isDark
        ? Color.lerp(surfaceColor, Colors.black, depth * 0.1)!
        : Color.lerp(surfaceColor, Colors.black, depth * 0.05)!;

    // Inner shadows for inset effect
    final innerShadowOpacity = depth * (isDark ? 0.3 : 0.15);

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: insetColor,
        borderRadius: borderRadius,
        boxShadow: [
          // Inner shadow simulation using a gradient overlay
          BoxShadow(
            color: Colors.black.withValues(alpha: innerShadowOpacity),
            blurRadius: theme.shadowBlur * 0.5 * depth,
            offset: Offset(
              theme.shadowLightOffset.dx * 0.3 * depth,
              theme.shadowLightOffset.dy * 0.3 * depth,
            ),
            spreadRadius: -2,
          ),
        ],
      ),
      child: child,
    );
  }
}
