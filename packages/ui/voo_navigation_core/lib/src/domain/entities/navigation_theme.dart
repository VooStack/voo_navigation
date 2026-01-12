import 'package:flutter/material.dart';

/// Theme configuration for navigation visual styling
///
/// Provides a simple, unified approach to styling navigation components.
///
/// Example:
/// ```dart
/// VooNavigationTheme(
///   surfaceColor: Colors.white,
///   borderRadius: 12,
///   elevation: 0,
/// )
/// ```
class VooNavigationTheme {
  /// Surface/background color for the navigation
  final Color? surfaceColor;

  /// Border radius for containers
  final double borderRadius;

  /// Elevation/shadow depth
  final double elevation;

  /// Border color (null = no border)
  final Color? borderColor;

  /// Border width
  final double borderWidth;

  /// Indicator color for selected items
  final Color? indicatorColor;

  /// Animation duration for transitions
  final Duration animationDuration;

  /// Animation curve for transitions
  final Curve animationCurve;

  /// Creates a navigation theme
  const VooNavigationTheme({
    this.surfaceColor,
    this.borderRadius = 0,
    this.elevation = 0,
    this.borderColor,
    this.borderWidth = 0,
    this.indicatorColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
  });

  /// Creates a copy with the given fields replaced
  VooNavigationTheme copyWith({
    Color? surfaceColor,
    double? borderRadius,
    double? elevation,
    Color? borderColor,
    double? borderWidth,
    Color? indicatorColor,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return VooNavigationTheme(
      surfaceColor: surfaceColor ?? this.surfaceColor,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  /// Resolves the surface color for the current theme
  Color resolveSurfaceColor(BuildContext context) {
    if (surfaceColor != null) return surfaceColor!;
    final theme = Theme.of(context);
    return theme.colorScheme.surface;
  }

  /// Resolves the border color for the current theme
  Color? resolveBorderColor(BuildContext context) {
    if (borderColor != null) return borderColor;
    if (borderWidth <= 0) return null;
    final theme = Theme.of(context);
    return theme.colorScheme.outlineVariant;
  }

  /// Resolves the indicator color for the current theme
  Color resolveIndicatorColor(BuildContext context) {
    if (indicatorColor != null) return indicatorColor!;
    return Theme.of(context).colorScheme.primary;
  }

  /// Generates box shadows based on elevation
  List<BoxShadow> resolveShadows(BuildContext context) {
    if (elevation <= 0) return [];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return [
      BoxShadow(
        color: theme.shadowColor.withValues(alpha: isDark ? 0.3 : 0.1),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation / 2),
      ),
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VooNavigationTheme &&
        other.surfaceColor == surfaceColor &&
        other.borderRadius == borderRadius &&
        other.elevation == elevation &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.indicatorColor == indicatorColor &&
        other.animationDuration == animationDuration;
  }

  @override
  int get hashCode => Object.hash(
        surfaceColor,
        borderRadius,
        elevation,
        borderColor,
        borderWidth,
        indicatorColor,
        animationDuration,
      );
}
