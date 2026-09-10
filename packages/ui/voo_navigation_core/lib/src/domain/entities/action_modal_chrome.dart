import 'package:flutter/material.dart';

/// Visual chrome for the modal opened by a [VooActionNavigationItem].
///
/// Every field is optional. A `null` field keeps the navigation bar's own
/// default, so passing no chrome at all renders exactly as before.
///
/// Host applications use this to make the modal match their design system
/// instead of the package's built-in surface treatment.
class VooActionModalChrome {
  /// Corner radius of the modal surface. Applied to both the fill and the clip.
  final BorderRadius? borderRadius;

  /// Fill colour of the modal surface.
  final Color? backgroundColor;

  /// Border drawn around the modal surface.
  final BoxBorder? border;

  /// Shadow cast by the modal surface.
  final List<BoxShadow>? boxShadow;

  /// Colour of the scrim behind the modal, at full animation progress.
  final Color? barrierColor;

  /// Opacity the scrim animates to. Defaults to 0.5.
  final double barrierOpacity;

  /// Modal width as a fraction of the screen width. Defaults to 0.9.
  final double widthFactor;

  const VooActionModalChrome({
    this.borderRadius,
    this.backgroundColor,
    this.border,
    this.boxShadow,
    this.barrierColor,
    this.barrierOpacity = 0.5,
    this.widthFactor = 0.9,
  });
}
