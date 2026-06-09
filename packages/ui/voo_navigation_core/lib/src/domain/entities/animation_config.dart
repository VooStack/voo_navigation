import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/design/voo_minimal.dart';

/// Configures motion throughout the navigation system.
///
/// Replaces the four `animationDuration` / `animationCurve` /
/// `enableAnimations` / `badgeAnimationDuration` fields on
/// [VooNavigationConfig], which were removed in 2.0.
///
/// Defaults match [VooMinimal.motionNormal] and [VooMinimal.motionCurve]
/// — the restrained cubic-bezier easing used elsewhere in the minimal
/// aesthetic. Override to slow things down for accessibility or to fully
/// disable animations.
///
/// Usage:
/// ```dart
/// VooNavigationConfig(
///   ...,
///   animation: VooAnimationConfig(
///     duration: Duration(milliseconds: 240),
///     curve: Curves.easeOut,
///   ),
/// )
/// ```
@immutable
class VooAnimationConfig {
  /// Duration for navigation transitions (expand/collapse, hover, etc.).
  final Duration duration;

  /// Curve for navigation transitions.
  final Curve curve;

  /// Whether animations run at all. When false, transitions are instant.
  final bool enabled;

  /// Duration for badge add/remove animations (typically shorter than the
  /// main transition).
  final Duration badgeDuration;

  const VooAnimationConfig({
    this.duration = VooMinimal.motionNormal,
    this.curve = VooMinimal.motionCurve,
    this.enabled = true,
    this.badgeDuration = const Duration(milliseconds: 150),
  });

  /// Disables all motion. Useful for tests, reduced-motion accessibility
  /// preferences, or any context where transitions should be instant.
  static const VooAnimationConfig disabled = VooAnimationConfig(
    enabled: false,
    duration: Duration.zero,
    badgeDuration: Duration.zero,
  );

  VooAnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    bool? enabled,
    Duration? badgeDuration,
  }) {
    return VooAnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      enabled: enabled ?? this.enabled,
      badgeDuration: badgeDuration ?? this.badgeDuration,
    );
  }
}
