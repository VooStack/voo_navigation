import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/molecules/blurry_container.dart';
import 'package:voo_navigation_core/src/presentation/molecules/glassmorphism_container.dart';
import 'package:voo_navigation_core/src/presentation/molecules/liquid_glass_container.dart';
import 'package:voo_navigation_core/src/presentation/molecules/material3_enhanced_container.dart';
import 'package:voo_navigation_core/src/presentation/molecules/minimal_modern_container.dart';
import 'package:voo_navigation_core/src/presentation/molecules/neomorphism_container.dart';

export 'package:voo_navigation_core/src/presentation/molecules/blurry_container.dart';
export 'package:voo_navigation_core/src/presentation/molecules/glassmorphism_container.dart';
export 'package:voo_navigation_core/src/presentation/molecules/liquid_glass_container.dart';
export 'package:voo_navigation_core/src/presentation/molecules/material3_enhanced_container.dart';
export 'package:voo_navigation_core/src/presentation/molecules/minimal_modern_container.dart';
export 'package:voo_navigation_core/src/presentation/molecules/neomorphism_container.dart';

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

  /// Override background color (ignores theme preset's background)
  final Color? backgroundColor;

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
    this.backgroundColor,
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
      VooNavigationPreset.glassmorphism => VooGlassmorphismContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          clipContent: clipContent,
          backgroundColor: backgroundColor,
          child: child,
        ),
      VooNavigationPreset.liquidGlass => VooLiquidGlassContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          child: child,
        ),
      VooNavigationPreset.blurry => VooBlurryContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          child: child,
        ),
      VooNavigationPreset.neomorphism => VooNeomorphismContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          clipContent: clipContent,
          backgroundColor: backgroundColor,
          child: child,
        ),
      VooNavigationPreset.material3Enhanced => VooMaterial3EnhancedContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          clipContent: clipContent,
          backgroundColor: backgroundColor,
          child: child,
        ),
      VooNavigationPreset.minimalModern => VooMinimalModernContainer(
          theme: theme,
          radius: effectiveBorderRadius,
          width: _effectiveWidth,
          height: _effectiveHeight,
          padding: padding,
          margin: margin,
          clipContent: clipContent,
          backgroundColor: backgroundColor,
          child: child,
        ),
    };
  }
}
