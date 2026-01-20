import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_navigation_core/src/presentation/molecules/multi_switcher_bottom_sheet.dart';

/// A navigation item widget that displays the multi-switcher (org/user).
///
/// This widget shows stacked avatars representing the organization and user,
/// and opens a bottom sheet modal on tap or long-press. Designed to blend
/// seamlessly with other navigation items in the rail and bottom navigation bar.
class VooMultiSwitcherNavItem extends StatefulWidget {
  /// Configuration for the multi-switcher
  final VooMultiSwitcherConfig config;

  /// Whether the item is currently selected (active)
  final bool isSelected;

  /// Whether to show in compact mode (icon only, no label)
  final bool isCompact;

  /// Size of the avatar (defaults to 24)
  final double avatarSize;

  /// Whether haptic feedback is enabled
  final bool enableHapticFeedback;

  /// Custom callback when tapped (overrides default bottom sheet)
  final VoidCallback? onTap;

  /// Custom callback when long-pressed (overrides default bottom sheet)
  final VoidCallback? onLongPress;

  /// Whether to use floating nav style (icon only, no backgrounds)
  final bool useFloatingStyle;

  const VooMultiSwitcherNavItem({
    super.key,
    required this.config,
    this.isSelected = false,
    this.isCompact = true,
    this.avatarSize = 24,
    this.enableHapticFeedback = true,
    this.onTap,
    this.onLongPress,
    this.useFloatingStyle = true,
  });

  /// The special ID used to identify multi-switcher nav items
  static const String navItemId = '_multi_switcher_nav';

  @override
  State<VooMultiSwitcherNavItem> createState() =>
      _VooMultiSwitcherNavItemState();
}

class _VooMultiSwitcherNavItemState extends State<VooMultiSwitcherNavItem> {
  bool _isHovered = false;

  void _showMultiSwitcher() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    showMultiSwitcherBottomSheet(
      context: context,
      config: widget.config,
    );
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      _showMultiSwitcher();
    }
  }

  void _handleLongPress() {
    if (widget.onLongPress != null) {
      widget.onLongPress!();
    } else {
      _showMultiSwitcher();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = widget.config.navItemLabel ??
        widget.config.userName ??
        'Account';

    if (widget.isCompact) {
      return _buildCompactItem(context, theme, label);
    }

    return _buildExpandedItem(context, theme, label);
  }

  Widget _buildCompactItem(
    BuildContext context,
    ThemeData theme,
    String label,
  ) {
    // Use floating style for bottom nav - clean icon-only design
    if (widget.useFloatingStyle) {
      return _buildFloatingStyleItem(context, theme, label);
    }

    // Rail style with subtle background on hover
    // Size the container based on avatarSize for proper scaling
    final containerSize = widget.avatarSize + 16; // avatar + padding

    return Tooltip(
      message: label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: containerSize,
            height: containerSize,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: widget.isSelected || _isHovered
                      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildStackedAvatars(context, widget.avatarSize),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a floating nav style item - stacked avatars with status indicator
  Widget _buildFloatingStyleItem(
    BuildContext context,
    ThemeData theme,
    String label,
  ) {
    final hasUser = widget.config.userName != null ||
        widget.config.avatarUrl != null ||
        widget.config.avatarWidget != null;
    final status = widget.config.status;

    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: _handleTap,
        onLongPress: _handleLongPress,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Stacked avatars or account icon
              if (hasUser)
                _buildStackedAvatars(context, VooNavigationTokens.iconSizeCompact)
              else
                Icon(
                  Icons.account_circle_outlined,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: VooNavigationTokens.opacityDisabled),
                  size: VooNavigationTokens.iconSizeCompact,
                ),
              // Status indicator
              if (status != null && status != VooUserStatus.offline)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getStatusColor(status, theme),
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
        ),
      ),
    );
  }

  Widget _buildExpandedItem(
    BuildContext context,
    ThemeData theme,
    String label,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          borderRadius: BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : _isHovered
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                      : Colors.transparent,
              borderRadius:
                  BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
            ),
            child: Row(
              children: [
                _buildStackedAvatars(context, widget.avatarSize),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.config.userName ?? 'Account',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: widget.isSelected
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.config.selectedOrganization != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.config.selectedOrganization!.name,
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
                Icon(
                  Icons.unfold_more_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds stacked avatars showing organization and user
  Widget _buildStackedAvatars(BuildContext context, double size) {
    final theme = Theme.of(context);
    final org = widget.config.selectedOrganization;
    final userSize = size * 0.7;
    final orgSize = size;

    return SizedBox(
      width: size + 4,
      height: size + 4,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Organization avatar (background, larger)
          if (org != null)
            Positioned(
              top: 0,
              left: 0,
              child: _buildOrgAvatar(context, org, orgSize * 0.8),
            ),
          // User avatar (foreground, bottom-right)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.surface,
                  width: 2,
                ),
              ),
              child: _buildUserAvatar(context, userSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrgAvatar(BuildContext context, dynamic org, double size) {
    // Custom avatar widget
    if (org.avatarWidget != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: SizedBox(
          width: size,
          height: size,
          child: org.avatarWidget,
        ),
      );
    }

    // Avatar URL
    if (org.avatarUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.network(
          org.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildOrgFallback(context, org, size),
        ),
      );
    }

    return _buildOrgFallback(context, org, size);
  }

  Widget _buildOrgFallback(BuildContext context, dynamic org, double size) {
    final theme = Theme.of(context);
    final color = org.avatarColor ?? theme.colorScheme.primaryContainer;
    final initials = org.name.isNotEmpty
        ? org.name.substring(0, org.name.length > 1 ? 2 : 1).toUpperCase()
        : 'O';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: _getContrastColor(color),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context, double size) {
    final config = widget.config;

    // Custom avatar widget
    if (config.avatarWidget != null) {
      return ClipOval(
        child: SizedBox(
          width: size,
          height: size,
          child: config.avatarWidget,
        ),
      );
    }

    // Avatar URL
    if (config.avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          config.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildUserFallback(context, size),
        ),
      );
    }

    return _buildUserFallback(context, size);
  }

  Widget _buildUserFallback(BuildContext context, double size) {
    final theme = Theme.of(context);
    final config = widget.config;

    // Get initials
    String initials = config.initials ?? '';
    if (initials.isEmpty && config.userName != null) {
      final parts = config.userName!.split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
        initials = parts[0].substring(0, parts[0].length > 1 ? 2 : 1).toUpperCase();
      }
    }

    if (initials.isEmpty) {
      // Show generic icon
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person_outline_rounded,
          size: size * 0.6,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(VooUserStatus status, ThemeData theme) {
    switch (status) {
      case VooUserStatus.online:
        return Colors.green;
      case VooUserStatus.away:
        return Colors.orange;
      case VooUserStatus.busy:
        return Colors.red;
      case VooUserStatus.offline:
        return theme.colorScheme.outline;
    }
  }

  Color _getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}
