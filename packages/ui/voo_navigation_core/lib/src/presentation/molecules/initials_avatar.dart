import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Avatar showing user initials
class VooInitialsAvatar extends StatelessWidget {
  /// User's display name
  final String? userName;

  /// Explicit initials to show
  final String? initials;

  /// Size of the avatar
  final double size;

  const VooInitialsAvatar({
    super.key,
    this.userName,
    this.initials,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = context.vooRadius;
    final displayInitials = initials ??
        (userName?.isNotEmpty == true
            ? userName!
                .split(' ')
                .take(2)
                .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
                .join()
            : '?');

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius.md),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          displayInitials,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
