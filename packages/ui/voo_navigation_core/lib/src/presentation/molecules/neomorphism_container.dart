import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Neomorphism style container
class VooNeomorphismContainer extends StatelessWidget {
  /// Theme configuration
  final VooNavigationTheme theme;

  /// Border radius
  final BorderRadius radius;

  /// Width of the container
  final double? width;

  /// Height of the container
  final double? height;

  /// Padding inside the container
  final EdgeInsetsGeometry? padding;

  /// Margin outside the container
  final EdgeInsetsGeometry? margin;

  /// Whether to clip content
  final bool clipContent;

  /// Override background color
  final Color? backgroundColor;

  /// Child widget
  final Widget child;

  const VooNeomorphismContainer({
    super.key,
    required this.theme,
    required this.radius,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.clipContent = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final surfaceColor = backgroundColor ?? theme.surfaceTintColor ?? themeData.colorScheme.surface;

    // Neomorphism shadow colors
    final lightShadowOpacity = isDark ? 0.05 : theme.shadowLightOpacity;
    final darkShadowOpacity = isDark ? 0.4 : theme.shadowDarkOpacity;

    // Inner container with background (no shadows - they go on outer)
    Widget innerContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: radius,
      ),
      child: child,
    );

    // Outer container with shadows, ClipRRect inside
    Widget content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: theme.showContainerShadow
            ? [
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
              ]
            : null,
      ),
      child: clipContent
          ? ClipRRect(borderRadius: radius, child: innerContent)
          : innerContent,
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
