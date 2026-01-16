import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_multi_switcher.dart';

/// Multi-switcher widget for the navigation drawer.
///
/// This wrapper follows the existing pattern of drawer components,
/// providing a factory method for position-based rendering.
class VooDrawerMultiSwitcher extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  const VooDrawerMultiSwitcher({
    super.key,
    required this.config,
  });

  /// Factory method to create multi-switcher for a specific position.
  ///
  /// Returns null if multi-switcher is not configured or not in the
  /// specified position.
  static Widget? forPosition({
    required VooNavigationConfig config,
    required VooMultiSwitcherPosition position,
  }) {
    final multiSwitcher = config.multiSwitcher;
    if (multiSwitcher == null || config.multiSwitcherPosition != position) {
      return null;
    }

    return VooMultiSwitcher(config: multiSwitcher);
  }

  @override
  Widget build(BuildContext context) {
    final multiSwitcher = config.multiSwitcher;
    if (multiSwitcher == null) {
      return const SizedBox.shrink();
    }

    return VooMultiSwitcher(config: multiSwitcher);
  }
}
