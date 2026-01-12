import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_organization_switcher.dart';

/// Organization switcher widget for the navigation rail
class VooRailOrganizationSwitcher extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Whether the rail is extended
  final bool extended;

  const VooRailOrganizationSwitcher({
    super.key,
    required this.config,
    required this.extended,
  });

  /// Factory method to create org switcher for a specific position
  /// Returns null if org switcher is not configured for that position
  static Widget? forPosition({
    required BuildContext context,
    required VooNavigationConfig config,
    required bool extended,
    required VooOrganizationSwitcherPosition position,
  }) {
    final orgSwitcher = config.organizationSwitcher;
    if (orgSwitcher == null || config.organizationSwitcherPosition != position) {
      return null;
    }

    // Rail must always use compact mode when collapsed to prevent overflow
    final isCompact = !extended;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: 8,
      ),
      child: Center(
        child: VooOrganizationSwitcher(
          organizations: orgSwitcher.organizations,
          selectedOrganization: orgSwitcher.selectedOrganization,
          onOrganizationChanged: orgSwitcher.onOrganizationChanged,
          onCreateOrganization: orgSwitcher.onCreateOrganization,
          showSearch: orgSwitcher.showSearch,
          showCreateButton: orgSwitcher.showCreateButton,
          createButtonLabel: orgSwitcher.createButtonLabel,
          searchHint: orgSwitcher.searchHint,
          style: orgSwitcher.style,
          compact: isCompact ? true : orgSwitcher.compact,
          tooltip: orgSwitcher.tooltip,
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
          position: config.organizationSwitcherPosition,
        ) ??
        const SizedBox.shrink();
  }
}
