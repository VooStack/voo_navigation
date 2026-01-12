import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_organization_switcher.dart';

/// Organization switcher widget for the navigation drawer
class VooDrawerOrganizationSwitcher extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  const VooDrawerOrganizationSwitcher({super.key, required this.config});

  /// Factory method to create org switcher for a specific position
  /// Returns null if org switcher is not configured for that position
  static Widget? forPosition({
    required VooNavigationConfig config,
    required VooOrganizationSwitcherPosition position,
  }) {
    final orgSwitcher = config.organizationSwitcher;
    if (orgSwitcher == null || config.organizationSwitcherPosition != position) {
      return null;
    }

    // In footer position, add a top border divider for visual separation
    final isFooter = position == VooOrganizationSwitcherPosition.footer;

    return _DrawerOrgSwitcherContainer(
      isFooter: isFooter,
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
        compact: orgSwitcher.compact,
        tooltip: orgSwitcher.tooltip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return forPosition(
          config: config,
          position: config.organizationSwitcherPosition,
        ) ??
        const SizedBox.shrink();
  }
}

/// Container for org switcher with footer-specific styling
class _DrawerOrgSwitcherContainer extends StatelessWidget {
  final bool isFooter;
  final Widget child;

  const _DrawerOrgSwitcherContainer({
    required this.isFooter,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isFooter) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: child,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
