import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/breadcrumb_item.dart';

/// Separator widget between breadcrumb items
class VooBreadcrumbSeparator extends StatelessWidget {
  /// Style configuration
  final VooBreadcrumbsStyle style;

  /// Custom separator widget
  final Widget? separator;

  const VooBreadcrumbSeparator({
    super.key,
    required this.style,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: style.itemSpacing ?? 8),
      child: separator ??
          Icon(
            Icons.chevron_right,
            size: 16,
            color: style.separatorColor ?? colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
    );
  }
}
