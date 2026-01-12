import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Default navigation page widget for placeholder content
class VooDefaultNavigationPage extends StatelessWidget {
  /// The navigation item for this page
  final VooNavigationItem item;

  const VooDefaultNavigationPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.effectiveSelectedIcon,
              size: context.vooSize.avatarXLarge,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: context.vooSpacing.lg),
            Text(
              item.label,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.vooSpacing.sm),
            Text(
              'Page for ${item.label}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
