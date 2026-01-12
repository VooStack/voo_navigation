import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';
import 'package:voo_navigation_core/src/presentation/molecules/profile_avatar.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Compact profile display for collapsed navigation
class VooCompactProfile extends StatefulWidget {
  /// User's display name
  final String? userName;

  /// Custom avatar widget
  final Widget? avatarWidget;

  /// User's avatar image URL
  final String? avatarUrl;

  /// Initials to show if no avatar is provided
  final String? initials;

  /// User status indicator
  final VooUserStatus? status;

  /// Callback when tapped
  final VoidCallback? onTap;

  const VooCompactProfile({
    super.key,
    this.userName,
    this.avatarWidget,
    this.avatarUrl,
    this.initials,
    this.status,
    this.onTap,
  });

  @override
  State<VooCompactProfile> createState() => _VooCompactProfileState();
}

class _VooCompactProfileState extends State<VooCompactProfile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    return Padding(
      padding: EdgeInsets.all(spacing.sm),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Tooltip(
            message: widget.userName ?? 'Profile',
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(spacing.xs),
              decoration: BoxDecoration(
                color: _isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(radius.md),
              ),
              child: VooProfileAvatar(
                avatarWidget: widget.avatarWidget,
                avatarUrl: widget.avatarUrl,
                userName: widget.userName,
                initials: widget.initials,
                status: widget.status,
                size: 36,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
