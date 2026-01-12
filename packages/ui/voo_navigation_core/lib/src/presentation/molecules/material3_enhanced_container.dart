import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Material 3 enhanced style container
class VooMaterial3EnhancedContainer extends StatelessWidget {
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

  const VooMaterial3EnhancedContainer({
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use pure white/dark background to match body (no tinted colors)
    final surfaceColor = backgroundColor ?? theme.surfaceTintColor ??
        (isDark
            ? const Color(0xFF1A1A1A)
            : Colors.white);

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
            ? theme.resolveShadows(context)
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
