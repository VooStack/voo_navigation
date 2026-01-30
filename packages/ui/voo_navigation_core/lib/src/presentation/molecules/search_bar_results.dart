import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';
import 'package:voo_navigation_core/src/presentation/molecules/search_bar_result_item.dart';
import 'package:voo_navigation_core/src/presentation/molecules/search_bar_section_header.dart';

/// Search bar results dropdown content
class VooSearchBarResults extends StatelessWidget {
  /// Style configuration
  final VooSearchBarStyle style;

  /// Current search query
  final String query;

  /// Whether to show recent searches section
  final bool showRecentSection;

  /// List of recent searches
  final List<String>? recentSearches;

  /// Filtered navigation items
  final List<VooNavigationDestination> filteredNavItems;

  /// Filtered search actions
  final List<VooSearchAction> filteredActions;

  /// Currently selected index
  final int selectedIndex;

  /// Callback to clear recent searches
  final VoidCallback? onClearRecentSearches;

  /// Callback when a recent search is selected
  final ValueChanged<String> onRecentSearchSelected;

  /// Callback when a navigation item is selected
  final ValueChanged<VooNavigationDestination> onNavigationItemSelected;

  /// Callback when a search action is selected
  final ValueChanged<VooSearchAction> onSearchActionSelected;

  /// Custom builder for filtered items
  final Widget Function(VooNavigationDestination, VoidCallback onTap)? filteredItemBuilder;

  /// Custom builder for actions
  final Widget Function(VooSearchAction, VoidCallback onTap)? actionBuilder;

  const VooSearchBarResults({
    super.key,
    required this.style,
    required this.query,
    required this.showRecentSection,
    this.recentSearches,
    required this.filteredNavItems,
    required this.filteredActions,
    required this.selectedIndex,
    this.onClearRecentSearches,
    required this.onRecentSearchSelected,
    required this.onNavigationItemSelected,
    required this.onSearchActionSelected,
    this.filteredItemBuilder,
    this.actionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Recent searches
        if (showRecentSection) ...[
          VooSearchBarSectionHeader(
            title: 'Recent',
            trailing: TextButton(
              onPressed: onClearRecentSearches,
              child: Text(
                'Clear',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          ...recentSearches!.asMap().entries.map((entry) {
            final index = entry.key;
            final search = entry.value;
            return VooSearchBarResultItem(
              style: style,
              icon: Icons.history,
              label: search,
              isSelected: index == selectedIndex,
              onTap: () => onRecentSearchSelected(search),
            );
          }),
          if (filteredNavItems.isNotEmpty || filteredActions.isNotEmpty)
            const Divider(height: 16),
        ],

        // Navigation items
        if (filteredNavItems.isNotEmpty) ...[
          const VooSearchBarSectionHeader(title: 'Navigation'),
          ...filteredNavItems.asMap().entries.map((entry) {
            final offsetIndex = showRecentSection
                ? (recentSearches?.length ?? 0) + entry.key
                : entry.key;
            final item = entry.value;

            if (filteredItemBuilder != null) {
              return filteredItemBuilder!(
                item,
                () => onNavigationItemSelected(item),
              );
            }

            return VooSearchBarResultItem(
              style: style,
              icon: item.icon,
              label: item.label,
              subtitle: item.route,
              isSelected: offsetIndex == selectedIndex,
              onTap: () => onNavigationItemSelected(item),
            );
          }),
          if (filteredActions.isNotEmpty) const Divider(height: 16),
        ],

        // Search actions
        if (filteredActions.isNotEmpty) ...[
          const VooSearchBarSectionHeader(title: 'Actions'),
          ...filteredActions.asMap().entries.map((entry) {
            final offsetIndex =
                (showRecentSection ? (recentSearches?.length ?? 0) : 0) +
                    filteredNavItems.length +
                    entry.key;
            final action = entry.value;

            if (action.isDivider) {
              return const Divider(height: 8);
            }

            if (actionBuilder != null) {
              return actionBuilder!(
                action,
                () => onSearchActionSelected(action),
              );
            }

            return VooSearchBarResultItem(
              style: style,
              icon: action.icon,
              iconWidget: action.iconWidget,
              label: action.label,
              subtitle: action.description,
              shortcut: action.shortcut,
              isSelected: offsetIndex == selectedIndex,
              onTap: () => onSearchActionSelected(action),
            );
          }),
        ],

        // Empty state
        if (query.isNotEmpty && filteredNavItems.isEmpty && filteredActions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No results found for "$query"',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
