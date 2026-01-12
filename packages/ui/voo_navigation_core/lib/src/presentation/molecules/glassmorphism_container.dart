import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Glassmorphism style container
class VooGlassmorphismContainer extends StatelessWidget {
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

  const VooGlassmorphismContainer({
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

    final borderColor = theme.borderColor ??
        (isDark ? Colors.white : Colors.black);

    // Inner container with background and border (no shadows - they go on outer)
    Widget innerContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: theme.surfaceOpacity),
        borderRadius: radius,
        border: theme.showContainerBorder
            ? Border.all(
                color: borderColor.withValues(alpha: theme.borderOpacity),
                width: theme.borderWidth,
              )
            : null,
      ),
      child: child,
    );

    // Apply blur with ClipRRect inside shadow container
    Widget content;
    if (theme.blurSigma > 0) {
      content = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: theme.resolveShadows(context),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: theme.blurSigma,
              sigmaY: theme.blurSigma,
            ),
            child: innerContent,
          ),
        ),
      );
    } else {
      // No blur - shadows on outer container, clip content inside
      content = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: theme.resolveShadows(context),
        ),
        child: clipContent
            ? ClipRRect(borderRadius: radius, child: innerContent)
            : innerContent,
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
