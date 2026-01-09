import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Default header widget for navigation rail.
///
/// Shows an icon with optional title. Use [VooNavigationConfig.railHeader]
/// to provide a custom header widget instead.
class VooRailDefaultHeader extends StatelessWidget {
  /// Title text displayed below the icon
  final String? title;

  /// Icon to display
  final IconData icon;

  /// Whether to show the title (false for compact mode)
  final bool showTitle;

  const VooRailDefaultHeader({
    super.key,
    this.title = 'Navigation',
    this.icon = Icons.dashboard,
    this.showTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;
    final size = context.vooSize;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.md, spacing.lg, spacing.md, spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.avatarSmall,
            height: size.avatarSmall,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(radius.md),
            ),
            child: Icon(
              icon,
              color: theme.colorScheme.primary,
              size: size.iconSmall,
            ),
          ),
          if (showTitle && title != null) ...[
            SizedBox(height: spacing.sm),
            Text(
              title!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
