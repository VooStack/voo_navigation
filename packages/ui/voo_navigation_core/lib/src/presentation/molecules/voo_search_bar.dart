import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';
import 'package:voo_navigation_core/src/presentation/atoms/voo_search_field.dart';
import 'package:voo_navigation_core/src/presentation/molecules/search_bar_results.dart';

/// A search bar with navigation filtering and global search capabilities
class VooSearchBar extends StatefulWidget {
  /// Controller for the search field
  final TextEditingController? controller;

  /// Focus node for the search field
  final FocusNode? focusNode;

  /// Navigation items to filter
  final List<VooNavigationItem>? navigationItems;

  /// Callback when filtered items change
  final ValueChanged<List<VooNavigationItem>>? onFilteredItemsChanged;

  /// Callback when search text changes
  final ValueChanged<String>? onSearch;

  /// Callback when search is submitted
  final VoidCallback? onSearchSubmit;

  /// Search actions (quick commands)
  final List<VooSearchAction>? searchActions;

  /// Hint text for the search field
  final String? hintText;

  /// Whether to show filtered results dropdown
  final bool showFilteredResults;

  /// Whether to enable CMD/CTRL+K shortcut
  final bool enableKeyboardShortcut;

  /// Keyboard shortcut hint text
  final String? keyboardShortcutHint;

  /// Style configuration
  final VooSearchBarStyle? style;

  /// Whether the search bar is expanded
  final bool expanded;

  /// Custom builder for filtered navigation items
  final Widget Function(VooNavigationItem, VoidCallback onTap)? filteredItemBuilder;

  /// Custom builder for search actions
  final Widget Function(VooSearchAction, VoidCallback onTap)? actionBuilder;

  /// Callback when a navigation item is selected
  final ValueChanged<VooNavigationItem>? onNavigationItemSelected;

  /// Callback when a search action is selected
  final ValueChanged<VooSearchAction>? onSearchActionSelected;

  /// Whether to show recent searches
  final bool showRecentSearches;

  /// Recent search queries
  final List<String>? recentSearches;

  /// Callback when a recent search is selected
  final ValueChanged<String>? onRecentSearchSelected;

  /// Callback to clear recent searches
  final VoidCallback? onClearRecentSearches;

  const VooSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.navigationItems,
    this.onFilteredItemsChanged,
    this.onSearch,
    this.onSearchSubmit,
    this.searchActions,
    this.hintText,
    this.showFilteredResults = true,
    this.enableKeyboardShortcut = true,
    this.keyboardShortcutHint,
    this.style,
    this.expanded = false,
    this.filteredItemBuilder,
    this.actionBuilder,
    this.onNavigationItemSelected,
    this.onSearchActionSelected,
    this.showRecentSearches = false,
    this.recentSearches,
    this.onRecentSearchSelected,
    this.onClearRecentSearches,
  });

  @override
  State<VooSearchBar> createState() => _VooSearchBarState();
}

