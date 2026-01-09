import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// A themed container for navigation components
///
/// Automatically applies the appropriate visual style based on the theme preset:
/// - Glassmorphism: Frosted glass with blur
/// - Neomorphism: Soft shadows with embossed effect
/// - Material 3 Enhanced: Polished Material with rich colors
/// - Minimal Modern: Clean flat design
///
/// ```dart
/// VooThemedNavContainer(
///   theme: config.effectiveTheme,
///   child: NavigationContent(),
/// )
/// ```
class VooThemedNavContainer extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The content to display inside the container
  final Widget child;

  /// Border radius for the container
  final BorderRadius? borderRadius;

  /// Padding inside the container
  final EdgeInsetsGeometry? padding;

  /// Margin outside the container
  final EdgeInsetsGeometry? margin;

  /// Fixed width (optional)
  final double? width;

  /// Fixed height (optional)
  final double? height;

  /// Whether to clip content to border radius
  final bool clipContent;

  /// Whether to expand to fill available space
  /// When true and width/height are not set, container fills parent constraints
  final bool expand;

  const VooThemedNavContainer({
    super.key,
    required this.theme,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.clipContent = true,
    this.expand = false,
  });

  /// Effective width considering expand parameter
  double? get _effectiveWidth => expand && width == null ? double.infinity : width;

  /// Effective height considering expand parameter
  double? get _effectiveHeight => expand && height == null ? double.infinity : height;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(theme.containerBorderRadius);

    return switch (theme.preset) {
      VooNavigationPreset.glassmorphism => _GlassmorphismContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          clipContent: clipContent,
          child: child,
        ),
      VooNavigationPreset.liquidGlass => _LiquidGlassContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          child: child,
        ),
      VooNavigationPreset.blurry => _BlurryContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          child: child,
        ),
      VooNavigationPreset.neomorphism => _NeomorphismContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          clipContent: clipContent,
          child: child,
        ),
      VooNavigationPreset.material3Enhanced => _Material3EnhancedContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          clipContent: clipContent,
          child: child,
        ),
      VooNavigationPreset.minimalModern => _MinimalModernContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          clipContent: clipContent,
          child: child,
        ),
    };
  }
}

class _GlassmorphismContainer extends StatelessWidget {
  final VooNavigationTheme theme;
  final BorderRadius radius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool clipContent;
  final Widget child;

  const _GlassmorphismContainer({
    required this.theme,
    required this.radius,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surface);

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

class _LiquidGlassContainer extends StatelessWidget {
  final VooNavigationTheme theme;
  final BorderRadius radius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget child;

  const _LiquidGlassContainer({
    required this.theme,
    required this.radius,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = colorScheme.primary;

    final surfaceColor = theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface);

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

class _BlurryContainer extends StatelessWidget {
  final VooNavigationTheme theme;
  final BorderRadius radius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget child;

  const _BlurryContainer({
    required this.theme,
    required this.radius,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface);

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

class _NeomorphismContainer extends StatelessWidget {
  final VooNavigationTheme theme;
  final BorderRadius radius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool clipContent;
  final Widget child;

  const _NeomorphismContainer({
    required this.theme,
    required this.radius,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    final surfaceColor = theme.surfaceTintColor ?? themeData.colorScheme.surface;

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

class _Material3EnhancedContainer extends StatelessWidget {
  final VooNavigationTheme theme;
  final BorderRadius radius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool clipContent;
  final Widget child;

  const _Material3EnhancedContainer({
    required this.theme,
    required this.radius,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = theme.surfaceTintColor ??
        (isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainer);

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

class _MinimalModernContainer extends StatelessWidget {
  final VooNavigationTheme theme;
  final BorderRadius radius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool clipContent;
  final Widget child;

  const _MinimalModernContainer({
    required this.theme,
    required this.radius,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.clipContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final surfaceColor = theme.surfaceTintColor ?? colorScheme.surface;
    final borderColor = theme.borderColor ?? colorScheme.outlineVariant;

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: radius,
        border: theme.showContainerBorder
            ? Border.all(
                color: borderColor.withValues(alpha: theme.borderOpacity),
                width: theme.borderWidth,
              )
            : null,
        // No shadows for minimal
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
