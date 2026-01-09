import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// A frosted glass surface widget for glassmorphism effects
///
/// Creates a translucent surface with backdrop blur, subtle borders,
/// and soft shadows for a modern glass-like appearance.
///
/// ```dart
/// VooGlassSurface(
///   theme: VooNavigationTheme.glassmorphism(),
///   borderRadius: BorderRadius.circular(24),
///   child: YourContent(),
/// )
/// ```
class VooGlassSurface extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display on top of the glass surface
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

  /// Whether to clip the content to the border radius
  final bool clipContent;

  const VooGlassSurface({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding,
    this.width,
    this.height,
    this.margin,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve colors
    final surfaceColor = theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surface);

    final borderColor = theme.borderColor ??
        (isDark ? Colors.white : Colors.black);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: theme.surfaceOpacity),
        borderRadius: borderRadius,
        border: theme.borderWidth > 0
            ? Border.all(
                color: borderColor.withValues(alpha: theme.borderOpacity),
                width: theme.borderWidth,
              )
            : null,
        boxShadow: theme.resolveShadows(context),
      ),
      child: child,
    );

    // Apply blur if sigma > 0
    if (theme.blurSigma > 0) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: theme.blurSigma,
            sigmaY: theme.blurSigma,
          ),
          child: content,
        ),
      );
    } else if (clipContent) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: content,
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}

