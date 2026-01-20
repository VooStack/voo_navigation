import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_item.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/tokens/voo_navigation_tokens.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Shows the context switcher as a bottom sheet modal.
///
/// This is the mobile-friendly presentation of the context switcher,
/// providing a clean UI/UX for selecting contexts on mobile devices.
void showContextSwitcherBottomSheet({
  required BuildContext context,
  required VooContextSwitcherConfig config,
  required ValueChanged<VooContextItem> onContextSelected,
}) {
  HapticFeedback.lightImpact();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => VooContextSwitcherBottomSheet(
      config: config,
      onContextSelected: onContextSelected,
    ),
  );
}

/// Bottom sheet widget for the context switcher.
///
/// This widget displays a list of available contexts in a bottom sheet
/// format, optimized for mobile interaction.
class VooContextSwitcherBottomSheet extends StatefulWidget {
  /// Configuration for the context switcher
  final VooContextSwitcherConfig config;

  /// Callback when a context is selected
  final ValueChanged<VooContextItem> onContextSelected;

  const VooContextSwitcherBottomSheet({
    super.key,
    required this.config,
    required this.onContextSelected,
  });

  @override
  State<VooContextSwitcherBottomSheet> createState() =>
      _VooContextSwitcherBottomSheetState();
}

class _VooContextSwitcherBottomSheetState
    extends State<VooContextSwitcherBottomSheet> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
    super.dispose();
  }

  void _handleContextSelected(VooContextItem item) {
    widget.onContextSelected(item);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = context.vooRadius;
    final style = widget.config.style ?? const VooContextSwitcherStyle();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius.lg),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Section title (optional)
          if (widget.config.sectionTitle != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                widget.config.sectionTitle!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          // Search (optional)
          if (widget.config.showSearch)
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                widget.config.sectionTitle != null ? 8 : 16,
                16,
                8,
              ),
              child: TextField(
                controller: _searchController,
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
                  fillColor: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: theme.textTheme.bodyMedium,
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),

          // Context list
          Flexible(
            child: _filteredItems.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
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

                      return _BottomSheetContextItem(
                        item: item,
                        isSelected: isSelected,
                        style: style,
                        onTap: () => _handleContextSelected(item),
                      );
                    },
                  ),
          ),

          // Create button (optional)
          if (widget.config.onCreateContext != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(
                height: 1,
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                widget.config.onCreateContext?.call();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 22,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
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

          // Bottom safe area padding
          SizedBox(height: bottomPadding > 0 ? bottomPadding : 8),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32),
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

/// Individual context item for the bottom sheet
class _BottomSheetContextItem extends StatelessWidget {
  final VooContextItem item;
  final bool isSelected;
  final VooContextSwitcherStyle style;
  final VoidCallback onTap;

  const _BottomSheetContextItem({
    required this.item,
    required this.isSelected,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = style.avatarSize;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: style.itemBorderRadius ??
            BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
        child: Container(
          padding: style.itemPadding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (style.selectedColor ??
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.4))
                : Colors.transparent,
            borderRadius: style.itemBorderRadius ??
                BorderRadius.circular(VooNavigationTokens.itemBorderRadius),
          ),
          child: Row(
            children: [
              // Avatar/Icon
              _buildAvatar(context, size),
              const SizedBox(width: 12),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      style: style.titleStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: style.subtitleStyle ??
                            theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Selected checkmark
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double size) {
    final theme = Theme.of(context);

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
    final initials = item.initials;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: item.color ?? theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            color: item.color != null
                ? _getContrastColor(item.color!)
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
