import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/breadcrumb_item.dart';

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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
              _buildSeparator(effectiveStyle, colorScheme),
              collapsedItemsBuilder != null
                  ? collapsedItemsBuilder!(collapsedItems)
                  : _CollapsedItemsDropdown(
                      items: collapsedItems,
                      style: effectiveStyle,
                      onItemTap: onItemTap,
                    ),
            ],

            // Separator (except before first item)
            if (i > 0 || (i == 1 && collapsedItems.isNotEmpty))
              _buildSeparator(effectiveStyle, colorScheme),

            // Breadcrumb item
            itemBuilder != null
                ? itemBuilder!(visibleItems[i], i == visibleItems.length - 1)
                : _BreadcrumbItem(
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

  Widget _buildSeparator(VooBreadcrumbsStyle style, ColorScheme colorScheme) {
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

class _BreadcrumbItem extends StatefulWidget {
  final VooBreadcrumbItem item;
  final bool isFirst;
  final bool isLast;
  final bool showHomeIcon;
  final VooBreadcrumbsStyle style;
  final VoidCallback? onTap;

  const _BreadcrumbItem({
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.showHomeIcon,
    required this.style,
    this.onTap,
  });

  @override
  State<_BreadcrumbItem> createState() => _BreadcrumbItemState();
}

class _BreadcrumbItemState extends State<_BreadcrumbItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final item = widget.item;
    final style = widget.style;

    final isClickable = !item.isCurrentPage && (item.onTap != null || widget.onTap != null);

    final textStyle = item.isCurrentPage
        ? (style.currentItemStyle ?? theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ))
        : (style.itemStyle ?? theme.textTheme.bodyMedium?.copyWith(
            color: _isHovered
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ));

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showHomeIcon && item.icon != null)
          Padding(
            padding: EdgeInsets.only(right: style.iconSpacing ?? 4),
            child: item.iconWidget ??
                Icon(
                  item.icon,
                  size: style.iconSize ?? 16,
                  color: textStyle?.color,
                ),
          )
        else if (widget.showHomeIcon && widget.isFirst)
          Padding(
            padding: EdgeInsets.only(right: style.iconSpacing ?? 4),
            child: Icon(
              Icons.home_outlined,
              size: style.iconSize ?? 16,
              color: textStyle?.color,
            ),
          ),
        if (!widget.showHomeIcon || !widget.isFirst || item.label != 'Home')
          Text(
            item.label,
            style: textStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );

    if (isClickable) {
      content = MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            item.onTap?.call();
            widget.onTap?.call();
          },
          child: Container(
            padding: style.itemPadding ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: _isHovered ? (style.hoverColor ?? colorScheme.surfaceContainerHighest) : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: content,
          ),
        ),
      );
    } else {
      content = Padding(
        padding: style.itemPadding ?? const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: content,
      );
    }

    return content;
  }
}

class _CollapsedItemsDropdown extends StatefulWidget {
  final List<VooBreadcrumbItem> items;
  final VooBreadcrumbsStyle style;
  final ValueChanged<VooBreadcrumbItem>? onItemTap;

  const _CollapsedItemsDropdown({
    required this.items,
    required this.style,
    this.onItemTap,
  });

  @override
  State<_CollapsedItemsDropdown> createState() => _CollapsedItemsDropdownState();
}

class _CollapsedItemsDropdownState extends State<_CollapsedItemsDropdown> {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isHovered = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return InkWell(
                      onTap: () {
                        _removeOverlay();
                        item.onTap?.call();
                        widget.onItemTap?.call(item);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            if (item.icon != null) ...[
                              item.iconWidget ??
                                  Icon(
                                    item.icon,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                item.label,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _isHovered || _isOpen
                ? (widget.style.hoverColor ?? colorScheme.surfaceContainerHighest)
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
