import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/breadcrumb_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/breadcrumb_item_widget.dart';
import 'package:voo_navigation_core/src/presentation/molecules/breadcrumb_separator.dart';
import 'package:voo_navigation_core/src/presentation/molecules/collapsed_items_dropdown.dart';

/// A breadcrumbs navigation widget
class VooBreadcrumbs extends StatelessWidget {
  /// List of breadcrumb items
  final List<VooBreadcrumbItem> items;

  /// Callback when a breadcrumb is tapped
  final ValueChanged<VooBreadcrumbItem>? onItemTap;

  /// Custom separator widget
  final Widget? separator;

  /// Maximum visible items before collapsing
  final int? maxVisibleItems;

  /// Whether to show home icon for first item
  final bool showHomeIcon;

  /// Style configuration
  final VooBreadcrumbsStyle? style;

  /// Custom item builder
  final Widget Function(VooBreadcrumbItem, bool isLast)? itemBuilder;

  /// Custom collapsed items builder
  final Widget Function(List<VooBreadcrumbItem>)? collapsedItemsBuilder;

  /// Whether to animate on item change
  final bool animate;

  const VooBreadcrumbs({
    super.key,
    required this.items,
    this.onItemTap,
    this.separator,
    this.maxVisibleItems,
    this.showHomeIcon = true,
    this.style,
    this.itemBuilder,
    this.collapsedItemsBuilder,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final effectiveStyle = style ?? const VooBreadcrumbsStyle();

    // Determine which items to show
    List<VooBreadcrumbItem> visibleItems;
    List<VooBreadcrumbItem> collapsedItems = [];

    if (maxVisibleItems != null && items.length > maxVisibleItems!) {
      // Show first item, collapsed indicator, and last (maxVisibleItems - 2) items
      final keepCount = maxVisibleItems! - 1;
      visibleItems = [
        items.first,
        ...items.sublist(items.length - keepCount),
      ];
      collapsedItems = items.sublist(1, items.length - keepCount);
    } else {
      visibleItems = items;
    }

    return Container(
      height: effectiveStyle.height,
      padding: effectiveStyle.containerPadding,
      decoration: effectiveStyle.backgroundColor != null ||
              effectiveStyle.borderRadius != null
          ? BoxDecoration(
              color: effectiveStyle.backgroundColor,
              borderRadius: effectiveStyle.borderRadius,
            )
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < visibleItems.length; i++) ...[
            // Collapsed items indicator (after first item)
            if (i == 1 && collapsedItems.isNotEmpty) ...[
              VooBreadcrumbSeparator(
                style: effectiveStyle,
                separator: separator,
              ),
              collapsedItemsBuilder != null
                  ? collapsedItemsBuilder!(collapsedItems)
                  : VooCollapsedItemsDropdown(
                      items: collapsedItems,
                      style: effectiveStyle,
                      onItemTap: onItemTap,
                    ),
            ],

            // Separator (except before first item)
            if (i > 0 || (i == 1 && collapsedItems.isNotEmpty))
              VooBreadcrumbSeparator(
                style: effectiveStyle,
                separator: separator,
              ),

            // Breadcrumb item
            itemBuilder != null
                ? itemBuilder!(visibleItems[i], i == visibleItems.length - 1)
                : VooBreadcrumbItemWidget(
                    item: visibleItems[i],
                    isFirst: i == 0,
                    isLast: i == visibleItems.length - 1,
                    showHomeIcon: showHomeIcon && i == 0,
                    style: effectiveStyle,
                    onTap: () => onItemTap?.call(visibleItems[i]),
                  ),
          ],
        ],
      ),
    );
  }
}

/// A horizontal scrollable breadcrumbs widget for long paths
class VooScrollableBreadcrumbs extends StatefulWidget {
  /// List of breadcrumb items
  final List<VooBreadcrumbItem> items;

  /// Callback when a breadcrumb is tapped
  final ValueChanged<VooBreadcrumbItem>? onItemTap;

  /// Custom separator widget
  final Widget? separator;

  /// Whether to show home icon for first item
  final bool showHomeIcon;

  /// Style configuration
  final VooBreadcrumbsStyle? style;

  /// Whether to auto-scroll to end when items change
  final bool autoScrollToEnd;

  const VooScrollableBreadcrumbs({
    super.key,
    required this.items,
    this.onItemTap,
    this.separator,
    this.showHomeIcon = true,
    this.style,
    this.autoScrollToEnd = true,
  });

  @override
  State<VooScrollableBreadcrumbs> createState() => _VooScrollableBreadcrumbsState();
}

class _VooScrollableBreadcrumbsState extends State<VooScrollableBreadcrumbs> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(VooScrollableBreadcrumbs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoScrollToEnd && widget.items.length != oldWidget.items.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style ?? const VooBreadcrumbsStyle();

    return Container(
      height: effectiveStyle.height ?? 40,
      padding: effectiveStyle.containerPadding,
      decoration: effectiveStyle.backgroundColor != null ||
              effectiveStyle.borderRadius != null
          ? BoxDecoration(
              color: effectiveStyle.backgroundColor,
              borderRadius: effectiveStyle.borderRadius,
            )
          : null,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: VooBreadcrumbs(
          items: widget.items,
          onItemTap: widget.onItemTap,
          separator: widget.separator,
          showHomeIcon: widget.showHomeIcon,
          style: widget.style,
        ),
      ),
    );
  }
}
