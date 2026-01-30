import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_navigation_bar/src/presentation/molecules/voo_expandable_nav_modal.dart';

/// A context switcher navigation item that matches the expandable nav bar design.
///
/// Displays as a dark circle with icon (like other nav items), and opens
/// an overlay modal when tapped (like the action item).
class VooContextSwitcherExpandableNavItem extends StatefulWidget {
  /// Configuration for the context switcher
  final VooContextSwitcherConfig config;

  /// Whether haptic feedback is enabled
  final bool enableHapticFeedback;

  /// Custom color for when selected
  final Color? selectedColor;

  const VooContextSwitcherExpandableNavItem({
    super.key,
    required this.config,
    this.enableHapticFeedback = true,
    this.selectedColor,
  });

  @override
  State<VooContextSwitcherExpandableNavItem> createState() =>
      _VooContextSwitcherExpandableNavItemState();
}

class _VooContextSwitcherExpandableNavItemState
    extends State<VooContextSwitcherExpandableNavItem>
    with TickerProviderStateMixin, ExpandableNavModalMixin {
  @override
  void initState() {
    super.initState();
    initModalAnimation();
  }

  @override
  void dispose() {
    disposeModalAnimation();
    super.dispose();
  }

  void _handleTap() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    if (isModalOpen) {
      closeModal();
    } else {
      openModal(_buildModalContent);
    }
  }

  Widget _buildModalContent(BuildContext context) {
    return _ContextSwitcherModalContent(
      config: widget.config,
      onClose: closeModal,
      onContextSelected: (item) {
        widget.config.onContextChanged?.call(item);
        closeModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.config.selectedItem;
    final hasSelection = selected != null;
    final circleSize = VooNavigationTokens.expandableNavSelectedCircleSize;

    // Use the same dark circle style as unselected items
    final circleColor = context.expandableNavUnselectedCircle;
    final iconColor = hasSelection
        ? (selected.color ?? widget.selectedColor ?? context.expandableNavSelectedIcon)
        : context.expandableNavUnselectedIcon;

    final containerHeight = circleSize + 4;

    return GestureDetector(
      key: buttonKey,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Tooltip(
        message: widget.config.placeholder ?? 'Context',
        child: Container(
          height: containerHeight,
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Center(
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  selected?.icon ?? Icons.grid_view_rounded,
                  color: iconColor,
                  size: VooNavigationTokens.iconSizeCompact,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Modal content for context switcher
class _ContextSwitcherModalContent extends StatefulWidget {
  final VooContextSwitcherConfig config;
  final VoidCallback onClose;
  final void Function(VooContextItem) onContextSelected;

  const _ContextSwitcherModalContent({
    required this.config,
    required this.onClose,
    required this.onContextSelected,
  });

  @override
  State<_ContextSwitcherModalContent> createState() =>
      _ContextSwitcherModalContentState();
}

class _ContextSwitcherModalContentState
    extends State<_ContextSwitcherModalContent> {
  String _searchQuery = '';

  List<VooContextItem> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.config.items;
    final query = _searchQuery.toLowerCase();
    return widget.config.items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                widget.config.placeholder ?? 'Select Context',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white54,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          // Search (if enabled)
          if (widget.config.showSearch) ...[
            const SizedBox(height: 12),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Context items (scrollable)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _filteredItems.isEmpty
                    ? [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No items found',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]
                    : _filteredItems.map((item) => _buildContextItem(context, item)).toList(),
              ),
            ),
          ),

          // Create button (if enabled)
          if (widget.config.onCreateContext != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                widget.onClose();
                widget.config.onCreateContext?.call();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white70, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      widget.config.createContextLabel ?? 'Create New',
                      style: const TextStyle(
                        color: Colors.white70,
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
    );
  }

  Widget _buildContextItem(BuildContext context, VooContextItem item) {
    final isSelected = widget.config.selectedItem?.id == item.id;

    return GestureDetector(
      onTap: () => widget.onContextSelected(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (item.color ?? Colors.white).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: (item.color ?? Colors.white).withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            // Color indicator or icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: item.color ?? Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.icon != null
                  ? Icon(
                      item.icon,
                      color: item.color != null
                          ? (item.color!.computeLuminance() > 0.5
                              ? Colors.black87
                              : Colors.white)
                          : Colors.white,
                      size: 18,
                    )
                  : Center(
                      child: Text(
                        item.initials,
                        style: TextStyle(
                          color: item.color != null
                              ? (item.color!.computeLuminance() > 0.5
                                  ? Colors.black87
                                  : Colors.white)
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: item.color ?? Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
