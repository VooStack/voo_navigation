import 'package:flutter/widgets.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_profile_menu_item.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';

/// Configuration for the user profile displayed in navigation drawer/rail footer.
///
/// This is a data-only configuration class that allows the navigation components
/// to automatically create [VooUserProfileFooter] with the correct compact state
/// based on whether the navigation is collapsed.
///
/// Example usage:
/// ```dart
/// VooNavigationConfig(
///   items: navigationItems,
///   userProfileConfig: VooUserProfileConfig(
///     userName: 'Sarah Chen',
///     userEmail: 'sarah@acme.com',
///     status: VooUserStatus.online,
///     onSettingsTap: () => navigateTo('/settings'),
///     onLogout: () => showLogoutDialog(),
///   ),
/// )
/// ```
///
/// The navigation drawer/rail will automatically render the user profile
/// in compact mode (avatar only) when collapsed, and full mode when expanded.
class VooUserProfileConfig {
  /// User's display name
  final String? userName;

  /// User's email address
  final String? userEmail;

  /// User's avatar image URL or asset path
  final String? avatarUrl;

  /// Custom avatar widget (overrides avatarUrl)
  final Widget? avatarWidget;

  /// Initials to show if no avatar is provided
  final String? initials;

  /// Status indicator (online, away, busy, offline)
  final VooUserStatus? status;

  /// Callback when profile is tapped
  final VoidCallback? onTap;

  /// Callback when settings icon is tapped
  final VoidCallback? onSettingsTap;

  /// Callback when logout is requested
  final VoidCallback? onLogout;

  /// Custom dropdown menu items
  final List<VooProfileMenuItem>? menuItems;

  /// Whether to show the chevron/dropdown indicator
  final bool showDropdownIndicator;

  const VooUserProfileConfig({
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.avatarWidget,
    this.initials,
    this.status,
    this.onTap,
    this.onSettingsTap,
    this.onLogout,
    this.menuItems,
    this.showDropdownIndicator = true,
  });

  /// Creates a copy with the given fields replaced
  VooUserProfileConfig copyWith({
    String? userName,
    String? userEmail,
    String? avatarUrl,
    Widget? avatarWidget,
    String? initials,
    VooUserStatus? status,
    VoidCallback? onTap,
    VoidCallback? onSettingsTap,
    VoidCallback? onLogout,
    List<VooProfileMenuItem>? menuItems,
    bool? showDropdownIndicator,
  }) => VooUserProfileConfig(
    userName: userName ?? this.userName,
    userEmail: userEmail ?? this.userEmail,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    avatarWidget: avatarWidget ?? this.avatarWidget,
    initials: initials ?? this.initials,
    status: status ?? this.status,
    onTap: onTap ?? this.onTap,
    onSettingsTap: onSettingsTap ?? this.onSettingsTap,
    onLogout: onLogout ?? this.onLogout,
    menuItems: menuItems ?? this.menuItems,
    showDropdownIndicator: showDropdownIndicator ?? this.showDropdownIndicator,
  );
}
