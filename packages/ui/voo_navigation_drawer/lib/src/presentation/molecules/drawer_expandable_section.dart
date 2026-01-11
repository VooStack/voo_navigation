import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_child_navigation_item.dart';

/// Expandable section widget for drawer navigation with children
class VooDrawerExpandableSection extends StatelessWidget {
  /// The navigation item with children
  final VooNavigationItem item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationItem item) onItemTap;

  /// Map of hovered item states
  final Map<String, bool> hoveredItems;

  /// Callback to set hover state
  final void Function(String itemId, bool isHovered) onHoverChanged;

  /// Expansion animation controller
  final AnimationController? expansionController;

  /// Expansion animation
  final Animation<double>? expansionAnimation;

  const VooDrawerExpandableSection({
    super.key,
    required this.item,
    required this.config,
    required this.selectedId,
    required this.onItemTap,
    required this.hoveredItems,
    required this.onHoverChanged,
    this.expansionController,
    this.expansionAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHovered = hoveredItems[item.id] == true;

    // Use config colors if provided, otherwise fall back to theme
    final sectionColor = config.unselectedItemColor ?? theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => onHoverChanged(item.id, true),
          onExit: (_) => onHoverChanged(item.id, false),
          child: InkWell(
            onTap: () => onItemTap(item),
            borderRadius: BorderRadius.circular(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isHovered
                    ? sectionColor.withValues(alpha: 0.04)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  // Section icon
                  Icon(
                    item.icon,
                    color: sectionColor.withValues(alpha: 0.7),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: sectionColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  // Dropdown arrow
                  Icon(
                    Icons.arrow_drop_down,
                    color: sectionColor.withValues(alpha: 0.4),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Animated expansion for children with connector line
        if (expansionController != null && expansionAnimation != null)
          SizeTransition(
            sizeFactor: expansionAnimation!,
            child: Stack(
              clipBehavior: Clip.none, // Allow line to extend upward
              children: [
                // Connector line from section icon center to children
                // Positioned at 17px from left (8px padding + 9px icon center)
                // Extends upward (-17px) to reach the icon's vertical center
                // (header has 8px bottom padding + 9px to reach icon center = 17px up)
                Positioned(
                  left: 17,
                  top: -17,
                  child: Container(
                    width: 2,
                    height: 25, // Extends from icon center down into children area
                    decoration: BoxDecoration(
                      color: sectionColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
                // Children items
                Column(
                  children: item.children!
                      .map(
                        (child) => VooDrawerChildNavigationItem(
                          item: child,
                          config: config,
                          selectedId: selectedId,
                          onItemTap: onItemTap,
                          isHovered: hoveredItems[child.id] == true,
                          onHoverChanged: (isHovered) =>
                              onHoverChanged(child.id, isHovered),
                          showVerticalLine: true,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
