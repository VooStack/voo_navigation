import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_user_profile_footer.dart';

/// User profile widget for the navigation rail footer
class VooRailUserProfile extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Whether the rail is extended
  final bool extended;

  const VooRailUserProfile({
    super.key,
    required this.config,
    required this.extended,
  });

  @override
  Widget build(BuildContext context) {
    // Rail must always use compact mode when collapsed to prevent overflow
    final isCompact = !extended;

    // If userProfileWidget is explicitly provided, use it (legacy API)
    if (config.userProfileWidget != null) {
      return Center(child: config.userProfileWidget!);
    }

    // If userProfileConfig is provided, create the widget with forced compact when collapsed
    final profileConfig = config.userProfileConfig;
    if (profileConfig != null) {
      return Center(
        child: VooUserProfileFooter(
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
          compact: isCompact ? true : null,
        ),
      );
    }

    // Default fallback - force compact when rail is collapsed
    return Center(
      child: VooUserProfileFooter(
        compact: isCompact ? true : null,
      ),
    );
  }
}
