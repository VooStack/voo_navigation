import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_themed_nav_container.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// A themed bottom navigation bar container
///
/// Specialized container for bottom navigation with floating support
class VooThemedBottomNavContainer extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The navigation content
  final Widget child;

  /// Height of the navigation bar
  final double height;

  /// Whether this is a floating navigation bar
  final bool isFloating;

  /// Horizontal margin (for floating style)
  final double? horizontalMargin;

  /// Bottom margin (for floating style)
  final double? bottomMargin;

  const VooThemedBottomNavContainer({super.key, required this.theme, required this.child, this.height = 72, this.isFloating = false, this.horizontalMargin, this.bottomMargin});

  @override
  Widget build(BuildContext context) {
    final spacing = context.vooSpacing;
    final effectiveHMargin = horizontalMargin ?? spacing.md;
    final effectiveBMargin = bottomMargin ?? spacing.lg;

    if (isFloating) {
      return Padding(
        padding: EdgeInsets.fromLTRB(effectiveHMargin, 0, effectiveHMargin, effectiveBMargin),
        child: VooThemedNavContainer(theme: theme, height: height, borderRadius: BorderRadius.circular(theme.borderRadius), child: child),
      );
    }

    // Non-floating: full width with optional top border radius
    return VooThemedNavContainer(
      theme: theme,
      height: height,
      borderRadius: BorderRadius.vertical(top: Radius.circular(theme.borderRadius * 0.5)),
      child: child,
    );
  }
}
