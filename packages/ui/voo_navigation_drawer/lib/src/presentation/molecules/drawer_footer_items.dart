import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_footer_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Footer items widget for static routes like Settings, Integrations, Help
class VooDrawerFooterItems extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Map of hovered item states
  final Map<String, bool> hoveredItems;

  /// Callback when hover state changes
  final void Function(String itemId, bool isHovered) onHoverChanged;

  const VooDrawerFooterItems({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.hoveredItems,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final footerItems = config.visibleFooterItems;

    if (footerItems.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(context.vooSpacing.sm),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: footerItems.map(
          (item) => VooDrawerFooterItem(
            item: item,
            config: config,
            selectedId: selectedId,
            onItemTap: onItemTap,
            isHovered: hoveredItems[item.id] ?? false,
            onHoverChanged: (isHovered) => onHoverChanged(item.id, isHovered),
          ),
        ).toList(),
      ),
    );
  }
}
