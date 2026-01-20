import 'package:flutter/widgets.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_user.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_profile_menu_item.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';

/// Configuration for the multi-switcher component.
///
/// The multi-switcher combines organization and user switching into a single,
/// animated component that displays as a card (closed) and expands to a modal
/// (open) within the navigation drawer.
///
/// Example usage:
/// ```dart
/// VooMultiSwitcherConfig(
///   // Organization data
///   organizations: myOrganizations,
///   selectedOrganization: currentOrg,
///   onOrganizationChanged: (org) => setState(() => currentOrg = org),
///
///   // User data
///   userName: 'John Doe',
///   userEmail: 'john@example.com',
///   status: VooUserStatus.online,
///
///   // Actions
///   onSettingsTap: () => openSettings(),
///   onLogout: () => logout(),
/// )
/// ```
class VooMultiSwitcherConfig {
  // ============================================================================
  // ORGANIZATION DATA
  // ============================================================================

  /// List of organizations available for switching
  final List<VooOrganization> organizations;

  /// Currently selected organization
  final VooOrganization? selectedOrganization;

  /// Callback when an organization is selected
  final ValueChanged<VooOrganization>? onOrganizationChanged;

  /// Callback to create a new organization
  final VoidCallback? onCreateOrganization;

  /// Label for the create organization button
  final String? createOrganizationLabel;

  // ============================================================================
  // USER DATA
  // ============================================================================

  /// Current user's display name
  final String? userName;

  /// Current user's email address
  final String? userEmail;

  /// URL for the current user's avatar
  final String? avatarUrl;

  /// Custom widget for the current user's avatar (overrides avatarUrl)
  final Widget? avatarWidget;

  /// Initials to show if no avatar is provided
  final String? initials;

  /// Current user's online status
  final VooUserStatus? status;

  /// List of users available for switching (for multi-account support)
  final List<VooMultiSwitcherUser>? users;

  /// Currently selected user (when using multi-account)
  final VooMultiSwitcherUser? selectedUser;

  /// Callback when a user is selected
  final ValueChanged<VooMultiSwitcherUser>? onUserChanged;

  /// Callback to add a new user/account
  final VoidCallback? onAddUser;

  /// Label for the add user button
  final String? addUserLabel;

  // ============================================================================
  // CALLBACKS & ACTIONS
  // ============================================================================

  /// Callback when settings is tapped
  final VoidCallback? onSettingsTap;

  /// Callback when logout is requested
  final VoidCallback? onLogout;

  /// Custom menu items to display in the user section
  final List<VooProfileMenuItem>? menuItems;

  // ============================================================================
  // DISPLAY OPTIONS
  // ============================================================================

  /// Whether to show the organization section in the modal
  final bool showOrganizationSection;

  /// Whether to show the user section in the modal
  final bool showUserSection;

  /// Whether to show the search field in the modal
  final bool showSearch;

  /// Title for the organization section
  final String? organizationSectionTitle;

  /// Title for the user section
  final String? userSectionTitle;

  /// Hint text for the search field
  final String? searchHint;

  // ============================================================================
  // STYLING
  // ============================================================================

  /// Custom style configuration
  final VooMultiSwitcherStyle? style;

  /// Whether to show in compact mode (avatar only)
  /// When null, auto-detects from VooCollapseState in widget tree.
  final bool? compact;

  /// Tooltip text when hovering over the card
  final String? tooltip;

  // ============================================================================
  // MOBILE NAV ITEM OPTIONS
  // ============================================================================

  /// Whether to show as a navigation item in rail/bottom nav.
  final bool showAsNavItem;

  /// Whether to include in mobile bottom navigation (max 5 items).
  final bool mobilePriority;

  /// Sort order for nav item positioning in mobile bottom navigation.
  final int navItemSortOrder;

  /// Label for the nav item. Defaults to user name or 'Account'.
  final String? navItemLabel;

  // ============================================================================
  // CUSTOM BUILDERS
  // ============================================================================

  /// Custom builder for the card (closed state).
  /// When provided, completely overrides the default card UI.
  final Widget Function(BuildContext context, VooMultiSwitcherCardData data)?
      cardBuilder;

