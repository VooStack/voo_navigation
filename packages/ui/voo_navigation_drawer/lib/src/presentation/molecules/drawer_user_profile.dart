import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_user_profile_footer.dart';

/// User profile widget for the navigation drawer footer
class VooDrawerUserProfile extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  const VooDrawerUserProfile({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    // Check if org switcher is in footer position (above profile)
    final hasOrgSwitcherAbove = config.organizationSwitcher != null &&
        config.organizationSwitcherPosition == VooOrganizationSwitcherPosition.footer;

    // If userProfileWidget is explicitly provided, use it (legacy API)
    if (config.userProfileWidget != null) {
      return config.userProfileWidget!;
    }

    // If userProfileConfig is provided, create the widget with auto-compact
    final profileConfig = config.userProfileConfig;
    if (profileConfig != null) {
      return VooUserProfileFooter(
        userName: profileConfig.userName,
        userEmail: profileConfig.userEmail,
        avatarUrl: profileConfig.avatarUrl,
        avatarWidget: profileConfig.avatarWidget,
        initials: profileConfig.initials,
        status: profileConfig.status,
        onTap: profileConfig.onTap,
        onSettingsTap: profileConfig.onSettingsTap,
        onLogout: profileConfig.onLogout,
        menuItems: profileConfig.menuItems,
        showDropdownIndicator: profileConfig.showDropdownIndicator,
        showTopBorder: !hasOrgSwitcherAbove,
      );
    }

    // Default fallback
    return VooUserProfileFooter(
      showTopBorder: !hasOrgSwitcherAbove,
    );
  }
}
