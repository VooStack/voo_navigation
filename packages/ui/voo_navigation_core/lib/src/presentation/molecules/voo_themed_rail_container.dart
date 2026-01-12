import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_themed_nav_container.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A themed navigation rail container
///
/// Specialized container for navigation rail with proper sizing
class VooThemedRailContainer extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The rail content
  final Widget child;

  /// Width of the rail
  final double width;

  /// Whether the rail is extended (wider with labels)
  final bool isExtended;

  /// Margin around the rail
  final double? margin;

  const VooThemedRailContainer({
    super.key,
    required this.theme,
    required this.child,
    this.width = 80,
    this.isExtended = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;
    final effectiveMargin = margin ?? spacing.sm;

    return Padding(
      padding: EdgeInsets.all(effectiveMargin),
      child: VooThemedNavContainer(
        theme: theme,
        width: width,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        child: child,
      ),
    );
  }
}
