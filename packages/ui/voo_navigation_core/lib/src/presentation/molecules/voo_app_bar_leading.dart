import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/page_config.dart';

/// App bar leading widget that handles menu, back button, or custom widget
class VooAppBarLeading extends StatelessWidget {
  /// Whether to show menu button
  final bool showMenuButton;

  /// Navigation configuration
  final VooNavigationConfig? config;

  /// Currently selected navigation item ID
  final String? selectedId;

  /// Page configuration for per-page overrides
  final VooPageConfig? pageConfig;

  const VooAppBarLeading({
    super.key,
    required this.showMenuButton,
    this.config,
    this.selectedId,
    this.pageConfig,
  });

  @override
  Widget build(BuildContext context) {
    // Try to get custom leading from builder first
    final customLeading = config?.appBarLeadingBuilder?.call(selectedId);
    if (customLeading != null) {
      return customLeading;
    }

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

    // Check shouldShowBackButton from page config
    final shouldShowBackButton = pageConfig?.shouldShowBackButton;

    // If explicitly set to false, don't show back button
    if (shouldShowBackButton == false) {
      return const SizedBox.shrink();
    }

    // Show back button if explicitly true OR if can pop (auto behavior)
    if (shouldShowBackButton == true || Navigator.of(context).canPop()) {
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
