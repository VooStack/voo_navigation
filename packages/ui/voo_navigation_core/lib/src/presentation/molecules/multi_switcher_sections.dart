import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_tiles.dart';

/// Organization section for the multi-switcher modal.
///
/// Displays a list of organizations with a section title and optional
/// create organization button.
class VooMultiSwitcherOrganizationSection extends StatelessWidget {
  /// Configuration for the multi-switcher
  final VooMultiSwitcherConfig config;

  /// Filtered list of organizations to display
  final List<VooOrganization> organizations;

  /// Callback when an organization is selected
  final ValueChanged<VooOrganization> onSelect;

  const VooMultiSwitcherOrganizationSection({
    super.key,
    required this.config,
    required this.organizations,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = config.style ?? const VooMultiSwitcherStyle();

    // Allow custom section builder
    if (config.organizationSectionBuilder != null) {
      return config.organizationSectionBuilder!(
        context,
        VooMultiSwitcherModalData(
          organizations: organizations,
          selectedOrganization: config.selectedOrganization,
          users: config.users,
          selectedUser: config.selectedUser,
          userName: config.userName,
          userEmail: config.userEmail,
          avatarUrl: config.avatarUrl,
          initials: config.initials,
          status: config.status,
          isLoading: config.isLoading,
          onClose: () {},
          onOrganizationSelected: onSelect,
          onUserSelected: config.onUserChanged,
          onSettingsTap: config.onSettingsTap,
          onLogout: config.onLogout,
          onCreateOrganization: config.onCreateOrganization,
          onAddUser: config.onAddUser,
          menuItems: config.menuItems,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        Padding(
          padding: style.sectionPadding ??
              const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            config.organizationSectionTitle ?? 'Organizations',
            style: style.sectionTitleStyle ??
                theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
        ),

        // Organization list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...organizations.map((org) => VooMultiSwitcherOrgTile(
                    organization: org,
                    isSelected: org.id == config.selectedOrganization?.id,
                    style: style,
                    onTap: () => onSelect(org),
                  )),

              // Create button
              if (config.onCreateOrganization != null)
                VooMultiSwitcherCreateButton(
                  label: config.createOrganizationLabel ?? 'New Organization',
                  icon: Icons.add_circle_outline_rounded,
                  onTap: config.onCreateOrganization!,
                  style: style,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// User section for the multi-switcher modal.
///
/// Displays the current user info, optional list of users for switching,
/// and action buttons (settings, logout).
class VooMultiSwitcherUserSection extends StatelessWidget {
  /// Configuration for the multi-switcher
  final VooMultiSwitcherConfig config;

  /// Callback when a user is selected (for multi-account)
  final ValueChanged<dynamic>? onSelect;

  /// Callback when logout is requested
  final VoidCallback? onLogout;

  /// Callback when settings is tapped
  final VoidCallback? onSettings;

  const VooMultiSwitcherUserSection({
    super.key,
    required this.config,
    this.onSelect,
    this.onLogout,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = config.style ?? const VooMultiSwitcherStyle();

    // Allow custom section builder
    if (config.userSectionBuilder != null) {
      return config.userSectionBuilder!(
        context,
        VooMultiSwitcherModalData(
          organizations: config.organizations,
          selectedOrganization: config.selectedOrganization,
          users: config.users,
          selectedUser: config.selectedUser,
          userName: config.userName,
          userEmail: config.userEmail,
          avatarUrl: config.avatarUrl,
          initials: config.initials,
          status: config.status,
          isLoading: config.isLoading,
          onClose: () {},
          onOrganizationSelected: (_) {},
          onUserSelected: config.onUserChanged,
          onSettingsTap: onSettings,
          onLogout: onLogout,
          onCreateOrganization: config.onCreateOrganization,
          onAddUser: config.onAddUser,
          menuItems: config.menuItems,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        Padding(
          padding: style.sectionPadding ??
              const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            config.userSectionTitle ?? 'Account',
            style: style.sectionTitleStyle ??
                theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
        ),

        // Current user info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VooMultiSwitcherUserInfoTile(
                userName: config.userName,
                userEmail: config.userEmail,
                avatarUrl: config.avatarUrl,
                avatarWidget: config.avatarWidget,
                initials: config.initials,
                status: config.status,
                style: style,
              ),

              // User list (if multi-user)
              if (config.users != null && config.users!.isNotEmpty) ...[
                const SizedBox(height: 4),
                ...config.users!.map((user) => VooMultiSwitcherUserTile(
                      user: user,
                      isSelected: user.id == config.selectedUser?.id,
                      style: style,
                      onTap: () => config.onUserChanged?.call(user),
                    )),
              ],

              // Add user button
              if (config.onAddUser != null)
                VooMultiSwitcherCreateButton(
                  label: config.addUserLabel ?? 'Add Account',
                  icon: Icons.person_add_outlined,
                  onTap: config.onAddUser!,
                  style: style,
                ),

              // Custom menu items
              if (config.menuItems != null && config.menuItems!.isNotEmpty) ...[
                const SizedBox(height: 4),
                ...config.menuItems!.map((item) => VooMultiSwitcherActionTile(
                      icon: item.icon,
                      label: item.label,
                      onTap: item.onTap ?? () {},
                      isDestructive: item.isDestructive,
                      style: style,
                    )),
              ],

              // Action buttons (Settings, Logout)
              if (onSettings != null || onLogout != null) ...[
                const SizedBox(height: 8),
                Divider(
                  height: 1,
                  indent: 8,
                  endIndent: 8,
                  color: style.sectionDividerColor ??
                      theme.dividerColor.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 8),

                if (onSettings != null)
                  VooMultiSwitcherActionTile(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: onSettings!,
                    style: style,
                  ),

                if (onLogout != null)
                  VooMultiSwitcherActionTile(
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    onTap: onLogout!,
                    isDestructive: true,
                    style: style,
                  ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