  /// Custom builder for the modal (open state).
  /// When provided, completely overrides the default modal UI.
  final Widget Function(BuildContext context, VooMultiSwitcherModalData data)?
      modalBuilder;

  /// Custom builder for the organization section.
  /// When provided, replaces the default organization list.
  final Widget Function(BuildContext context, VooMultiSwitcherModalData data)?
      organizationSectionBuilder;

  /// Custom builder for the user section.
  /// When provided, replaces the default user section.
  final Widget Function(BuildContext context, VooMultiSwitcherModalData data)?
      userSectionBuilder;

  const VooMultiSwitcherConfig({
    // Organization data
    this.organizations = const [],
    this.selectedOrganization,
    this.onOrganizationChanged,
    this.onCreateOrganization,
    this.createOrganizationLabel,
    // User data
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.avatarWidget,
    this.initials,
    this.status,
    this.users,
    this.selectedUser,
    this.onUserChanged,
    this.onAddUser,
    this.addUserLabel,
    // Callbacks
    this.onSettingsTap,
    this.onLogout,
    this.menuItems,
    // Display options
    this.showOrganizationSection = true,
    this.showUserSection = true,
    this.showSearch = false,
    this.organizationSectionTitle,
    this.userSectionTitle,
    this.searchHint,
    // Styling
    this.style,
    this.compact,
    this.tooltip,
    // Mobile nav item options
    this.showAsNavItem = false,
    this.mobilePriority = false,
    this.navItemSortOrder = 0,
    this.navItemLabel,
    // Custom builders
    this.cardBuilder,
    this.modalBuilder,
    this.organizationSectionBuilder,
    this.userSectionBuilder,
  });

  /// Creates a copy with the given fields replaced
  VooMultiSwitcherConfig copyWith({
    // Organization data
    List<VooOrganization>? organizations,
    VooOrganization? selectedOrganization,
    ValueChanged<VooOrganization>? onOrganizationChanged,
    VoidCallback? onCreateOrganization,
    String? createOrganizationLabel,
    // User data
    String? userName,
    String? userEmail,
    String? avatarUrl,
    Widget? avatarWidget,
    String? initials,
    VooUserStatus? status,
    List<VooMultiSwitcherUser>? users,
    VooMultiSwitcherUser? selectedUser,
    ValueChanged<VooMultiSwitcherUser>? onUserChanged,
    VoidCallback? onAddUser,
    String? addUserLabel,
    // Callbacks
    VoidCallback? onSettingsTap,
    VoidCallback? onLogout,
    List<VooProfileMenuItem>? menuItems,
    // Display options
    bool? showOrganizationSection,
    bool? showUserSection,
    bool? showSearch,
    String? organizationSectionTitle,
    String? userSectionTitle,
    String? searchHint,
    // Styling
    VooMultiSwitcherStyle? style,
    bool? compact,
    String? tooltip,
    // Mobile nav item options
    bool? showAsNavItem,
    bool? mobilePriority,
    int? navItemSortOrder,
    String? navItemLabel,
    // Custom builders
    Widget Function(BuildContext context, VooMultiSwitcherCardData data)?
        cardBuilder,
    Widget Function(BuildContext context, VooMultiSwitcherModalData data)?
        modalBuilder,
    Widget Function(BuildContext context, VooMultiSwitcherModalData data)?
        organizationSectionBuilder,
    Widget Function(BuildContext context, VooMultiSwitcherModalData data)?
        userSectionBuilder,
  }) =>
      VooMultiSwitcherConfig(
        organizations: organizations ?? this.organizations,
        selectedOrganization: selectedOrganization ?? this.selectedOrganization,
        onOrganizationChanged:
            onOrganizationChanged ?? this.onOrganizationChanged,
        onCreateOrganization: onCreateOrganization ?? this.onCreateOrganization,
        createOrganizationLabel:
            createOrganizationLabel ?? this.createOrganizationLabel,
        userName: userName ?? this.userName,
        userEmail: userEmail ?? this.userEmail,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        avatarWidget: avatarWidget ?? this.avatarWidget,
        initials: initials ?? this.initials,
        status: status ?? this.status,
        users: users ?? this.users,
        selectedUser: selectedUser ?? this.selectedUser,
        onUserChanged: onUserChanged ?? this.onUserChanged,
        onAddUser: onAddUser ?? this.onAddUser,
        addUserLabel: addUserLabel ?? this.addUserLabel,
        onSettingsTap: onSettingsTap ?? this.onSettingsTap,
        onLogout: onLogout ?? this.onLogout,
        menuItems: menuItems ?? this.menuItems,
        showOrganizationSection:
            showOrganizationSection ?? this.showOrganizationSection,
        showUserSection: showUserSection ?? this.showUserSection,
        showSearch: showSearch ?? this.showSearch,
        organizationSectionTitle:
            organizationSectionTitle ?? this.organizationSectionTitle,
        userSectionTitle: userSectionTitle ?? this.userSectionTitle,
        searchHint: searchHint ?? this.searchHint,
        style: style ?? this.style,
        compact: compact ?? this.compact,
        tooltip: tooltip ?? this.tooltip,
        showAsNavItem: showAsNavItem ?? this.showAsNavItem,
        mobilePriority: mobilePriority ?? this.mobilePriority,
        navItemSortOrder: navItemSortOrder ?? this.navItemSortOrder,
        navItemLabel: navItemLabel ?? this.navItemLabel,
        cardBuilder: cardBuilder ?? this.cardBuilder,
        modalBuilder: modalBuilder ?? this.modalBuilder,
        organizationSectionBuilder:
            organizationSectionBuilder ?? this.organizationSectionBuilder,
        userSectionBuilder: userSectionBuilder ?? this.userSectionBuilder,
      );
}

