import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';

/// App bar leading widget that handles menu, back button, or custom widget
class VooAppBarLeading extends StatelessWidget {
  /// Whether to show menu button
  final bool showMenuButton;

  /// Navigation configuration
  final VooNavigationConfig? config;

  const VooAppBarLeading({
    super.key,
    required this.showMenuButton,
    this.config,
  });

  /// Checks if this widget would render actual content (not an empty SizedBox)
  ///
  /// This is useful to determine if [leadingWidth] should be set to 0 in the AppBar
  /// to avoid empty space when no leading content is shown.
  static bool wouldShowContent({
    required BuildContext context,
    required bool showMenuButton,
    VooNavigationConfig? config,
  }) {
    // Check for menu button (drawer)
    if (showMenuButton) {
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.hasDrawer) {
        return true;
      }
    }

    // Show back button if can pop
    if (Navigator.of(context).canPop()) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Show menu button for drawer on mobile (only if showMenuButton is true)
    if (showMenuButton) {
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.hasDrawer) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldState.openDrawer();
            if (config?.enableHapticFeedback ?? true) {
              HapticFeedback.lightImpact();
            }
          },
          tooltip: 'Open navigation menu',
        );
      }
    }

    // Show back button if can pop
    if (Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
          if (config?.enableHapticFeedback ?? true) {
            HapticFeedback.lightImpact();
          }
        },
        tooltip: 'Go back',
      );
    }

    return const SizedBox.shrink();
  }
}
