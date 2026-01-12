import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_profile_menu_item.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';
import 'package:voo_navigation_core/src/presentation/molecules/compact_profile.dart';
import 'package:voo_navigation_core/src/presentation/molecules/expanded_profile.dart';
import 'package:voo_navigation_core/src/presentation/utils/voo_collapse_state.dart';

/// Modern user profile footer for navigation drawer/rail
/// Displays user avatar, name, email with dropdown actions
class VooUserProfileFooter extends StatefulWidget {
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

  /// Whether the profile is in compact mode (rail collapsed)
  ///
  /// When null, auto-detects from [VooCollapseState] in widget tree.
  /// Set explicitly to override auto-detection.
  final bool? compact;

  /// Callback when profile is tapped
  final VoidCallback? onTap;

  /// Callback when settings icon is tapped
  final VoidCallback? onSettingsTap;

  /// Callback when logout is requested
  final VoidCallback? onLogout;

  /// Custom dropdown menu items
  final List<VooProfileMenuItem>? menuItems;

  /// Status indicator (online, away, busy, offline)
  final VooUserStatus? status;

  /// Whether to show the chevron/dropdown indicator
  final bool showDropdownIndicator;

  /// Whether to show the top border divider
  final bool showTopBorder;

  const VooUserProfileFooter({
    super.key,
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.avatarWidget,
    this.initials,
    this.compact,
    this.onTap,
    this.onSettingsTap,
    this.onLogout,
    this.menuItems,
    this.status,
    this.showDropdownIndicator = true,
    this.showTopBorder = true,
  });

  @override
  State<VooUserProfileFooter> createState() => _VooUserProfileFooterState();
}

class _VooUserProfileFooterState extends State<VooUserProfileFooter> {
  @override
  Widget build(BuildContext context) {
    // Auto-detect compact mode from VooCollapseState if not explicitly set
    final effectiveCompact = widget.compact ?? VooCollapseState.isCollapsedOf(context);

    if (effectiveCompact) {
      return VooCompactProfile(
        userName: widget.userName,
        avatarWidget: widget.avatarWidget,
        avatarUrl: widget.avatarUrl,
        initials: widget.initials,
        status: widget.status,
        onTap: widget.onTap,
      );
    }

    return VooExpandedProfile(
      userName: widget.userName,
      userEmail: widget.userEmail,
      avatarWidget: widget.avatarWidget,
      avatarUrl: widget.avatarUrl,
      initials: widget.initials,
      status: widget.status,
      showDropdownIndicator: widget.showDropdownIndicator,
      showTopBorder: widget.showTopBorder,
      onTap: widget.onTap,
      onSettingsTap: widget.onSettingsTap,
      onLogout: widget.onLogout,
      menuItems: widget.menuItems,
    );
  }
}
