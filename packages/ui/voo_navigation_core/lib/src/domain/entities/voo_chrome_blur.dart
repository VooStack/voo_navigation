import 'package:flutter/material.dart';

/// Configures glassmorphic chrome — a `BackdropFilter` blur over a translucent
/// surface, applied to the app bar and bottom navigation.
///
/// When set on a [VooNavigationConfig], the scaffolds wrap the top app bar
/// and bottom nav in a `BackdropFilter(blur)` and paint [appBarSurfaceColor]
/// / [bottomNavSurfaceColor] behind. Pass colors with alpha < 1.0 so content
/// scrolling underneath shows through the frosted glass.
///
/// Defaults match the visual recipe in the FlightStack redesign artifact —
/// `sigma: 8` for the top bar / `sigma: 14` for the bottom nav are typical.
class VooChromeBlur {
  /// Blur sigma applied to the top app bar. Defaults to 8 (a typical
  /// frosted-glass feel).
  final double appBarSigma;

  /// Blur sigma applied to the mobile bottom navigation. Defaults to 14 — a
  /// stronger blur reads more clearly over busy list content.
  final double bottomNavSigma;

  /// Translucent surface painted behind the top app bar blur. When null, no
  /// blur is applied to the app bar. Typical alpha: 0.6 – 0.85.
  final Color? appBarSurfaceColor;

  /// Translucent surface painted behind the bottom nav blur. When null, no
  /// blur is applied to the bottom nav. Typical alpha: 0.85 – 0.95.
  final Color? bottomNavSurfaceColor;

  const VooChromeBlur({
    this.appBarSigma = 8,
    this.bottomNavSigma = 14,
    this.appBarSurfaceColor,
    this.bottomNavSurfaceColor,
  });

  /// True when an app-bar blur should be rendered.
  bool get hasAppBarBlur => appBarSurfaceColor != null;

  /// True when a bottom-nav blur should be rendered.
  bool get hasBottomNavBlur => bottomNavSurfaceColor != null;

  VooChromeBlur copyWith({
    double? appBarSigma,
    double? bottomNavSigma,
    Color? appBarSurfaceColor,
    Color? bottomNavSurfaceColor,
  }) =>
      VooChromeBlur(
        appBarSigma: appBarSigma ?? this.appBarSigma,
        bottomNavSigma: bottomNavSigma ?? this.bottomNavSigma,
        appBarSurfaceColor: appBarSurfaceColor ?? this.appBarSurfaceColor,
        bottomNavSurfaceColor: bottomNavSurfaceColor ?? this.bottomNavSurfaceColor,
      );
}
