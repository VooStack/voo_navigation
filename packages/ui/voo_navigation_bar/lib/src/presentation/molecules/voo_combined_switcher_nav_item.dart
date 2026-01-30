import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_modal.dart';

/// A combined switcher that merges context switching and org/profile switching
/// into a single navigation item.
///
/// Displays a triple-stacked avatar (context + org + user) and opens a unified
/// modal for switching all three.
class VooCombinedSwitcherNavItem extends StatefulWidget {
  /// Configuration for the context switcher
  final VooContextSwitcherConfig contextConfig;

  /// Configuration for the multi-switcher (org/profile)
  final VooMultiSwitcherConfig multiConfig;

  /// Whether haptic feedback is enabled
  final bool enableHapticFeedback;

  /// Custom color for accents
  final Color? selectedColor;

  const VooCombinedSwitcherNavItem({
    super.key,
    required this.contextConfig,
    required this.multiConfig,
    this.enableHapticFeedback = true,
    this.selectedColor,
  });

  @override
  State<VooCombinedSwitcherNavItem> createState() =>
      _VooCombinedSwitcherNavItemState();
}

class _VooCombinedSwitcherNavItemState extends State<VooCombinedSwitcherNavItem>
    with TickerProviderStateMixin, ExpandableNavModalMixin {
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
    return _CombinedSwitcherModalContent(
      contextConfig: widget.contextConfig,
      multiConfig: widget.multiConfig,
      onClose: closeModal,
      selectedColor: widget.selectedColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = VooNavigationTokens.expandableNavSelectedCircleSize;
    final circleColor = context.expandableNavUnselectedCircle;
    final containerHeight = circleSize + 4;

    final status = widget.multiConfig.status;
    final statusColor = _getStatusColor(status, Theme.of(context));

    return GestureDetector(
      key: buttonKey,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Tooltip(
        message: 'Account & Context',
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
                  // Triple-stacked avatars centered
                  Center(
                    child: _buildTripleStackedAvatars(context, circleSize * 0.55),
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

  /// Build triple-stacked avatars in triangle formation
  Widget _buildTripleStackedAvatars(BuildContext context, double size) {
    final contextItem = widget.contextConfig.selectedItem;
    final org = widget.multiConfig.selectedOrganization;
    final avatarSize = size * 0.55;

    // Triangle layout with clear separation
    final totalWidth = size * 1.15;
    final totalHeight = size;

    // Calculate centroid offset to center the triangle's centroid within the bounding box
    // For a triangle with 2 points at top and 1 at bottom:
    // - Top avatar centers at Y = avatarSize/2
    // - Bottom avatar center at Y = totalHeight - avatarSize/2
    // Centroid Y = (avatarSize/2 + avatarSize/2 + (totalHeight - avatarSize/2)) / 3
    //            = (avatarSize/2 + totalHeight) / 3
    // To center: we need centroid at totalHeight/2
    // Offset = totalHeight/2 - centroidY = (totalHeight - avatarSize) / 6
    final centroidOffsetY = (totalHeight - avatarSize) / 6;

    return Transform.translate(
      offset: Offset(0, centroidOffsetY), // Shift down to center centroid
      child: SizedBox(
        width: totalWidth,
        height: totalHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Context indicator (top-left of triangle)
            Positioned(
              top: 0,
              left: 0,
              child: _buildContextAvatar(context, contextItem, avatarSize),
            ),
            // Organization avatar (top-right of triangle)
            if (org != null)
              Positioned(
                top: 0,
                right: 0,
                child: _buildOrgAvatar(context, org, avatarSize),
              ),
            // User avatar (bottom-center of triangle)
            Positioned(
              bottom: 0,
              left: (totalWidth - avatarSize) / 2,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.expandableNavUnselectedCircle,
                    width: 1.5,
                  ),
                ),
                child: _buildUserAvatar(context, avatarSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextAvatar(BuildContext context, VooContextItem? item, double size) {
    if (item == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(size / 4),
        ),
        child: Icon(
          Icons.grid_view_rounded,
          size: size * 0.55,
          color: Colors.white54,
        ),
      );
    }

    final color = item.color ?? Colors.white.withValues(alpha: 0.2);

    if (item.icon != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size / 4),
        ),
        child: Icon(
          item.icon,
          size: size * 0.55,
          color: _getContrastColor(color),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Text(
          item.initials,
          style: TextStyle(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w600,
            color: _getContrastColor(color),
          ),
        ),
      ),
    );
  }

  Widget _buildOrgAvatar(BuildContext context, VooOrganization org, double size) {
    if (org.avatarUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.network(
          org.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => _buildOrgFallback(org, size),
        ),
      );
    }

    return _buildOrgFallback(org, size);
  }

  Widget _buildOrgFallback(VooOrganization org, double size) {
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
            fontSize: size * 0.35,
            fontWeight: FontWeight.w600,
            color: _getContrastColor(color),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context, double size) {
    final config = widget.multiConfig;

    if (config.avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          config.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => _buildUserFallback(size),
        ),
      );
    }

    return _buildUserFallback(size);
  }

  Widget _buildUserFallback(double size) {
    final config = widget.multiConfig;

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
            fontSize: size * 0.35,
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

/// Combined modal content for context + org/profile switching
class _CombinedSwitcherModalContent extends StatefulWidget {
  final VooContextSwitcherConfig contextConfig;
  final VooMultiSwitcherConfig multiConfig;
  final VoidCallback onClose;
  final Color? selectedColor;

  const _CombinedSwitcherModalContent({
    required this.contextConfig,
    required this.multiConfig,
    required this.onClose,
    this.selectedColor,
  });

  @override
  State<_CombinedSwitcherModalContent> createState() =>
      _CombinedSwitcherModalContentState();
}

class _CombinedSwitcherModalContentState
    extends State<_CombinedSwitcherModalContent> {
  String _contextSearchQuery = '';

  List<VooContextItem> get _filteredContextItems {
    if (_contextSearchQuery.isEmpty) return widget.contextConfig.items;
    final query = _contextSearchQuery.toLowerCase();
    return widget.contextConfig.items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

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
                'Account & Context',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onClose,
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
                  if (widget.multiConfig.userName != null ||
                      widget.multiConfig.userEmail != null)
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
                                if (widget.multiConfig.userName != null)
                                  Text(
                                    widget.multiConfig.userName!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (widget.multiConfig.userEmail != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.multiConfig.userEmail!,
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

                  // Organizations section
                  if (widget.multiConfig.organizations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionHeader('Organization'),
                    const SizedBox(height: 8),
                    ...widget.multiConfig.organizations
                        .map((org) => _buildOrgItem(context, org)),
                  ],

                  // Context section
                  if (widget.contextConfig.items.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionHeader(
                        widget.contextConfig.placeholder ?? 'Context'),
                    if (widget.contextConfig.showSearch) ...[
                      const SizedBox(height: 8),
                      TextField(
                        onChanged: (value) =>
                            setState(() => _contextSearchQuery = value),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle:
                              TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          isDense: true,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    ..._filteredContextItems
                        .map((item) => _buildContextItem(context, item)),

                    // Create context button
                    if (widget.contextConfig.onCreateContext != null) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          widget.onClose();
                          widget.contextConfig.onCreateContext?.call();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add,
                                  color: Colors.white54, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                widget.contextConfig.createContextLabel ??
                                    'Create New',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

          // Actions (fixed at bottom)
          const SizedBox(height: 16),
          Row(
            children: [
              if (widget.multiConfig.onSettingsTap != null)
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {
                      widget.onClose();
                      widget.multiConfig.onSettingsTap?.call();
                    },
                  ),
                ),
              if (widget.multiConfig.onSettingsTap != null &&
                  widget.multiConfig.onLogout != null)
                const SizedBox(width: 12),
              if (widget.multiConfig.onLogout != null)
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.logout_rounded,
                    label: 'Sign Out',
                    onTap: () {
                      widget.onClose();
                      widget.multiConfig.onLogout?.call();
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.6),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildUserAvatarLarge(BuildContext context) {
    const size = 40.0;

    if (widget.multiConfig.avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          widget.multiConfig.avatarUrl!,
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
    String initials = widget.multiConfig.initials ?? '';
    if (initials.isEmpty && widget.multiConfig.userName != null) {
      final parts = widget.multiConfig.userName!.split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
        initials =
            parts[0].substring(0, parts[0].length > 1 ? 2 : 1).toUpperCase();
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.selectedColor ?? Colors.white.withValues(alpha: 0.2),
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
    final isSelected = widget.multiConfig.selectedOrganization?.id == org.id;

    return GestureDetector(
      onTap: () {
        widget.multiConfig.onOrganizationChanged?.call(org);
        widget.onClose();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (org.avatarColor ?? widget.selectedColor ?? Colors.white)
                  .withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color:
                      (org.avatarColor ?? widget.selectedColor ?? Colors.white)
                          .withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            _buildOrgAvatar(org, 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                org.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: org.avatarColor ?? widget.selectedColor ?? Colors.white,
                size: 18,
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

  Widget _buildContextItem(BuildContext context, VooContextItem item) {
    final isSelected = widget.contextConfig.selectedItem?.id == item.id;

    return GestureDetector(
      onTap: () {
        widget.contextConfig.onContextChanged?.call(item);
        widget.onClose();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (item.color ?? Colors.white).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color: (item.color ?? Colors.white).withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            // Color indicator or icon
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: item.color ?? Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(7),
              ),
              child: item.icon != null
                  ? Icon(
                      item.icon,
                      color: item.color != null
                          ? (item.color!.computeLuminance() > 0.5
                              ? Colors.black87
                              : Colors.white)
                          : Colors.white,
                      size: 16,
                    )
                  : Center(
                      child: Text(
                        item.initials,
                        style: TextStyle(
                          color: item.color != null
                              ? (item.color!.computeLuminance() > 0.5
                                  ? Colors.black87
                                  : Colors.white)
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: item.color ?? Colors.white,
                size: 18,
              ),
          ],
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
