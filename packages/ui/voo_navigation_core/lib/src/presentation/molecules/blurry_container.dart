import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Blurry style container
class VooBlurryContainer extends StatelessWidget {
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

  /// Override background color
  final Color? backgroundColor;

  /// Child widget
  final Widget child;

  const VooBlurryContainer({
    super.key,
    required this.theme,
    required this.radius,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
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

    final borderColor = isDark ? Colors.white : Colors.black;

    Widget content = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: theme.blurSigma,
          sigmaY: theme.blurSigma,
        ),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: surfaceColor.withValues(alpha: theme.surfaceOpacity),
            border: theme.showContainerBorder
                ? Border.all(
                    color: borderColor.withValues(
                      alpha: isDark
                          ? theme.borderOpacity
                          : theme.borderOpacity * 0.5,
                    ),
                    width: theme.borderWidth,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
