import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_themed_nav_container.dart';

/// A themed navigation drawer container
///
/// Specialized container for navigation drawer
class VooThemedDrawerContainer extends StatelessWidget {
  /// The navigation theme configuration
  final VooNavigationTheme theme;

  /// The drawer content
  final Widget child;

  /// Width of the drawer
  final double width;

  const VooThemedDrawerContainer({
    super.key,
    required this.theme,
    required this.child,
    this.width = 280,
  });

  @override
  Widget build(BuildContext context) {
    // Drawer typically doesn't have outer margin or rounded corners
    // on the left edge
    return VooThemedNavContainer(
      theme: theme,
      width: width,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(theme.borderRadius),
        bottomRight: Radius.circular(theme.borderRadius),
      ),
      child: child,
    );
  }
}
