import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/notification_item.dart';

/// Footer for notifications bell dropdown
class VooNotificationsBellFooter extends StatelessWidget {
  /// Style configuration
  final VooNotificationsBellStyle style;

  /// Callback when view all is tapped
  final VoidCallback? onViewAll;

  /// Callback to remove overlay
  final VoidCallback onRemoveOverlay;

  const VooNotificationsBellFooter({
    super.key,
    required this.style,
    this.onViewAll,
    required this.onRemoveOverlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: TextButton(
        onPressed: () {
          onRemoveOverlay();
          onViewAll?.call();
        },
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                style.borderRadius?.bottomLeft.x ?? 16,
              ),
              bottomRight: Radius.circular(
                style.borderRadius?.bottomRight.x ?? 16,
              ),
            ),
          ),
        ),
        child: Text(
          'View all notifications',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
