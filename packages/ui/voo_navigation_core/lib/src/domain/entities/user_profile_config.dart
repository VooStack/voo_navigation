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

  // ============================================================================
  // MOBILE NAV ITEM OPTIONS
  // ============================================================================

  /// Whether to include in mobile bottom navigation (max 5 items).
  /// When true, the user profile appears as a nav item showing the avatar
  /// or initials.
  final bool mobilePriority;

  /// Sort order for nav item positioning in mobile bottom navigation.
  /// Lower values appear first. Only relevant when [mobilePriority] is true.
  final int navItemSortOrder;

  /// Label for the nav item. Defaults to [userName] or 'Profile'.
  final String? navItemLabel;

  // ============================================================================
  // CUSTOM BUILDERS
  // ============================================================================

  /// Custom builder for the modal (open state) in bottom navigation.
  /// When provided, tapping the profile nav item opens this modal instead
  /// of calling [onTap].
  ///
  /// Example:
  /// ```dart
  /// modalBuilder: (context, data) => Column(
  ///   children: [
  ///     ListTile(title: Text('Settings'), onTap: () { data.onClose(); }),
  ///     ListTile(title: Text('Logout'), onTap: () { data.onClose(); }),
  ///   ],
  /// ),
  /// ```
  final Widget Function(BuildContext context, VooUserProfileModalData data)?
      modalBuilder;

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
    this.mobilePriority = false,
    this.navItemSortOrder = 0,
    this.navItemLabel,
    this.modalBuilder,
  });

  /// Gets the effective initials (derived from userName if not provided)
  String? get effectiveInitials {
    if (initials != null) return initials;
    if (userName == null || userName!.isEmpty) return null;
    final parts = userName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return userName![0].toUpperCase();
  }

  /// Gets the effective nav item label
  String get effectiveNavItemLabel => navItemLabel ?? userName ?? 'Profile';

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
    bool? mobilePriority,
    int? navItemSortOrder,
    String? navItemLabel,
    Widget Function(BuildContext context, VooUserProfileModalData data)?
        modalBuilder,
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
    mobilePriority: mobilePriority ?? this.mobilePriority,
    navItemSortOrder: navItemSortOrder ?? this.navItemSortOrder,
    navItemLabel: navItemLabel ?? this.navItemLabel,
    modalBuilder: modalBuilder ?? this.modalBuilder,
  );
}

/// Data passed to custom modal builder for user profile.
///
/// This class provides all the information needed to build a custom modal
/// for the user profile's open state in bottom navigation.
class VooUserProfileModalData {
  /// User's display name
  final String? userName;

  /// User's email address
  final String? userEmail;

  /// User's avatar image URL or asset path
  final String? avatarUrl;

  /// Custom avatar widget
  final Widget? avatarWidget;

  /// Initials to show if no avatar is provided
  final String? initials;

  /// Status indicator
  final VooUserStatus? status;

  /// Callback to close the modal
  final VoidCallback onClose;

  /// Callback when settings is tapped
  final VoidCallback? onSettingsTap;

  /// Callback when logout is tapped
  final VoidCallback? onLogout;

  /// Custom menu items
  final List<VooProfileMenuItem>? menuItems;

  const VooUserProfileModalData({
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.avatarWidget,
    this.initials,
    this.status,
    required this.onClose,
    this.onSettingsTap,
    this.onLogout,
    this.menuItems,
  });
}
