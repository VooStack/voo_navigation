import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// A neomorphism surface widget with soft embossed/debossed effects
///
/// Creates a soft, extruded surface with dual shadows (light and dark)
/// that gives the appearance of being raised from or pressed into
/// the background.
///
/// ```dart
/// VooNeomorphSurface(
///   theme: VooNavigationTheme.neomorphism(),
///   borderRadius: BorderRadius.circular(20),
///   child: YourContent(),
/// )
/// ```
class VooNeomorphSurface extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display on the surface
  final Widget child;

  /// Border radius for the surface
  final BorderRadius borderRadius;

  /// Padding inside the surface
  final EdgeInsetsGeometry? padding;

  /// Fixed width (optional)
  final double? width;

  /// Fixed height (optional)
  final double? height;

  /// Additional margin around the surface
  final EdgeInsetsGeometry? margin;

  /// Whether the surface appears pressed in (concave) instead of raised (convex)
  final bool isPressed;

  const VooNeomorphSurface({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding,
    this.width,
    this.height,
    this.margin,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    // Get base surface color
    final surfaceColor = theme.surfaceTintColor ??
        themeData.colorScheme.surface;

    // Calculate shadow colors with dark mode awareness
    final lightShadowOpacity = isDark ? 0.05 : theme.shadowLightOpacity;
    final darkShadowOpacity = isDark ? 0.4 : theme.shadowDarkOpacity;

    // Build shadows based on pressed state
    List<BoxShadow> shadows;
    if (isPressed) {
      // Inset-like effect: reverse shadow positions for pressed look
      shadows = [
        BoxShadow(
          color: Colors.black.withValues(alpha: darkShadowOpacity),
          blurRadius: theme.shadowBlur * 0.5,
          offset: theme.shadowLightOffset * 0.5, // Reversed position
          spreadRadius: -2,
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: lightShadowOpacity * 0.5),
          blurRadius: theme.shadowBlur * 0.5,
          offset: theme.shadowDarkOffset * 0.5, // Reversed position
          spreadRadius: -2,
        ),
      ];
    } else {
      // Raised effect: standard neomorphism shadows
      shadows = [
        BoxShadow(
          color: Colors.white.withValues(alpha: lightShadowOpacity),
          blurRadius: theme.shadowBlur,
          offset: theme.shadowLightOffset,
          spreadRadius: isDark ? 0 : 1,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: darkShadowOpacity),
          blurRadius: theme.shadowBlur,
          offset: theme.shadowDarkOffset,
        ),
      ];
    }

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: borderRadius,
        boxShadow: shadows,
      ),
      child: child,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}

