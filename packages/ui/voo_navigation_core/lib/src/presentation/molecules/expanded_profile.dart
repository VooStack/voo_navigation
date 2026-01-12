import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_profile_menu_item.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';
import 'package:voo_navigation_core/src/presentation/molecules/profile_avatar.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Expanded profile display for full navigation
class VooExpandedProfile extends StatefulWidget {
  /// User's display name
  final String? userName;

  /// User's email address
  final String? userEmail;

  /// Custom avatar widget
  final Widget? avatarWidget;

  /// User's avatar image URL
  final String? avatarUrl;

  /// Initials to show if no avatar is provided
  final String? initials;

  /// User status indicator
  final VooUserStatus? status;

  /// Whether to show the dropdown indicator
  final bool showDropdownIndicator;

  /// Whether to show the top border divider
  final bool showTopBorder;

  /// Callback when tapped
  final VoidCallback? onTap;

  /// Callback when settings is tapped
  final VoidCallback? onSettingsTap;

  /// Callback when logout is requested
  final VoidCallback? onLogout;

  /// Custom dropdown menu items
  final List<VooProfileMenuItem>? menuItems;

  const VooExpandedProfile({
    super.key,
    this.userName,
    this.userEmail,
    this.avatarWidget,
    this.avatarUrl,
    this.initials,
    this.status,
    this.showDropdownIndicator = true,
    this.showTopBorder = true,
    this.onTap,
    this.onSettingsTap,
    this.onLogout,
    this.menuItems,
  });

  @override
  State<VooExpandedProfile> createState() => _VooExpandedProfileState();
}

class _VooExpandedProfileState extends State<VooExpandedProfile> {
  bool _isHovered = false;

  void _showProfileMenu(BuildContext context) {
    final theme = Theme.of(context);
    final radius = context.vooRadius;

    final defaultItems = [
      VooProfileMenuItem(
        icon: Icons.person_outline_rounded,
        label: 'View Profile',
        onTap: widget.onTap,
      ),
      VooProfileMenuItem(
        icon: Icons.settings_outlined,
        label: 'Settings',
        onTap: widget.onSettingsTap,
      ),
      VooProfileMenuItem(
        icon: Icons.logout_rounded,
        label: 'Sign Out',
        onTap: widget.onLogout,
        isDestructive: true,
      ),
    ];

    final items = widget.menuItems ?? defaultItems;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius.lg),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...items.map((item) => ListTile(
                  leading: Icon(
                    item.icon,
                    color: item.isDestructive
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      color: item.isDestructive
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    item.onTap?.call();
                  },
                )),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;

    return Container(
      padding: widget.showTopBorder
          ? EdgeInsets.all(spacing.sm)
          : EdgeInsets.zero,
      decoration: widget.showTopBorder
          ? BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            )
          : null,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap ?? () => _showProfileMenu(context),
            borderRadius: BorderRadius.circular(8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: _isHovered
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: _isHovered
                    ? Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  VooProfileAvatar(
                    avatarWidget: widget.avatarWidget,
                    avatarUrl: widget.avatarUrl,
                    userName: widget.userName,
                    initials: widget.initials,
                    status: widget.status,
                    size: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.userName ?? 'User',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.userEmail != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.userEmail!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (widget.showDropdownIndicator)
                    AnimatedRotation(
                      turns: _isHovered ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
