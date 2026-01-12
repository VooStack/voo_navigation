import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_search_bar.dart';

/// Search bar widget for the navigation rail
class VooRailSearchBar extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  /// Whether the rail is extended
  final bool extended;

  const VooRailSearchBar({
    super.key,
    required this.config,
    required this.extended,
  });

  /// Factory method to create search bar for a specific position
  /// Returns null if search bar is not configured for that position
  static Widget? forPosition({
    required BuildContext context,
    required VooNavigationConfig config,
    required bool extended,
    required VooSearchBarPosition position,
  }) {
    final searchConfig = config.searchBar;
    if (searchConfig == null || config.searchBarPosition != position) {
      return null;
    }

    // In compact mode, show search icon button that expands
    if (!extended) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: IconButton(
          icon: const Icon(Icons.search, size: 20),
          tooltip: searchConfig.hintText ?? 'Search...',
          onPressed: () {
            _showSearchOverlay(context, config, searchConfig);
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: VooSearchBar(
        navigationItems: searchConfig.navigationItems ?? config.items,
        onFilteredItemsChanged: searchConfig.onFilteredItemsChanged,
        onSearch: searchConfig.onSearch,
        onSearchSubmit: searchConfig.onSearchSubmit,
        searchActions: searchConfig.searchActions,
        hintText: searchConfig.hintText ?? 'Search...',
        showFilteredResults: searchConfig.showFilteredResults,
        enableKeyboardShortcut: searchConfig.enableKeyboardShortcut,
        keyboardShortcutHint: searchConfig.keyboardShortcutHint,
        style: searchConfig.style,
        expanded: true,
        onNavigationItemSelected: searchConfig.onNavigationItemSelected,
        onSearchActionSelected: searchConfig.onSearchActionSelected,
      ),
    );
  }

  static void _showSearchOverlay(
    BuildContext context,
    VooNavigationConfig config,
    VooSearchBarConfig searchConfig,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: VooSearchBar(
              navigationItems: searchConfig.navigationItems ?? config.items,
              onFilteredItemsChanged: searchConfig.onFilteredItemsChanged,
              onSearch: searchConfig.onSearch,
              onSearchSubmit: searchConfig.onSearchSubmit,
              searchActions: searchConfig.searchActions,
              hintText: searchConfig.hintText ?? 'Search...',
              showFilteredResults: searchConfig.showFilteredResults,
              enableKeyboardShortcut: false,
              style: searchConfig.style,
              expanded: true,
              onNavigationItemSelected: (item) {
                Navigator.of(context).pop();
                searchConfig.onNavigationItemSelected?.call(item);
              },
              onSearchActionSelected: (action) {
                Navigator.of(context).pop();
                searchConfig.onSearchActionSelected?.call(action);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return forPosition(
          context: context,
          config: config,
          extended: extended,
          position: config.searchBarPosition,
        ) ??
        const SizedBox.shrink();
  }
}
