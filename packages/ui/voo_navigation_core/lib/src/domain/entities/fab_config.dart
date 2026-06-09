import 'package:flutter/material.dart';

/// Configures the floating action button (FAB) shown by the scaffold.
///
/// Replaces the four `floatingActionButton` / `floatingActionButtonLocation`
/// / `floatingActionButtonAnimator` / `showFloatingActionButton` fields on
/// [VooNavigationConfig], which were removed in 2.0.
///
/// Usage:
/// ```dart
/// VooNavigationConfig(
///   ...,
///   fab: VooFabConfig(
///     widget: FloatingActionButton(onPressed: …, child: Icon(Icons.add)),
///     location: FloatingActionButtonLocation.endFloat,
///   ),
/// )
/// ```
///
/// Pass `null` (the default) for no FAB. Pass [VooFabConfig.hidden] when
/// you want to suppress a FAB that would otherwise be auto-injected (e.g.
/// by a `pageConfig` override).
@immutable
class VooFabConfig {
  /// The FAB widget itself. When null, no FAB is rendered.
  final Widget? widget;

  /// Location of the FAB on the scaffold.
  final FloatingActionButtonLocation? location;

  /// Animator controlling how the FAB transitions between locations.
  final FloatingActionButtonAnimator? animator;

  /// Whether the FAB is visible at all. Set to false to suppress.
  final bool visible;

  const VooFabConfig({
    this.widget,
    this.location,
    this.animator,
    this.visible = true,
  });

  /// Convenience: a config that suppresses any FAB (visible = false).
  static const VooFabConfig hidden = VooFabConfig(visible: false);

  VooFabConfig copyWith({
    Widget? widget,
    FloatingActionButtonLocation? location,
    FloatingActionButtonAnimator? animator,
    bool? visible,
  }) {
    return VooFabConfig(
      widget: widget ?? this.widget,
      location: location ?? this.location,
      animator: animator ?? this.animator,
      visible: visible ?? this.visible,
    );
  }
}
