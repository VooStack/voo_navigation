import 'package:flutter/material.dart';

/// Customization slots for the navigation drawer/rail.
///
/// Replaces the three `drawerHeader` / `drawerHeaderTrailing` /
/// `drawerFooter` fields on [VooNavigationConfig], which were removed in
/// 2.0. Group all your drawer overrides into one struct.
///
/// Usage:
/// ```dart
/// VooNavigationConfig(
///   ...,
///   drawerSlots: VooDrawerSlots(
///     header: MyBrandHeader(),
///     headerTrailing: IconButton(icon: Icon(Icons.close), onPressed: ...),
///     footer: VersionLabel(),
///   ),
/// )
/// ```
///
/// All slots are optional. When `header` is null, the default header
/// (built from `VooNavigationConfig.headerConfig`) is used.
@immutable
class VooDrawerSlots {
  /// Full custom drawer header. When non-null, replaces the default header
  /// entirely (and `VooNavigationConfig.headerConfig` is ignored).
  final Widget? header;

  /// Trailing widget for the drawer header (e.g. a collapse button).
  /// Composes with both the custom [header] and the default header.
  final Widget? headerTrailing;

  /// Optional widget rendered at the bottom of the drawer below the items.
  final Widget? footer;

  const VooDrawerSlots({this.header, this.headerTrailing, this.footer});

  /// Convenience: an empty slots config. Equivalent to passing null.
  static const VooDrawerSlots empty = VooDrawerSlots();

  VooDrawerSlots copyWith({
    Widget? header,
    Widget? headerTrailing,
    Widget? footer,
  }) {
    return VooDrawerSlots(
      header: header ?? this.header,
      headerTrailing: headerTrailing ?? this.headerTrailing,
      footer: footer ?? this.footer,
    );
  }
}
