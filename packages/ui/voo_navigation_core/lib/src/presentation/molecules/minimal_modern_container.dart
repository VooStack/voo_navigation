import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Minimal modern style container
class VooMinimalModernContainer extends StatelessWidget {
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

  const VooMinimalModernContainer({
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

    // Use neutral gray for content area (no tinted colors)
    final surfaceColor = backgroundColor ??
        theme.surfaceTintColor ??
        (isDark ? const Color(0xFF121212) : const Color(0xFFF8F8F8));

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: radius,
        // No border for minimal modern - clean seamless look
      ),
      child: child,
    );

    if (clipContent) {
      content = ClipRRect(borderRadius: radius, child: content);
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
