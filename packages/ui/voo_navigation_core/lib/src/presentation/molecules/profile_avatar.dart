import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';
import 'package:voo_navigation_core/src/presentation/molecules/initials_avatar.dart';
import 'package:voo_navigation_core/src/presentation/molecules/status_indicator.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Profile avatar with optional status indicator
class VooProfileAvatar extends StatelessWidget {
  /// Custom avatar widget
  final Widget? avatarWidget;

  /// User's avatar image URL
  final String? avatarUrl;

  /// User's display name
  final String? userName;

  /// Initials to show if no avatar is provided
  final String? initials;

  /// User status indicator
  final VooUserStatus? status;

  /// Size of the avatar
  final double size;

  const VooProfileAvatar({
    super.key,
    this.avatarWidget,
    this.avatarUrl,
    this.userName,
    this.initials,
    this.status,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final radius = context.vooRadius;

    Widget avatarContent;

    if (avatarWidget != null) {
      avatarContent = avatarWidget!;
    } else if (avatarUrl != null) {
      avatarContent = ClipRRect(
        borderRadius: BorderRadius.circular(radius.md),
        child: Image.network(
          avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => VooInitialsAvatar(
            userName: userName,
            initials: initials,
            size: size,
          ),
        ),
      );
    } else {
      avatarContent = VooInitialsAvatar(
        userName: userName,
        initials: initials,
        size: size,
      );
    }

    return Stack(
      children: [
        avatarContent,
        if (status != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: VooStatusIndicator(status: status!),
          ),
      ],
    );
  }
}
