import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/voo_user_status.dart';

/// User status indicator dot
class VooStatusIndicator extends StatelessWidget {
  /// The user status
  final VooUserStatus status;

  const VooStatusIndicator({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (status) {
      VooUserStatus.online => const Color(0xFF22C55E),
      VooUserStatus.away => const Color(0xFFF59E0B),
      VooUserStatus.busy => const Color(0xFFEF4444),
      VooUserStatus.offline => theme.colorScheme.outline,
    };

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 2,
        ),
        // Minimal: no glow on online status. The hairline ring against the
        // parent surface already provides the contrast.
      ),
    );
  }
}
