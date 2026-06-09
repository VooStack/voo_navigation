import 'package:flutter/material.dart';

/// Configures the optional "card" wrapper around the scaffold body.
///
/// Replaces the four `useBodyCard` / `bodyCardElevation` /
/// `bodyCardBorderRadius` / `bodyCardColor` fields on
/// [VooNavigationConfig], which are deprecated.
///
/// Usage:
/// ```dart
/// VooNavigationConfig(
///   ...,
///   bodyCard: const VooBodyCardConfig(
///     elevation: 1,
///     borderRadius: BorderRadius.all(Radius.circular(8)),
///   ),
/// )
/// ```
@immutable
class VooBodyCardConfig {
  /// Whether the body is wrapped in a card at all. When false, the rest of
  /// the fields are ignored.
  final bool enabled;

  /// Elevation applied to the card.
  final double elevation;

  /// Border radius of the card.
  final BorderRadius? borderRadius;

  /// Background color of the card. When null, falls back to the active
  /// `VooMinimalTheme.surfaceElevated`.
  final Color? color;

  const VooBodyCardConfig({
    this.enabled = true,
    this.elevation = 0,
    this.borderRadius,
    this.color,
  });

  /// Sentinel meaning "no body card" — equivalent to the historical
  /// `useBodyCard: false`. Mostly for documentation; passing `null` for
  /// the `bodyCard` field on the config has the same effect.
  static const VooBodyCardConfig disabled = VooBodyCardConfig(enabled: false);

  VooBodyCardConfig copyWith({
    bool? enabled,
    double? elevation,
    BorderRadius? borderRadius,
    Color? color,
  }) {
    return VooBodyCardConfig(
      enabled: enabled ?? this.enabled,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      color: color ?? this.color,
    );
  }
}
