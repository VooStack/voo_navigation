import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/breadcrumb_item.dart';

/// A single breadcrumb item widget
class VooBreadcrumbItemWidget extends StatefulWidget {
  /// The breadcrumb item data
  final VooBreadcrumbItem item;

  /// Whether this is the first item
  final bool isFirst;

  /// Whether this is the last item
  final bool isLast;

  /// Whether to show home icon
  final bool showHomeIcon;

  /// Style configuration
  final VooBreadcrumbsStyle style;

  /// Callback when tapped
  final VoidCallback? onTap;

  const VooBreadcrumbItemWidget({
    super.key,
    required this.item,
    required this.isFirst,
    required this.isLast,
    required this.showHomeIcon,
    required this.style,
    this.onTap,
  });

  @override
  State<VooBreadcrumbItemWidget> createState() => _VooBreadcrumbItemWidgetState();
}

class _VooBreadcrumbItemWidgetState extends State<VooBreadcrumbItemWidget> {
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
