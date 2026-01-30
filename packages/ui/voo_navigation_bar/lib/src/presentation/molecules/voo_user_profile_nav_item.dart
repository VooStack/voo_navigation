import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_modal.dart';

/// A user profile navigation item that matches the expandable nav bar design.
///
/// Displays the user's avatar (image or initials) in a circle, and opens
/// an overlay modal when tapped (if modalBuilder is provided) or calls onTap.
class VooUserProfileNavItem extends StatefulWidget {
  /// Configuration for the user profile
  final VooUserProfileConfig config;

  /// Whether haptic feedback is enabled
  final bool enableHapticFeedback;

  /// Custom color for the avatar background when showing initials
  final Color? avatarColor;

  /// Navigation item ID for this profile item
  static const String navItemId = '_user_profile_nav';

  const VooUserProfileNavItem({
    super.key,
    required this.config,
    this.enableHapticFeedback = true,
    this.avatarColor,
  });

  @override
  State<VooUserProfileNavItem> createState() => _VooUserProfileNavItemState();
}

class _VooUserProfileNavItemState extends State<VooUserProfileNavItem>
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

    // If modalBuilder is provided, show modal
    if (widget.config.modalBuilder != null) {
      if (isModalOpen) {
        closeModal();
      } else {
        openModal(_buildModalContent);
      }
    } else {
      // Otherwise call onTap
      widget.config.onTap?.call();
    }
  }

  Widget _buildModalContent(BuildContext context) {
    return widget.config.modalBuilder!(
      context,
      VooUserProfileModalData(
        userName: widget.config.userName,
        userEmail: widget.config.userEmail,
        avatarUrl: widget.config.avatarUrl,
        avatarWidget: widget.config.avatarWidget,
        initials: widget.config.effectiveInitials,
        status: widget.config.status,
        onClose: closeModal,
        onSettingsTap: widget.config.onSettingsTap,
        onLogout: widget.config.onLogout,
        menuItems: widget.config.menuItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final circleSize = VooNavigationTokens.expandableNavSelectedCircleSize;
    final containerHeight = circleSize + 4;
    final theme = Theme.of(context);

    return GestureDetector(
      key: buttonKey,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Tooltip(
        message: widget.config.effectiveNavItemLabel,
        child: Container(
          height: containerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Center(
            child: _buildAvatar(context, circleSize, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double size, ThemeData theme) {
    // If custom avatar widget provided, use it
    if (widget.config.avatarWidget != null) {
      return SizedBox(
        width: size,
        height: size,
        child: ClipOval(child: widget.config.avatarWidget),
      );
    }

    // If avatar URL provided, show image
    if (widget.config.avatarUrl != null && widget.config.avatarUrl!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _getImageProvider(widget.config.avatarUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Otherwise show initials
    final initials = widget.config.effectiveInitials ?? '?';
    final bgColor = widget.avatarColor ?? theme.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return NetworkImage(url);
    }
    return AssetImage(url);
  }
}
