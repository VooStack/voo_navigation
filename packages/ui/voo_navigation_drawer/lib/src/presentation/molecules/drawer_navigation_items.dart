import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_expandable_section.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Widget that builds the list of navigation items for the drawer
class VooDrawerNavigationItems extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Map of hovered item states
  final Map<String, bool> hoveredItems;

  /// Map of expansion controllers
  final Map<String, AnimationController> expansionControllers;

  /// Map of expansion animations
  final Map<String, Animation<double>> expansionAnimations;

  /// Callback to set hover state
  final void Function(String itemId, bool isHovered) onHoverChanged;

  const VooDrawerNavigationItems({
    super.key,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.hoveredItems,
    required this.expansionControllers,
    required this.expansionAnimations,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleItems = config.visibleItems;

    // Show loading widget if provided and config indicates loading
    if (config.loadingWidget != null && visibleItems.isEmpty) {
      return config.loadingWidget!;
    }

    // Show empty state if no items
    if (visibleItems.isEmpty) {
      return config.emptyStateWidget ?? _DefaultEmptyState();
    }

    final widgets = <Widget>[];

    for (int i = 0; i < visibleItems.length; i++) {
      final item = visibleItems[i];

      // Check if this is a divider
      if (item.isDivider) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.vooSpacing.sm),
            child: Divider(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              height: context.vooSize.borderThin,
            ),
          ),
        );
        continue;
      }

      // Check if this is a section with children
      if (item.hasChildren) {
        widgets.add(
          VooDrawerExpandableSection(
            item: item,
            config: config,
            selectedId: selectedId,
            onItemTap: onItemTap,
            hoveredItems: hoveredItems,
            onHoverChanged: onHoverChanged,
            expansionController: expansionControllers[item.id],
            expansionAnimation: expansionAnimations[item.id],
          ),
        );
      } else {
        widgets.add(
          VooDrawerNavigationItem(
            item: item,
            config: config,
            selectedId: selectedId,
            onItemTap: onItemTap,
            isHovered: hoveredItems[item.id] == true,
            onHoverChanged: (isHovered) => onHoverChanged(item.id, isHovered),
          ),
        );
      }

      // Add spacing between items (except for the last one)
      if (i < visibleItems.length - 1 && !visibleItems[i + 1].isDivider) {
        widgets.add(SizedBox(height: context.vooSpacing.xs));
      }
    }

    return Column(children: widgets);
  }
}

class _DefaultEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(context.vooSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: context.vooSpacing.md),
          Text(
            'No navigation items',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
