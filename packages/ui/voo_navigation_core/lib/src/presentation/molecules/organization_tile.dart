import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_avatar.dart';

/// A single organization tile in the dropdown
class VooOrganizationTile extends StatefulWidget {
  /// Organization data
  final VooOrganization organization;

  /// Whether this organization is selected
  final bool isSelected;

  /// Whether this item is highlighted (keyboard navigation)
  final bool isHighlighted;

  /// Style configuration
  final VooOrganizationSwitcherStyle style;

  /// Callback when tapped
  final VoidCallback onTap;

  const VooOrganizationTile({
    super.key,
    required this.organization,
    required this.isSelected,
    required this.isHighlighted,
    required this.style,
    required this.onTap,
  });

  @override
  State<VooOrganizationTile> createState() => _VooOrganizationTileState();
}

class _VooOrganizationTileState extends State<VooOrganizationTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final org = widget.organization;
    final style = widget.style;

    final backgroundColor = widget.isSelected
        ? (style.selectedColor ?? colorScheme.primaryContainer)
        : widget.isHighlighted || _isHovered
            ? (style.hoverColor ?? colorScheme.surfaceContainerHighest)
            : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: style.itemPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: backgroundColor,
          child: Row(
            children: [
              VooAvatar(
                imageUrl: org.avatarUrl,
                child: org.avatarWidget,
                name: org.name,
                backgroundColor: org.avatarColor,
                size: style.avatarSize * 0.9,
                placeholderIcon: Icons.business,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      org.name,
                      style: style.titleStyle ?? theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (org.subtitle != null)
                      Text(
                        org.subtitle!,
                        style: style.subtitleStyle ?? theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (widget.isSelected)
                Icon(
                  Icons.check,
                  size: 20,
                  color: colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
