import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Liquid glass style container
class VooLiquidGlassContainer extends StatelessWidget {
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

  const VooLiquidGlassContainer({
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colorScheme.primary;

    // Use pure white/dark background to match body (no tinted colors)
    final surfaceColor = backgroundColor ?? theme.surfaceTintColor ??
        (isDark
            ? const Color(0xFF1A1A1A)
            : Colors.white);

    // Apply tint for liquid effect
    final tintedSurface = theme.tintIntensity > 0
        ? Color.lerp(surfaceColor, primaryColor, theme.tintIntensity * 0.3)!
        : surfaceColor;

    final borderColor = theme.borderColor ?? (isDark ? Colors.white : Colors.black);

    Widget content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: theme.resolveShadows(context),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          children: [
            // Primary blur
            if (theme.blurSigma > 0)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: theme.blurSigma,
                    sigmaY: theme.blurSigma,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

            // Secondary blur for depth
            if (theme.secondaryBlurSigma > 0)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: theme.secondaryBlurSigma,
                    sigmaY: theme.secondaryBlurSigma,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),

            // Glass gradient surface
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.3, 0.7, 1.0],
                    colors: isDark
                        ? [
                            tintedSurface.withValues(alpha: theme.surfaceOpacity + 0.1),
                            tintedSurface.withValues(alpha: theme.surfaceOpacity),
                            tintedSurface.withValues(alpha: theme.surfaceOpacity - 0.05),
                            tintedSurface.withValues(alpha: theme.surfaceOpacity - 0.1),
                          ]
                        : [
                            Colors.white.withValues(alpha: theme.surfaceOpacity + 0.15),
                            tintedSurface.withValues(alpha: theme.surfaceOpacity + 0.05),
                            tintedSurface.withValues(alpha: theme.surfaceOpacity),
                            tintedSurface.withValues(alpha: theme.surfaceOpacity - 0.1),
                          ],
                  ),
                ),
              ),
            ),

            // Inner glow
            if (theme.innerGlowIntensity > 0)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2,
                      colors: [
                        primaryColor.withValues(alpha: theme.innerGlowIntensity * 0.08),
                        primaryColor.withValues(alpha: theme.innerGlowIntensity * 0.03),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

            // Border
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  border: theme.showContainerBorder
                      ? Border.all(
                          color: borderColor.withValues(alpha: theme.borderOpacity),
                          width: theme.borderWidth,
                        )
                      : null,
                ),
              ),
            ),

            // Content
            Positioned.fill(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
