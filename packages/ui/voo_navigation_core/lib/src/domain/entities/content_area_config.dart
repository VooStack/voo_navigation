import 'package:flutter/material.dart';

/// Configures the body content area (the right-hand region next to the
/// nav rail/drawer on desktop).
///
/// Replaces the three `contentAreaMargin` / `contentAreaBorderRadius` /
/// `contentAreaBackgroundColor` fields on [VooNavigationConfig], which
/// were removed in 2.0.
///
/// Usage:
/// ```dart
/// VooNavigationConfig(
///   ...,
///   contentArea: VooContentAreaConfig(
///     margin: EdgeInsets.only(top: 8),
///     borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
///   ),
/// )
/// ```
///
/// Pass `null` (the default) to use the scaffold's built-in content-area
/// defaults — 8px top margin + 12px top-left radius to visually separate
/// the content from the nav surface.
@immutable
class VooContentAreaConfig {
  /// Margin applied to the content area. Default is `EdgeInsets.only(top: 8)`.
  final EdgeInsets? margin;

  /// Border radius applied to the content area. Default is a 12px top-left
  /// corner so the content area visually "sits inside" the scaffold.
  final BorderRadius? borderRadius;

  /// Background color of the content area. When null, falls back to
  /// `ColorScheme.surface`.
  final Color? backgroundColor;

  const VooContentAreaConfig({
    this.margin,
    this.borderRadius,
    this.backgroundColor,
  });

  VooContentAreaConfig copyWith({
    EdgeInsets? margin,
    BorderRadius? borderRadius,
    Color? backgroundColor,
  }) {
    return VooContentAreaConfig(
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}
