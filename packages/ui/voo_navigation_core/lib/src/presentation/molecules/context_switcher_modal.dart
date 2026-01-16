import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_item.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';

/// Modal component for the context switcher (open state).
///
/// This widget displays the dropdown list of available contexts.
/// It includes optional search and a create button.
class VooContextSwitcherModal extends StatefulWidget {
  /// Configuration for the context switcher
  final VooContextSwitcherConfig config;

  /// Animation for the slide transition
  final Animation<double> animation;

  /// Callback when the modal should close
  final VoidCallback onClose;

  /// Callback when a context is selected
  final ValueChanged<VooContextItem> onContextSelected;

  const VooContextSwitcherModal({
    super.key,
    required this.config,
    required this.animation,
    required this.onClose,
    required this.onContextSelected,
  });

  @override
  State<VooContextSwitcherModal> createState() => _VooContextSwitcherModalState();
}

class _VooContextSwitcherModalState extends State<VooContextSwitcherModal> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<VooContextItem> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.config.items;
    return widget.config.items.where((item) {
      return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (item.subtitle?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.config.style ?? const VooContextSwitcherStyle();

    // Allow custom modal builder
    if (widget.config.modalBuilder != null) {
      return AnimatedBuilder(
        animation: widget.animation,
        builder: (context, child) {
          return Opacity(
            opacity: widget.animation.value.clamp(0.0, 1.0),
            child: widget.config.modalBuilder!(
              context,
              VooContextSwitcherModalData(
                items: _filteredItems,
                selectedItem: widget.config.selectedItem,
                onClose: widget.onClose,
                onContextSelected: widget.onContextSelected,
                onCreateContext: widget.config.onCreateContext,
                createContextLabel: widget.config.createContextLabel,
                sectionTitle: widget.config.sectionTitle,
                searchQuery: _searchQuery,
                onSearchChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          );
        },
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight:
            style.modalMaxHeight ?? VooContextSwitcherStyle.defaultModalMaxHeight,
      ),
      margin: const EdgeInsets.only(top: 4),
      decoration: style.modalDecoration ??
          BoxDecoration(
            color: style.modalBackgroundColor ?? theme.colorScheme.surface,
            borderRadius: style.modalBorderRadius ?? BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
      child: ClipRRect(
        borderRadius: style.modalBorderRadius ?? BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section title (optional)
            if (widget.config.sectionTitle != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Text(
                  widget.config.sectionTitle!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

            // Search (optional)
            if (widget.config.showSearch) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  12,
                  widget.config.sectionTitle != null ? 8 : 12,
                  12,
                  4,
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: widget.config.searchHint ?? 'Search...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor:
                        theme.colorScheme.onSurface.withValues(alpha: 0.04),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                  style: theme.textTheme.bodyMedium,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),
            ],

            // Scrollable context list
            Flexible(
              child: _filteredItems.isEmpty
                  ? _buildEmptyState(context, theme)
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        final isSelected =
                            item.id == widget.config.selectedItem?.id;

                        // Allow custom item builder
                        if (widget.config.itemBuilder != null) {
                          return widget.config.itemBuilder!(
                            context,
                            item,
                            isSelected,
                          );
                        }

                        return _ContextItemTile(
                          item: item,
                          isSelected: isSelected,
                          style: style,
                          onTap: () {
                            widget.onContextSelected(item);
                            widget.onClose();
                          },
                        );
                      },
                    ),
            ),

            // Create button (optional)
            if (widget.config.onCreateContext != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  height: 1,
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
              InkWell(
                onTap: () {
                  widget.config.onCreateContext?.call();
                  widget.onClose();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.config.createContextLabel ?? 'Create new',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          'No results found',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Individual context item tile
class _ContextItemTile extends StatefulWidget {
  final VooContextItem item;
  final bool isSelected;
  final VooContextSwitcherStyle style;
  final VoidCallback onTap;

  const _ContextItemTile({
    required this.item,
    required this.isSelected,
    required this.style,
    required this.onTap,
  });

  @override
  State<_ContextItemTile> createState() => _ContextItemTileState();
}

class _ContextItemTileState extends State<_ContextItemTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = widget.style.avatarSize;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: widget.style.itemBorderRadius ??
              BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: widget.style.itemPadding ??
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? (widget.style.selectedColor ??
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.4))
                  : _isHovered
                      ? (widget.style.hoverColor ??
                          theme.colorScheme.onSurface.withValues(alpha: 0.05))
                      : Colors.transparent,
              borderRadius: widget.style.itemBorderRadius ??
                  BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
            ),
            child: Row(
              children: [
                // Avatar/Icon
                _buildAvatar(context, size),
                const SizedBox(width: 10),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.name,
                        style: widget.style.titleStyle ??
                            theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.item.subtitle!,
                          style: widget.style.subtitleStyle ??
                              theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Selected checkmark
                if (widget.isSelected) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double size) {
    final theme = Theme.of(context);
    final item = widget.item;

    // Custom avatar widget
    if (item.avatarWidget != null) {
      return SizedBox(
        width: size,
        height: size,
        child: item.avatarWidget,
      );
    }

    // Avatar URL
    if (item.avatarUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 4),
        child: Image.network(
          item.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackAvatar(context, size),
        ),
      );
    }

    // Icon
    if (item.icon != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: item.color ?? theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(size / 4),
        ),
        child: Icon(
          item.icon,
          size: size * 0.55,
          color: item.color != null
              ? _getContrastColor(item.color!)
              : theme.colorScheme.onPrimaryContainer,
        ),
      );
    }

    // Fallback - initials
    return _buildFallbackAvatar(context, size);
  }

  Widget _buildFallbackAvatar(BuildContext context, double size) {
    final theme = Theme.of(context);
    final initials = widget.item.initials;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.item.color ?? theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: widget.item.color != null
                ? _getContrastColor(widget.item.color!)
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
