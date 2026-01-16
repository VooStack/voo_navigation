import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_user.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_avatar.dart';

/// Stacked avatars widget showing organization logo with user avatar overlay.
///
/// This widget displays the org avatar as the background with the user avatar
/// positioned in the bottom-right corner, creating a compact visual representation
/// of the current organization and user.
class VooStackedAvatars extends StatelessWidget {
  /// The currently selected organization
  final VooOrganization? organization;

  /// URL for the user's avatar image
  final String? userAvatarUrl;

  /// User's name (for generating initials)
  final String? userName;

  /// User's online status
  final VooUserStatus? status;

  /// Size of the organization avatar
  final double orgAvatarSize;

  /// Size of the user avatar
  final double userAvatarSize;

  /// Whether to show the status indicator
  final bool showStatus;

  const VooStackedAvatars({
    super.key,
    this.organization,
    this.userAvatarUrl,
    this.userName,
    this.status,
    this.orgAvatarSize = 32,
    this.userAvatarSize = 24,
    this.showStatus = true,
  });

  Color _getStatusColor(VooUserStatus status) {
    switch (status) {
      case VooUserStatus.online:
        return const Color(0xFF22C55E); // Green
      case VooUserStatus.away:
        return const Color(0xFFF59E0B); // Amber
      case VooUserStatus.busy:
        return const Color(0xFFEF4444); // Red
      case VooUserStatus.offline:
        return const Color(0xFF9CA3AF); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalWidth = orgAvatarSize + (userAvatarSize * 0.3);
    final totalHeight = orgAvatarSize + (userAvatarSize * 0.3);

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Organization avatar (background, top-left)
          Positioned(
            left: 0,
            top: 0,
            child: VooAvatar(
              imageUrl: organization?.avatarUrl,
              child: organization?.avatarWidget,
              name: organization?.name,
              backgroundColor: organization?.avatarColor,
              size: orgAvatarSize,
              placeholderIcon: Icons.business_rounded,
            ),
          ),
          // User avatar (foreground, bottom-right)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
              child: VooAvatar(
                imageUrl: userAvatarUrl,
                name: userName,
                size: userAvatarSize,
              ),
            ),
          ),
          // Status indicator (on user avatar)
          if (showStatus && status != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _getStatusColor(status!),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Organization tile for the multi-switcher modal.
class VooMultiSwitcherOrgTile extends StatefulWidget {
  /// The organization to display
  final VooOrganization organization;

  /// Whether this organization is currently selected
  final bool isSelected;

  /// Style configuration
  final VooMultiSwitcherStyle? style;

  /// Callback when the tile is tapped
  final VoidCallback onTap;

  const VooMultiSwitcherOrgTile({
    super.key,
    required this.organization,
    required this.isSelected,
    this.style,
    required this.onTap,
  });

  @override
  State<VooMultiSwitcherOrgTile> createState() => _VooMultiSwitcherOrgTileState();
}

class _VooMultiSwitcherOrgTileState extends State<VooMultiSwitcherOrgTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style ?? const VooMultiSwitcherStyle();

    final selectedColor = style.selectedColor ??
        theme.colorScheme.primary
            .withValues(alpha: VooNavigationTokens.opacitySelectedBackground);
    final hoverColor = style.hoverColor ??
        theme.colorScheme.onSurface
            .withValues(alpha: VooNavigationTokens.opacityHoverBackground);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: style.itemBorderRadius ??
              BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? selectedColor
                  : _isHovered
                      ? hoverColor
                      : Colors.transparent,
              borderRadius: style.itemBorderRadius ??
                  BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
            ),
            child: Row(
              children: [
                VooAvatar(
                  imageUrl: widget.organization.avatarUrl,
                  child: widget.organization.avatarWidget,
                  name: widget.organization.name,
                  backgroundColor: widget.organization.avatarColor,
                  size: style.avatarSize,
                  placeholderIcon: Icons.business_rounded,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.organization.name,
                        style: style.titleStyle ??
                            theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: widget.isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.organization.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.organization.subtitle!,
                          style: style.subtitleStyle ??
                              theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.isSelected)
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// User tile for the multi-switcher modal.
class VooMultiSwitcherUserTile extends StatefulWidget {
  /// The user to display
  final VooMultiSwitcherUser user;

  /// Whether this user is currently selected
  final bool isSelected;

  /// Style configuration
  final VooMultiSwitcherStyle? style;

  /// Callback when the tile is tapped
  final VoidCallback onTap;

  const VooMultiSwitcherUserTile({
    super.key,
    required this.user,
    required this.isSelected,
    this.style,
    required this.onTap,
  });

  @override
  State<VooMultiSwitcherUserTile> createState() =>
      _VooMultiSwitcherUserTileState();
}

class _VooMultiSwitcherUserTileState extends State<VooMultiSwitcherUserTile> {
  bool _isHovered = false;

  Color _getStatusColor(VooUserStatus status) {
    switch (status) {
      case VooUserStatus.online:
        return const Color(0xFF22C55E);
      case VooUserStatus.away:
        return const Color(0xFFF59E0B);
      case VooUserStatus.busy:
        return const Color(0xFFEF4444);
      case VooUserStatus.offline:
        return const Color(0xFF9CA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style ?? const VooMultiSwitcherStyle();

    final selectedColor = style.selectedColor ??
        theme.colorScheme.primary
            .withValues(alpha: VooNavigationTokens.opacitySelectedBackground);
    final hoverColor = style.hoverColor ??
        theme.colorScheme.onSurface
            .withValues(alpha: VooNavigationTokens.opacityHoverBackground);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: style.itemBorderRadius ??
              BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? selectedColor
                  : _isHovered
                      ? hoverColor
                      : Colors.transparent,
              borderRadius: style.itemBorderRadius ??
                  BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    VooAvatar(
                      imageUrl: widget.user.avatarUrl,
                      child: widget.user.avatarWidget,
                      name: widget.user.name,
                      backgroundColor: widget.user.avatarColor,
                      size: style.avatarSize,
                    ),
                    if (widget.user.status != null)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getStatusColor(widget.user.status!),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.user.name,
                        style: style.titleStyle ??
                            theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: widget.isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.user.email != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.user.email!,
                          style: style.subtitleStyle ??
                              theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.isSelected)
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Action tile for the multi-switcher modal (Settings, Logout, etc.).
class VooMultiSwitcherActionTile extends StatefulWidget {
  /// Icon for the action
  final IconData icon;

  /// Label for the action
  final String label;

  /// Callback when the action is tapped
  final VoidCallback onTap;

  /// Whether this action is destructive (e.g., logout)
  final bool isDestructive;

  /// Style configuration
  final VooMultiSwitcherStyle? style;

  const VooMultiSwitcherActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.style,
  });

  @override
  State<VooMultiSwitcherActionTile> createState() =>
      _VooMultiSwitcherActionTileState();
}

class _VooMultiSwitcherActionTileState
    extends State<VooMultiSwitcherActionTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style ?? const VooMultiSwitcherStyle();

    final hoverColor = style.hoverColor ??
        theme.colorScheme.onSurface
            .withValues(alpha: VooNavigationTokens.opacityHoverBackground);

    final effectiveColor = widget.isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: style.itemBorderRadius ??
              BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _isHovered ? hoverColor : Colors.transparent,
              borderRadius: style.itemBorderRadius ??
                  BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 20,
                  color: effectiveColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: effectiveColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Create button for adding new organizations or users.
class VooMultiSwitcherCreateButton extends StatefulWidget {
  /// Label for the button
  final String label;

  /// Icon for the button
  final IconData icon;

  /// Callback when the button is tapped
  final VoidCallback onTap;

  /// Style configuration
  final VooMultiSwitcherStyle? style;

  const VooMultiSwitcherCreateButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.style,
  });

  @override
  State<VooMultiSwitcherCreateButton> createState() =>
      _VooMultiSwitcherCreateButtonState();
}

class _VooMultiSwitcherCreateButtonState
    extends State<VooMultiSwitcherCreateButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.style ?? const VooMultiSwitcherStyle();

    final hoverColor = style.hoverColor ??
        theme.colorScheme.onSurface
            .withValues(alpha: VooNavigationTokens.opacityHoverBackground);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: style.itemBorderRadius ??
              BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _isHovered ? hoverColor : Colors.transparent,
              borderRadius: style.itemBorderRadius ??
                  BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
            ),
            child: Row(
              children: [
                Container(
                  width: style.avatarSize,
                  height: style.avatarSize,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(style.avatarSize / 2),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Current user info tile showing name, email, and status.
class VooMultiSwitcherUserInfoTile extends StatelessWidget {
  /// User's display name
  final String? userName;

  /// User's email address
  final String? userEmail;

  /// URL for the user's avatar
  final String? avatarUrl;

  /// Custom avatar widget
  final Widget? avatarWidget;

  /// User initials
  final String? initials;

  /// User's online status
  final VooUserStatus? status;

  /// Style configuration
  final VooMultiSwitcherStyle? style;

  const VooMultiSwitcherUserInfoTile({
    super.key,
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.avatarWidget,
    this.initials,
    this.status,
    this.style,
  });

  Color _getStatusColor(VooUserStatus status) {
    switch (status) {
      case VooUserStatus.online:
        return const Color(0xFF22C55E);
      case VooUserStatus.away:
        return const Color(0xFFF59E0B);
      case VooUserStatus.busy:
        return const Color(0xFFEF4444);
      case VooUserStatus.offline:
        return const Color(0xFF9CA3AF);
    }
  }

  String _getStatusLabel(VooUserStatus status) {
    switch (status) {
      case VooUserStatus.online:
        return 'Online';
      case VooUserStatus.away:
        return 'Away';
      case VooUserStatus.busy:
        return 'Busy';
      case VooUserStatus.offline:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? const VooMultiSwitcherStyle();

    return Padding(
      padding: effectiveStyle.itemPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Stack(
            children: [
              VooAvatar(
                imageUrl: avatarUrl,
                child: avatarWidget,
                name: userName,
                initials: initials,
                size: effectiveStyle.avatarSize,
              ),
              if (status != null)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getStatusColor(status!),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (userName != null)
                  Text(
                    userName!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (userEmail != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    userEmail!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (status != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStatusColor(status!),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getStatusLabel(status!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
