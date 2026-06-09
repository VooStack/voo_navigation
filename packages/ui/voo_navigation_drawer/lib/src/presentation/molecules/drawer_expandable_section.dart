import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_drawer/src/presentation/molecules/drawer_child_navigation_item.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Expandable section widget for drawer navigation with children
class VooDrawerExpandableSection extends StatelessWidget {
  /// The navigation item with children
  final VooNavigationDestination item;

  /// Navigation configuration
  final VooNavigationConfig config;

  /// Currently selected item ID
  final String selectedId;

  /// Callback when an item is tapped
  final void Function(VooNavigationDestination item) onItemTap;

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
    final m = context.vooMinimal;
    final isHovered = hoveredItems[item.id] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => onHoverChanged(item.id, true),
          onExit: (_) => onHoverChanged(item.id, false),
          child: InkWell(
            onTap: () => onItemTap(item),
            borderRadius: VooMinimal.brSm,
            child: AnimatedContainer(
              duration: VooMinimal.motionFast,
              curve: VooMinimal.motionCurve,
              padding: const EdgeInsets.symmetric(
                horizontal: VooNavigationTokens.itemPaddingHorizontal,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: isHovered ? m.hoverOverlay : Colors.transparent,
                borderRadius: VooMinimal.brSm,
              ),
              child: Row(
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: m.textTertiary,
                      size: VooNavigationTokens.iconSizeDefault,
                    ),
                    child: item.icon,
                  ),
                  const SizedBox(width: VooNavigationTokens.iconLabelSpacing),
                  Expanded(
                    child: Text(
                      item.label ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: m.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                  // Subtle chevron — rotates on expand via the parent's
                  // expansion controller (left to the existing impl).
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: m.textTertiary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Animated expansion for children
        if (expansionController != null && expansionAnimation != null)
          SizeTransition(
            sizeFactor: expansionAnimation!,
            child: Column(
              children: [
                // Section header widget (e.g., project selector)
                if (item.sectionHeaderWidget != null)
                  Padding(
                    // Use same padding as parent item for alignment
                    padding: const EdgeInsets.only(left: VooNavigationTokens.itemPaddingHorizontal),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Vertical line to match child items - uses custom color if provided
                          // Line center aligns with parent icon center (iconSizeDefault/2 - lineWidth/2 = 8dp)
                          Container(
                            width: 2,
                            margin: EdgeInsets.only(
                              left: VooNavigationTokens.iconSizeDefault / 2 - 1, // 8dp
                              right: context.vooSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: item.sectionHeaderLineColor ?? m.borderStrong,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          // Section header content
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: context.vooSpacing.xxs),
                              child: item.sectionHeaderWidget!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Child items
                ...item.children!.map(
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
                ),
              ],
            ),
          ),
      ],
    );
  }
}