class _VooSearchBarState extends State<VooSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;
  int _selectedIndex = -1;
  String _query = '';

  List<VooNavigationItem> get _filteredNavItems {
    if (_query.isEmpty || widget.navigationItems == null) return [];
    final query = _query.toLowerCase();
    return widget.navigationItems!.where((item) {
      return item.label.toLowerCase().contains(query) ||
          (item.tooltip?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  List<VooSearchAction> get _filteredActions {
    if (widget.searchActions == null) return [];
    if (_query.isEmpty) return widget.searchActions!;
    return widget.searchActions!.where((action) => action.matchesQuery(_query)).toList();
  }

  int get _totalResults =>
      _filteredNavItems.length +
      _filteredActions.length +
      (_showRecentSection ? (widget.recentSearches?.length ?? 0) : 0);

  bool get _showRecentSection =>
      widget.showRecentSearches &&
      _query.isEmpty &&
      (widget.recentSearches?.isNotEmpty ?? false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _removeOverlay();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    _focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_focusNode.hasFocus) {
          _removeOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    if (_isOpen) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
      _selectedIndex = -1;
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

  void _handleSearch(String value) {
    setState(() {
      _query = value;
      _selectedIndex = -1;
    });

    widget.onSearch?.call(value);

    if (widget.navigationItems != null) {
      widget.onFilteredItemsChanged?.call(_filteredNavItems);
    }

    _overlayEntry?.markNeedsBuild();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final total = _totalResults;
    if (total == 0) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        _selectedIndex = (_selectedIndex + 1) % total;
      });
      _overlayEntry?.markNeedsBuild();
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        _selectedIndex = _selectedIndex <= 0 ? total - 1 : _selectedIndex - 1;
      });
      _overlayEntry?.markNeedsBuild();
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      _selectCurrentItem();
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      _focusNode.unfocus();
    }
  }

  void _selectCurrentItem() {
    if (_selectedIndex < 0) return;

    int index = _selectedIndex;

    // Recent searches
    if (_showRecentSection) {
      final recentCount = widget.recentSearches?.length ?? 0;
      if (index < recentCount) {
        final recent = widget.recentSearches![index];
        widget.onRecentSearchSelected?.call(recent);
        _controller.text = recent;
        _handleSearch(recent);
        return;
      }
      index -= recentCount;
    }

    // Navigation items
    if (index < _filteredNavItems.length) {
      final item = _filteredNavItems[index];
      widget.onNavigationItemSelected?.call(item);
      _removeOverlay();
      return;
    }
    index -= _filteredNavItems.length;

    // Search actions
    if (index < _filteredActions.length) {
      final action = _filteredActions[index];
      widget.onSearchActionSelected?.call(action);
      action.onTap?.call();
      _removeOverlay();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final style = widget.style ?? const VooSearchBarStyle();
    final dropdownWidth = style.dropdownWidth ?? size.width;
    final maxHeight = style.maxDropdownHeight ?? 400;

    return OverlayEntry(
      builder: (context) {
        final hasResults = _totalResults > 0 || _showRecentSection;

        if (!hasResults && _query.isEmpty) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _focusNode.unfocus(),
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
            // Results dropdown
            CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 8,
                borderRadius: style.borderRadius ?? BorderRadius.circular(12),
                color: style.dropdownBackgroundColor ??
                    Theme.of(context).colorScheme.surface,
                child: Container(
                  width: dropdownWidth,
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  decoration: BoxDecoration(
                    borderRadius: style.borderRadius ?? BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: _handleKeyEvent,
                    child: VooSearchBarResults(
                      style: style,
                      query: _query,
                      showRecentSection: _showRecentSection,
                      recentSearches: widget.recentSearches,
                      filteredNavItems: _filteredNavItems,
                      filteredActions: _filteredActions,
                      selectedIndex: _selectedIndex,
                      onClearRecentSearches: widget.onClearRecentSearches,
                      onRecentSearchSelected: (search) {
                        widget.onRecentSearchSelected?.call(search);
                        _controller.text = search;
                        _handleSearch(search);
                      },
                      onNavigationItemSelected: (item) {
                        widget.onNavigationItemSelected?.call(item);
                        _removeOverlay();
                      },
                      onSearchActionSelected: (action) {
                        widget.onSearchActionSelected?.call(action);
                        action.onTap?.call();
                        _removeOverlay();
                      },
                      filteredItemBuilder: widget.filteredItemBuilder,
                      actionBuilder: widget.actionBuilder,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const VooSearchBarStyle();

    return CompositedTransformTarget(
      link: _layerLink,
      child: VooSearchField(
        controller: _controller,
        focusNode: _focusNode,
        hintText: widget.hintText ?? 'Search...',
        expanded: widget.expanded,
        width: style.width,
        height: style.height,
        showKeyboardHint: widget.enableKeyboardShortcut,
        keyboardHintText: widget.keyboardShortcutHint,
        enableKeyboardShortcut: widget.enableKeyboardShortcut,
        backgroundColor: style.backgroundColor,
        focusedBackgroundColor: style.focusedBackgroundColor,
        borderColor: style.borderColor,
        focusedBorderColor: style.focusedBorderColor,
        borderRadius: style.borderRadius,
        textStyle: style.textStyle,
        hintStyle: style.hintStyle,
        contentPadding: style.padding,
        onChanged: _handleSearch,
        onSubmitted: (_) {
          widget.onSearchSubmit?.call();
          if (_selectedIndex >= 0) {
            _selectCurrentItem();
          }
        },
      ),
    );
  }
}
