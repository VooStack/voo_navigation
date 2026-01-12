import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// Layered liquid glass effect widget
class VooLiquidGlassLayers extends StatelessWidget {
  /// Navigation theme
  final VooNavigationTheme theme;

  /// Border radius
  final BorderRadius borderRadius;

  /// Internal padding
  final EdgeInsetsGeometry? padding;

  /// Optional fixed width
  final double? width;

  /// Optional fixed height
  final double? height;

  /// Whether dark mode
  final bool isDark;

  /// Surface color
  final Color surfaceColor;

  /// Border color
  final Color borderColor;

  /// Primary color for accents
  final Color primaryColor;

  /// Child widget
  final Widget child;

  const VooLiquidGlassLayers({
    super.key,
    required this.theme,
    required this.borderRadius,
    required this.padding,
    required this.width,
    required this.height,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: theme.resolveShadows(context),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            // Layer 1: Primary blur (deep)
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

            // Layer 2: Secondary blur (subtle overlay for depth)
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

            // Layer 3: Glass surface with gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 0.3, 0.7, 1.0],
                    colors: isDark
                        ? [
                            surfaceColor.withValues(alpha: theme.surfaceOpacity + 0.1),
                            surfaceColor.withValues(alpha: theme.surfaceOpacity),
                            surfaceColor.withValues(alpha: theme.surfaceOpacity - 0.05),
                            surfaceColor.withValues(alpha: theme.surfaceOpacity - 0.1),
                          ]
                        : [
                            Colors.white.withValues(alpha: theme.surfaceOpacity + 0.15),
                            surfaceColor.withValues(alpha: theme.surfaceOpacity + 0.05),
                            surfaceColor.withValues(alpha: theme.surfaceOpacity),
                            surfaceColor.withValues(alpha: theme.surfaceOpacity - 0.1),
                          ],
                  ),
                ),
              ),
            ),

            // Layer 4: Inner glow (radial gradient from center)
            if (theme.innerGlowIntensity > 0)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
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

            // Layer 5: Top edge highlight (refraction effect)
            if (theme.edgeHighlightIntensity > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: borderRadius.topLeft,
                      topRight: borderRadius.topRight,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(
                          alpha: isDark
                              ? theme.edgeHighlightIntensity * 0.4
                              : theme.edgeHighlightIntensity * 0.8,
                        ),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.1, 0.5, 0.9],
                    ),
                  ),
                ),
              ),

            // Layer 6: Left edge highlight
            if (theme.edgeHighlightIntensity > 0)
              Positioned(
                top: 8,
                left: 0,
                bottom: 8,
                width: 1.5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: borderRadius.topLeft,
                      bottomLeft: borderRadius.bottomLeft,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(
                          alpha: isDark
                              ? theme.edgeHighlightIntensity * 0.2
                              : theme.edgeHighlightIntensity * 0.4,
                        ),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

            // Layer 7: Border
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: theme.borderWidth > 0
                      ? Border.all(
                          color: borderColor.withValues(alpha: theme.borderOpacity),
                          width: theme.borderWidth,
                        )
                      : null,
                ),
              ),
            ),

            // Layer 8: Content
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
  }
}
