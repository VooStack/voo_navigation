import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';
import 'package:voo_navigation_core/src/presentation/molecules/voo_search_bar.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Search bar widget for the navigation drawer
class VooDrawerSearchBar extends StatelessWidget {
  /// Navigation configuration
  final VooNavigationConfig config;

  const VooDrawerSearchBar({super.key, required this.config});

  /// Factory method to create search bar for a specific position
  /// Returns null if search bar is not configured for that position
  static Widget? forPosition({
    required BuildContext context,
    required VooNavigationConfig config,
    required VooSearchBarPosition position,
  }) {
    final searchConfig = config.searchBar;
    if (searchConfig == null || config.searchBarPosition != position) {
      return null;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.vooSpacing.sm, vertical: context.vooSpacing.xs),
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

  @override
  Widget build(BuildContext context) {
    return forPosition(
          context: context,
          config: config,
          position: config.searchBarPosition,
        ) ??
        const SizedBox.shrink();
  }
}
