import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/presentation/molecules/context_switcher_nav_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_context_switcher.dart';

/// Context switcher widget for the navigation rail.
///
/// This wrapper follows the existing pattern of rail components,
/// providing a factory method for position-based rendering.
class VooRailContextSwitcher extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Whether the rail is extended
  final bool extended;

  const VooRailContextSwitcher({
    super.key,
    required this.config,
    required this.extended,
  });

  /// Factory method to create context switcher for a specific position.
  ///
  /// Returns null if context switcher is not configured or not in the
  /// specified position.
  static Widget? forPosition({
    required BuildContext context,
    required VooNavigationConfig config,
    required bool extended,
    required VooContextSwitcherPosition position,
  }) {
    final contextSwitcher = config.contextSwitcher;
    if (contextSwitcher == null ||
        config.contextSwitcherPosition != position) {
      return null;
    }

    // For asNavItem position, use the nav item widget
    if (position == VooContextSwitcherPosition.asNavItem) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: extended ? 8 : 8,
          vertical: 4,
        ),
        child: VooContextSwitcherNavItem(
          config: contextSwitcher,
          isCompact: !extended,
          avatarSize: extended ? 24 : 24,
          enableHapticFeedback: config.enableHapticFeedback,
        ),
      );
    }

    // For other positions (beforeItems, afterHeader), use the standard context switcher
    final isCompact = !extended;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: 4,
      ),
      child: VooContextSwitcher(
        config: contextSwitcher.copyWith(
          compact: isCompact ? true : contextSwitcher.compact,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return forPosition(
          context: context,
          config: config,
          extended: extended,
          position: config.contextSwitcherPosition,
        ) ??
        const SizedBox.shrink();
  }
}
