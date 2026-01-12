import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_organization_switcher.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_default_header.dart';

/// Header widget for the navigation drawer
class VooDrawerHeader extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  const VooDrawerHeader({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final customHeader = config.drawerHeader;
    final trailing = config.drawerHeaderTrailing;
    final orgSwitcher = config.organizationSwitcher;
    final showOrgSwitcherInHeader = orgSwitcher != null &&
        config.organizationSwitcherPosition == VooOrganizationSwitcherPosition.header;

    // Build organization switcher if configured for header
    Widget? orgSwitcherWidget;
    if (showOrgSwitcherInHeader) {
      orgSwitcherWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

    // If using custom header, place toggle at top-right aligned with title
    if (customHeader != null) {
      Widget header = customHeader;

      if (trailing != null) {
        header = Stack(
          children: [
            customHeader,
            Positioned(top: 24, right: 12, child: trailing),
          ],
        );
      }

      if (orgSwitcherWidget != null) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [header, orgSwitcherWidget],
        );
      }

      return header;
    }

    // Default header handling - use headerConfig if provided
    final headerConfig = config.headerConfig;
    final Widget headerContent;
    if (headerConfig != null) {
      headerContent = VooDrawerDefaultHeader(
        title: headerConfig.title ?? 'Navigation',
        tagline: headerConfig.tagline,
        icon: headerConfig.logoIcon ?? Icons.dashboard,
        trailing: trailing,
      );
    } else {
      headerContent = VooDrawerDefaultHeader(trailing: trailing);
    }

    final Widget result = headerContent;

    if (orgSwitcherWidget != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [result, orgSwitcherWidget],
      );
    }

    return result;
  }
}
