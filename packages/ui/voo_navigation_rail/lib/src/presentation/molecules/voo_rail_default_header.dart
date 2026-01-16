import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Default header widget for navigation rail.
///
/// Shows an icon with optional title in a row layout.
/// Use [VooNavigationConfig.drawerHeader] to provide a custom header widget,
/// or [VooNavigationConfig.headerConfig] for simpler customization.
///
/// The header is designed to align with the app bar height (kToolbarHeight = 56dp)
/// for visual consistency when the rail is placed next to the main content.
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

  /// Height of the header. Defaults to kToolbarHeight (56dp) to align with app bar.
  final double? height;

  const VooRailDefaultHeader({
    super.key,
    this.title = 'Navigation',
    this.icon = Icons.dashboard,
    this.showTitle = false,
    this.config,
    this.logo,
    this.logoBackgroundColor,
    this.height,
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

    // Use config values if provided, otherwise use direct parameters
    final effectiveTitle = config?.title ?? title;
    final effectiveIcon = config?.logoIcon ?? icon;
    final effectiveLogo = config?.logo ?? logo;
    final effectiveShowTitle = config?.showTitle ?? showTitle;
    final effectiveLogoBackground = config?.logoBackgroundColor ??
        logoBackgroundColor ??
        (theme.brightness == Brightness.light
            ? const Color(0xFFF0F0F0)
            : theme.colorScheme.onSurface.withValues(alpha: 0.12));

    // Use 40dp logo for visual balance in kToolbarHeight
    const double logoSize = 40;
    const double iconSize = 22;

    // Build the logo widget
    Widget logoWidget;
    if (effectiveLogo != null) {
      logoWidget = SizedBox(
        width: logoSize,
        height: logoSize,
        child: effectiveLogo,
      );
    } else {
      logoWidget = Container(
        width: logoSize,
        height: logoSize,
        decoration: BoxDecoration(
          color: effectiveLogoBackground,
          borderRadius: BorderRadius.circular(radius.sm),
        ),
        child: Icon(
          effectiveIcon,
          color: theme.colorScheme.onSurface,
          size: iconSize,
        ),
      );
    }

    final effectiveTagline = config?.tagline;

    // Header height matches VooAdaptiveAppBar for alignment
    // VooAdaptiveAppBar uses toolbarHeight: kToolbarHeight + spacing.sm
    final effectiveHeight = height ?? config?.height ?? (kToolbarHeight + spacing.sm);

    // Check if using custom padding from config
    final customPadding = config?.padding;

    return GestureDetector(
      onTap: config?.onTap,
      child: Container(
        height: effectiveHeight,
        padding: customPadding ?? EdgeInsets.symmetric(horizontal: spacing.sm),
        child: Row(
          children: [
            logoWidget,
            if (effectiveShowTitle && effectiveTitle != null) ...[
              SizedBox(width: spacing.sm),
              Expanded(
                child: effectiveTagline != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            effectiveTitle,
                            style: config?.titleStyle ??
                                theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            effectiveTagline,
                            style: config?.taglineStyle ??
                                theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w400,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      )
                    : Text(
                        effectiveTitle,
                        style: config?.titleStyle ??
                            theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