/// Data passed to custom card builder.
///
/// This class provides all the information needed to build a custom card
/// for the multi-switcher's closed state.
class VooMultiSwitcherCardData {
  /// Currently selected organization
  final VooOrganization? selectedOrganization;

  /// Current user's display name
  final String? userName;

  /// Current user's email address
  final String? userEmail;

  /// URL for the current user's avatar
  final String? avatarUrl;

  /// Custom widget for the avatar
  final Widget? avatarWidget;

  /// User initials
  final String? initials;

  /// Current user's online status
  final VooUserStatus? status;

  /// Whether the modal is currently expanded
  final bool isExpanded;

  /// Callback to toggle the modal open/closed
  final VoidCallback onTap;

  const VooMultiSwitcherCardData({
    this.selectedOrganization,
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.avatarWidget,
    this.initials,
    this.status,
    required this.isExpanded,
    required this.onTap,
  });
}

/// Data passed to custom modal builder.
///
/// This class provides all the information needed to build a custom modal
/// for the multi-switcher's open state.
class VooMultiSwitcherModalData {
  /// List of available organizations
  final List<VooOrganization> organizations;

  /// Currently selected organization
  final VooOrganization? selectedOrganization;

  /// List of available users (for multi-account support)
  final List<VooMultiSwitcherUser>? users;

  /// Currently selected user
  final VooMultiSwitcherUser? selectedUser;

  /// Current user's display name
  final String? userName;

  /// Current user's email address
  final String? userEmail;

  /// URL for the current user's avatar
  final String? avatarUrl;

  /// User initials
  final String? initials;

  /// Current user's online status
  final VooUserStatus? status;

  /// Callback to close the modal
  final VoidCallback onClose;

  /// Callback when an organization is selected
  final ValueChanged<VooOrganization> onOrganizationSelected;

  /// Callback when a user is selected
  final ValueChanged<VooMultiSwitcherUser>? onUserSelected;

  /// Callback when settings is tapped
  final VoidCallback? onSettingsTap;

  /// Callback when logout is tapped
  final VoidCallback? onLogout;

  /// Callback to create a new organization
  final VoidCallback? onCreateOrganization;

  /// Callback to add a new user
  final VoidCallback? onAddUser;

  /// Custom menu items
  final List<VooProfileMenuItem>? menuItems;

  const VooMultiSwitcherModalData({
    required this.organizations,
    this.selectedOrganization,
    this.users,
    this.selectedUser,
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.initials,
    this.status,
    required this.onClose,
    required this.onOrganizationSelected,
    this.onUserSelected,
    this.onSettingsTap,
    this.onLogout,
    this.onCreateOrganization,
    this.onAddUser,
    this.menuItems,
  });
}
