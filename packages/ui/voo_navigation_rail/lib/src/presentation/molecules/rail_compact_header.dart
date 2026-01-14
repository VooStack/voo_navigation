import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Compact header for collapsed rail showing branding and expand toggle
class VooRailCompactHeader extends StatelessWidget {
  /// Trailing widget (expand toggle)
  final Widget? trailing;

  /// Header configuration for customizing the logo
  final VooHeaderConfig? headerConfig;

  const VooRailCompactHeader({
    super.key,
    this.trailing,
    this.headerConfig,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;
    final size = context.vooSize;

    // Use headerConfig values if provided
    final effectiveIcon = headerConfig?.logoIcon ?? Icons.dashboard;
    final effectiveLogo = headerConfig?.logo;
    final effectiveLogoBackground = headerConfig?.logoBackgroundColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.12);

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

    // Top padding calculated to align logo center with app bar title center
    // App bar title centered at ~32dp, logo is 40dp tall, so logo top = 32 - 20 = 12dp
    final topPadding = spacing.sm + spacing.xs; // 12dp

    return Padding(
      padding: EdgeInsets.fromLTRB(0, topPadding, 0, spacing.md),
      child: Column(
        children: [
          // Compact branding - just the logo
          GestureDetector(
            onTap: headerConfig?.onTap,
            child: logoWidget,
          ),
          SizedBox(height: spacing.md),
          // Expand toggle
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
