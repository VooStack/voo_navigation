import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_item.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_style.dart';

/// Card component for the context switcher (closed state).
///
/// This widget displays a compact view showing the currently selected context.
/// Tapping expands to show the dropdown modal with available contexts.
class VooContextSwitcherCard extends StatefulWidget {
  /// Configuration for the context switcher
  final VooContextSwitcherConfig config;

  /// Whether the modal is currently expanded
  final bool isExpanded;

  /// Whether to show in compact mode (icon/avatar only)
  final bool compact;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  const VooContextSwitcherCard({
    super.key,
    required this.config,
    required this.isExpanded,
    required this.compact,
    required this.onTap,
  });

  @override
  State<VooContextSwitcherCard> createState() => _VooContextSwitcherCardState();
}

class _VooContextSwitcherCardState extends State<VooContextSwitcherCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.config.style ?? const VooContextSwitcherStyle();
    final selected = widget.config.selectedItem;

    // Allow custom card builder
    if (widget.config.cardBuilder != null) {
      return widget.config.cardBuilder!(
        context,
        VooContextSwitcherCardData(
          selectedItem: selected,
          isExpanded: widget.isExpanded,
          onTap: widget.onTap,
          placeholder: widget.config.placeholder,
        ),
      );
    }

    // Compact mode - just icon/avatar
    if (widget.compact) {
      return Tooltip(
        message: selected?.name ?? widget.config.placeholder ?? 'Select context',
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _isHovered || widget.isExpanded
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildAvatar(context, selected, style.compactAvatarSize),
            ),
          ),
        ),
      );
    }

    // Inline card - elegant pill-style selector
    final bool hasSelection = selected != null;
    final Color accentColor = selected?.color ?? theme.colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _isHovered || widget.isExpanded
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.06)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: widget.isExpanded
                    ? theme.colorScheme.outline.withValues(alpha: 0.2)
                    : theme.colorScheme.outline.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Color indicator dot
                if (hasSelection)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  )
                else
                  Icon(
                    Icons.layers_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                const SizedBox(width: 8),
                // Name or placeholder
                Expanded(
                  child: Text(
                    selected?.name ?? widget.config.placeholder ?? 'Select',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: hasSelection ? FontWeight.w500 : FontWeight.w400,
                      fontSize: 12,
                      color: hasSelection
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                // Subtle dropdown chevron
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(
      BuildContext context, VooContextItem? item, double size) {
    final theme = Theme.of(context);

    // Custom avatar widget takes precedence
    if (item?.avatarWidget != null) {
      return SizedBox(
        width: size,
        height: size,
        child: item!.avatarWidget,
      );
    }

    // Avatar URL
    if (item?.avatarUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.network(
          item!.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackAvatar(
            context,
            item,
            size,
          ),
        ),
      );
    }

    // Icon
    if (item?.icon != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: item?.color ?? theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(size / 4),
        ),
        child: Icon(
          item!.icon,
          size: size * 0.55,
          color: item.color != null
              ? _getContrastColor(item.color!)
              : theme.colorScheme.onPrimaryContainer,
        ),
      );
    }

    // Fallback - initials
    return _buildFallbackAvatar(context, item, size);
  }

  Widget _buildFallbackAvatar(
      BuildContext context, VooContextItem? item, double size) {
    final theme = Theme.of(context);
    final initials = item?.initials ?? '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: item?.color ?? theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: item?.color != null
                ? _getContrastColor(item!.color!)
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}
