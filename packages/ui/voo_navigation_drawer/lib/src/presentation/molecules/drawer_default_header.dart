import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Default header widget for the navigation drawer.
///
/// Shows an icon with title. Use [VooNavigationConfig.drawerHeader] to provide
/// a custom header widget instead.
///
/// The header is designed to align with the app bar height (kToolbarHeight = 56dp)
/// for visual consistency when the drawer is placed next to the main content.
class VooDrawerDefaultHeader extends StatelessWidget {
  /// Title text displayed in the header
  final String title;

  /// Tagline text displayed next to the title (shown below title)
  final String? tagline;

  /// Icon to display
  final IconData icon;

  /// Optional trailing widget (e.g., collapse button)
  final Widget? trailing;

  /// Custom logo widget (takes precedence over icon)
  final Widget? logo;

  /// Background color for the logo container
  final Color? logoBackgroundColor;

  /// Height of the header. Defaults to kToolbarHeight (56dp) to align with app bar.
  final double? height;

  const VooDrawerDefaultHeader({
    super.key,
    this.title = 'Navigation',
    this.tagline,
    this.icon = Icons.dashboard,
    this.trailing,
    this.logo,
    this.logoBackgroundColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;

    // Use neutral gray for icon background instead of tinted surface
    final iconBgColor = logoBackgroundColor ??
        (theme.brightness == Brightness.light
            ? const Color(0xFFF0F0F0)
            : theme.colorScheme.onSurface.withValues(alpha: 0.12));

    // Use 40dp logo for visual balance in kToolbarHeight
    const double logoSize = 40;
    const double iconSize = 22;

    // Build the logo widget
    Widget logoWidget;
    if (logo != null) {
      logoWidget = SizedBox(
        width: logoSize,
        height: logoSize,
        child: logo,
      );
    } else {
      logoWidget = Container(
        width: logoSize,
        height: logoSize,
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(radius.sm),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface, size: iconSize),
      );
    }

    // Header height matches VooAdaptiveAppBar for alignment
    // VooAdaptiveAppBar uses toolbarHeight: kToolbarHeight + spacing.sm
    final effectiveHeight = height ?? (kToolbarHeight + spacing.sm);

    return Container(
      height: effectiveHeight,
      padding: EdgeInsets.symmetric(horizontal: spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          logoWidget,
          SizedBox(width: spacing.sm),
          Expanded(
            child: tagline != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        tagline!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  )
                : Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
