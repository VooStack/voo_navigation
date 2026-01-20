import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_nav_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_multi_switcher.dart';

/// Multi-switcher widget for the navigation rail.
///
/// This wrapper follows the existing pattern of rail components,
/// providing a factory method for position-based rendering.
class VooRailMultiSwitcher extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Whether the rail is extended
  final bool extended;

  const VooRailMultiSwitcher({
    super.key,
    required this.config,
    required this.extended,
  });

  /// Factory method to create multi-switcher for a specific position.
  ///
  /// Returns null if multi-switcher is not configured or not in the
  /// specified position.
  static Widget? forPosition({
    required BuildContext context,
    required VooNavigationConfig config,
    required bool extended,
    required VooMultiSwitcherPosition position,
  }) {
    final multiSwitcher = config.multiSwitcher;
    if (multiSwitcher == null ||
        config.multiSwitcherPosition != position) {
      return null;
    }

    final isCompact = !extended;

    // For asNavItem position OR when compact (collapsed rail), use the nav item widget
    // This ensures proper sizing in the narrow collapsed rail
    if (position == VooMultiSwitcherPosition.asNavItem || isCompact) {
      // Use larger avatar size in footer/header for better visibility
      final isFooterOrHeader = position == VooMultiSwitcherPosition.footer ||
          position == VooMultiSwitcherPosition.header;
      final avatarSize = isCompact ? (isFooterOrHeader ? 36.0 : 24.0) : 28.0;

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: extended ? 8 : 4,
          vertical: isFooterOrHeader ? 8 : 4,
        ),
        child: VooMultiSwitcherNavItem(
          config: multiSwitcher,
          isCompact: isCompact,
          avatarSize: avatarSize,
          enableHapticFeedback: config.enableHapticFeedback,
          // Use rail style (not floating) so avatarSize is respected
          useFloatingStyle: false,
        ),
      );
    }

    // For header/footer positions when extended, use the standard multi-switcher card
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: VooMultiSwitcher(
        config: multiSwitcher,
        compact: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return forPosition(
          context: context,
          config: config,
          extended: extended,
          position: config.multiSwitcherPosition,
        ) ??
        const SizedBox.shrink();
  }
}
