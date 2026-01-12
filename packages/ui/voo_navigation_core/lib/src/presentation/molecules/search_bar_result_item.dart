import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';

/// A single search bar result item
class VooSearchBarResultItem extends StatelessWidget {
  /// Style configuration
  final VooSearchBarStyle style;

  /// Icon to display
  final IconData? icon;

  /// Custom icon widget
  final Widget? iconWidget;

  /// Item label
  final String label;

  /// Optional subtitle
  final String? subtitle;

  /// Optional keyboard shortcut
  final String? shortcut;

  /// Whether this item is selected
  final bool isSelected;

  /// Callback when tapped
  final VoidCallback onTap;

  const VooSearchBarResultItem({
    super.key,
    required this.style,
    this.icon,
    this.iconWidget,
    required this.label,
    this.subtitle,
    this.shortcut,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: isSelected ? colorScheme.surfaceContainerHighest : null,
        child: Row(
          children: [
            if (iconWidget != null)
              iconWidget!
            else if (icon != null)
              Icon(
                icon,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: style.resultItemStyle ?? theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (shortcut != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  shortcut!,
                  style: style.shortcutStyle ??
                      theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
