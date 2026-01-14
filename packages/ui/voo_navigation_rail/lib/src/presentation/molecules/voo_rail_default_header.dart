import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Default header widget for navigation rail.
///
/// Shows an icon with optional title in a row layout.
/// Use [VooNavigationConfig.drawerHeader] to provide a custom header widget,
/// or [VooNavigationConfig.headerConfig] for simpler customization.
class VooRailDefaultHeader extends StatelessWidget {
  /// Title text displayed next to the icon
  final String? title;

  /// Icon to display
  final IconData icon;

  /// Whether to show the title (false for compact mode)
  final bool showTitle;

  /// Header configuration (takes precedence over individual properties)
  final VooHeaderConfig? config;

  /// Custom logo widget (takes precedence over icon)
  final Widget? logo;

  /// Background color for the logo container
  final Color? logoBackgroundColor;

  const VooRailDefaultHeader({
    super.key,
    this.title = 'Navigation',
    this.icon = Icons.dashboard,
    this.showTitle = false,
    this.config,
    this.logo,
    this.logoBackgroundColor,
  });

  /// Creates a header from a VooHeaderConfig
  factory VooRailDefaultHeader.fromConfig({
    Key? key,
    required VooHeaderConfig config,
    bool showTitle = true,
  }) {
    return VooRailDefaultHeader(
      key: key,
      config: config,
      showTitle: showTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;
    final size = context.vooSize;

    // Use config values if provided, otherwise use direct parameters
    final effectiveTitle = config?.title ?? title;
    final effectiveIcon = config?.logoIcon ?? icon;
    final effectiveLogo = config?.logo ?? logo;
    final effectiveShowTitle = config?.showTitle ?? showTitle;
    final effectiveLogoBackground = config?.logoBackgroundColor ??
        logoBackgroundColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.12);
    // Top padding calculated to align logo center with app bar title center
    // App bar title centered at ~32dp, logo is 40dp tall, so logo top = 32 - 20 = 12dp
    final topPadding = spacing.sm + spacing.xs; // 12dp
    final effectivePadding = config?.padding ??
        EdgeInsets.fromLTRB(spacing.md, topPadding, spacing.md, spacing.md);

    // Build the logo widget
    Widget logoWidget;
    if (effectiveLogo != null) {
      logoWidget = SizedBox(
        width: size.avatarMedium,
        height: size.avatarMedium,
        child: effectiveLogo,
      );
    } else {
      logoWidget = Container(
        width: size.avatarMedium,
        height: size.avatarMedium,
        decoration: BoxDecoration(
          color: effectiveLogoBackground,
          borderRadius: BorderRadius.circular(radius.md),
        ),
        child: Icon(
          effectiveIcon,
          color: theme.colorScheme.onSurface,
          size: size.iconMedium,
        ),
      );
    }

    final effectiveTagline = config?.tagline;

    return GestureDetector(
      onTap: config?.onTap,
      child: Padding(
        padding: effectivePadding,
        child: Row(
          children: [
            logoWidget,
            if (effectiveShowTitle && effectiveTitle != null) ...[
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      effectiveTitle,
                      style: config?.titleStyle ?? theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (effectiveTagline != null)
                      Text(
                        effectiveTagline,
                        style: config?.taglineStyle ?? theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
