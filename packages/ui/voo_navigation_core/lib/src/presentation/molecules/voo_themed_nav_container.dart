import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';

/// A themed container for navigation components
///
/// Applies the navigation theme styling to the container.
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
  final bool expand;

  /// Override background color
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

  double? get _effectiveWidth =>
      expand && width == null ? double.infinity : width;
  double? get _effectiveHeight =>
      expand && height == null ? double.infinity : height;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(theme.borderRadius);
    final effectiveBackgroundColor =
        backgroundColor ?? theme.resolveSurfaceColor(context);
    final borderColor = theme.resolveBorderColor(context);
    final shadows = theme.resolveShadows(context);

    Widget container = Container(
      width: _effectiveWidth,
      height: _effectiveHeight,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: borderColor != null && theme.borderWidth > 0
            ? Border.all(color: borderColor, width: theme.borderWidth)
            : null,
        boxShadow: shadows.isNotEmpty ? shadows : null,
      ),
      child: child,
    );

    if (clipContent) {
      container = ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: container,
      );
    }

    return container;
  }
}
