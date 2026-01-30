import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_modal.dart';

/// A multi-switcher (org/user) navigation item that matches the expandable nav bar design.
///
/// Displays stacked avatars in a dark circle (like other nav items), and opens
/// an overlay modal when tapped (like the action item).
class VooMultiSwitcherExpandableNavItem extends StatefulWidget {
  /// Configuration for the multi-switcher
  final VooMultiSwitcherConfig config;

  /// Whether haptic feedback is enabled
  final bool enableHapticFeedback;

  /// Custom color for accents
  final Color? selectedColor;

  const VooMultiSwitcherExpandableNavItem({
    super.key,
    required this.config,
    this.enableHapticFeedback = true,
    this.selectedColor,
  });

  @override
  State<VooMultiSwitcherExpandableNavItem> createState() =>
      _VooMultiSwitcherExpandableNavItemState();
}

class _VooMultiSwitcherExpandableNavItemState
    extends State<VooMultiSwitcherExpandableNavItem>
    with SingleTickerProviderStateMixin, ExpandableNavModalMixin {
  @override
  void initState() {
    super.initState();
    initModalAnimation();
  }

  @override
  void dispose() {
    disposeModalAnimation();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    if (isModalOpen) {
      closeModal();
    } else {
      openModal(_buildModalContent);
    }
  }

  Widget _buildModalContent(BuildContext context) {
    return _MultiSwitcherModalContent(
      config: widget.config,
      onClose: closeModal,
      selectedColor: widget.selectedColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = VooNavigationTokens.expandableNavSelectedCircleSize;
    final circleColor = context.expandableNavUnselectedCircle;
    final containerHeight = circleSize + 4;

    final status = widget.config.status;
    final statusColor = _getStatusColor(status, Theme.of(context));

    return GestureDetector(
      key: buttonKey,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Tooltip(
        message: widget.config.userName ?? 'Account',
        child: Container(
          height: containerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Center(
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Stacked avatars centered
                  Center(
                    child: _buildStackedAvatars(context, circleSize * 0.6),
                  ),
                  // Status indicator
                  if (status != null && status != VooUserStatus.offline)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: circleColor,
                            width: 2,
                          ),
                        ),
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

  Widget _buildStackedAvatars(BuildContext context, double size) {
    final org = widget.config.selectedOrganization;
    final userSize = size * 0.75;
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
              child: _buildOrgAvatar(context, org, orgSize * 0.7),
            ),
          // User avatar (foreground, bottom-right)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.expandableNavUnselectedCircle,
                  width: 1.5,
                ),
              ),
              child: _buildUserAvatar(context, userSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrgAvatar(BuildContext context, VooOrganization org, double size) {
    // Avatar URL
    if (org.avatarUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.network(
          org.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => _buildOrgFallback(context, org, size),
        ),
      );
    }

    return _buildOrgFallback(context, org, size);
  }

  Widget _buildOrgFallback(BuildContext context, VooOrganization org, double size) {
    final color = org.avatarColor ?? Colors.white.withValues(alpha: 0.2);
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

    // Avatar URL
    if (config.avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          config.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => _buildUserFallback(context, size),
        ),
      );
    }

    return _buildUserFallback(context, size);
  }

  Widget _buildUserFallback(BuildContext context, double size) {
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
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person_outline_rounded,
          size: size * 0.6,
          color: Colors.white70,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.selectedColor ?? Colors.white.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(VooUserStatus? status, ThemeData theme) {
    switch (status) {
      case VooUserStatus.online:
        return Colors.green;
      case VooUserStatus.away:
        return Colors.orange;
      case VooUserStatus.busy:
        return Colors.red;
      case VooUserStatus.offline:
      case null:
        return theme.colorScheme.outline;
    }
  }

  Color _getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}

/// Modal content for multi-switcher
class _MultiSwitcherModalContent extends StatelessWidget {
  final VooMultiSwitcherConfig config;
  final VoidCallback onClose;
  final Color? selectedColor;

  const _MultiSwitcherModalContent({
    required this.config,
    required this.onClose,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Account',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white54,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User info
                  if (config.userName != null || config.userEmail != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildUserAvatarLarge(context),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (config.userName != null)
                                  Text(
                                    config.userName!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (config.userEmail != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    config.userEmail!,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Organizations
                  if (config.organizations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
              'Organizations',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...config.organizations.map((org) => _buildOrgItem(context, org)),
          ],
                ],
              ),
            ),
          ),

          // Actions (fixed at bottom)
          const SizedBox(height: 16),
          Row(
            children: [
              if (config.onSettingsTap != null)
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {
                      onClose();
                      config.onSettingsTap?.call();
                    },
                  ),
                ),
              if (config.onSettingsTap != null && config.onLogout != null)
                const SizedBox(width: 12),
              if (config.onLogout != null)
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    onTap: () {
                      onClose();
                      config.onLogout?.call();
                    },
                    isDestructive: true,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatarLarge(BuildContext context) {
    const size = 44.0;

    if (config.avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          config.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => _buildUserAvatarFallback(size),
        ),
      );
    }

    return _buildUserAvatarFallback(size);
  }

  Widget _buildUserAvatarFallback(double size) {
    String initials = config.initials ?? '';
    if (initials.isEmpty && config.userName != null) {
      final parts = config.userName!.split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
        initials = parts[0].substring(0, parts[0].length > 1 ? 2 : 1).toUpperCase();
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selectedColor ?? Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: initials.isEmpty
            ? Icon(
                Icons.person_outline_rounded,
                size: size * 0.5,
                color: Colors.white70,
              )
            : Text(
                initials,
                style: TextStyle(
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildOrgItem(BuildContext context, VooOrganization org) {
    final isSelected = config.selectedOrganization?.id == org.id;

    return GestureDetector(
      onTap: () {
        config.onOrganizationChanged?.call(org);
        onClose();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (org.avatarColor ?? selectedColor ?? Colors.white)
                  .withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: (org.avatarColor ?? selectedColor ?? Colors.white)
                      .withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            _buildOrgAvatar(org, 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                org.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: org.avatarColor ?? selectedColor ?? Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrgAvatar(VooOrganization org, double size) {
    if (org.avatarUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.network(
          org.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => _buildOrgAvatarFallback(org, size),
        ),
      );
    }

    return _buildOrgAvatarFallback(org, size);
  }

  Widget _buildOrgAvatarFallback(VooOrganization org, double size) {
    final color = org.avatarColor ?? Colors.white.withValues(alpha: 0.2);
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
            color: color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red.shade300 : Colors.white70;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
