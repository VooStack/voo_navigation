import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Default header widget for the navigation drawer.
///
/// Shows an icon with title. Use [VooNavigationConfig.drawerHeader] to provide
/// a custom header widget instead.
class VooDrawerDefaultHeader extends StatelessWidget {
  /// Title text displayed in the header
  final String title;

  /// Subtitle text displayed below the title
  final String? subtitle;

  /// Icon to display
  final IconData icon;

  const VooDrawerDefaultHeader({super.key, this.title = 'Navigation', this.subtitle, this.icon = Icons.dashboard});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;
    final size = context.vooSize;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.sm, spacing.lg, spacing.sm, spacing.md),
      child: Row(
        children: [
          Container(
            width: size.avatarMedium,
            height: size.avatarMedium,
            decoration: BoxDecoration(color: theme.colorScheme.onSurface.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(radius.md)),
            child: Icon(icon, color: theme.colorScheme.onSurface, size: size.iconMedium),
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600),
                ),
                if (subtitle != null) Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
