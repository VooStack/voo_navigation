import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_context_switcher.dart';

/// Context switcher widget for the navigation drawer.
///
/// This wrapper follows the existing pattern of drawer components,
/// providing a factory method for position-based rendering.
class VooDrawerContextSwitcher extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  const VooDrawerContextSwitcher({
    super.key,
    required this.config,
  });

  /// Factory method to create context switcher for a specific position.
  ///
  /// Returns null if context switcher is not configured or not in the
  /// specified position.
  static Widget? forPosition({
    required VooNavigationConfig config,
    required VooContextSwitcherPosition position,
  }) {
    final contextSwitcher = config.contextSwitcher;
    if (contextSwitcher == null ||
        config.contextSwitcherPosition != position) {
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: VooContextSwitcher(config: contextSwitcher),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contextSwitcher = config.contextSwitcher;
    if (contextSwitcher == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: VooContextSwitcher(config: contextSwitcher),
    );
  }
}
