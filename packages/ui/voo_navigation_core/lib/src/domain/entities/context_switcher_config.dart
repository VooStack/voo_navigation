import 'package:flutter/widgets.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_item.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';

/// Callback that builds navigation items based on the selected context.
///
/// This is the key feature of the context switcher - when the context changes,
/// this callback is invoked to get the new navigation items for that context.
typedef VooContextItemsBuilder = List<VooNavigationItem> Function(
    VooContextItem? context);

/// Configuration for the context switcher component.
///
/// The context switcher allows users to switch between contexts (projects,
/// workspaces, environments) and dynamically changes the navigation items
/// based on the selected context.
///
/// Example usage:
/// ```dart
/// VooContextSwitcherConfig(
///   items: projects,
///   selectedItem: currentProject,
///   onContextChanged: (project) => setState(() => currentProject = project),
///   itemsBuilder: (project) => getItemsForProject(project),
///   sectionTitle: 'Projects',
///   showSearch: true,
///   onCreateContext: () => showCreateProjectDialog(),
///   createContextLabel: 'New Project',
/// )
/// ```
class VooContextSwitcherConfig {
  // ============================================================================
  // CONTEXT DATA
  // ============================================================================

  /// List of contexts available for switching
  final List<VooContextItem> items;

  /// Currently selected context
  final VooContextItem? selectedItem;

  /// Callback when a context is selected
  final ValueChanged<VooContextItem>? onContextChanged;

  /// Callback to create a new context
  final VoidCallback? onCreateContext;

  /// Label for the create context button (e.g., "New Project", "Add Workspace")
  final String? createContextLabel;

  // ============================================================================
  // DYNAMIC NAVIGATION ITEMS
  // ============================================================================

  /// Builder function that returns navigation items for the selected context.
  ///
  /// When a context is selected, this builder is called with the new context
  /// and the returned items replace the current navigation items.
  ///
  /// Example:
  /// ```dart
  /// itemsBuilder: (project) {
  ///   if (project == null) return [VooNavigationItem(...)];
  ///   return [
  ///     VooNavigationItem(id: 'overview', label: 'Overview', route: '/projects/${project.id}/overview'),
  ///     VooNavigationItem(id: 'tasks', label: 'Tasks', route: '/projects/${project.id}/tasks'),
  ///   ];
  /// }
  /// ```
  final VooContextItemsBuilder? itemsBuilder;

  // ============================================================================
  // DISPLAY OPTIONS
  // ============================================================================

  /// Title for the context section in the modal (e.g., "Projects", "Workspaces")
  final String? sectionTitle;

  /// Whether to show the search field in the modal
  final bool showSearch;

  /// Hint text for the search field
  final String? searchHint;

  /// Placeholder text when no context is selected
  final String? placeholder;

  // ============================================================================
  // STYLING
  // ============================================================================

  /// Custom style configuration
  final VooContextSwitcherStyle? style;

  /// Whether to show in compact mode (icon/avatar only)
  /// When null, auto-detects from VooCollapseState in widget tree.
  final bool? compact;

  /// Tooltip text when hovering over the card
  final String? tooltip;

  // ============================================================================
  // MOBILE NAV ITEM OPTIONS
  // ============================================================================

  /// Whether to show as a navigation item in rail/bottom nav.
  /// When true, the context switcher appears as a nav item with the current
  /// context's avatar instead of as a card widget.
  final bool showAsNavItem;

  /// Whether to include in mobile bottom navigation (max 5 items).
  /// Only relevant when [showAsNavItem] is true.
  final bool mobilePriority;

  /// Sort order for nav item positioning in mobile bottom navigation.
  /// Lower values appear first. Only relevant when [showAsNavItem] is true.
  final int navItemSortOrder;

  /// Label for the nav item. Defaults to selected context name or [placeholder].
  final String? navItemLabel;

  // ============================================================================
  // CUSTOM BUILDERS
  // ============================================================================

  /// Custom builder for the card (closed state).
  /// When provided, completely overrides the default card UI.
  final Widget Function(BuildContext context, VooContextSwitcherCardData data)?
      cardBuilder;

  /// Custom builder for the modal (open state).
  /// When provided, completely overrides the default modal UI.
  final Widget Function(BuildContext context, VooContextSwitcherModalData data)?
      modalBuilder;

  /// Custom builder for individual context items in the list.
  final Widget Function(
          BuildContext context, VooContextItem item, bool isSelected)?
      itemBuilder;

  const VooContextSwitcherConfig({
    required this.items,
    this.selectedItem,
    this.onContextChanged,
    this.onCreateContext,
    this.createContextLabel,
    this.itemsBuilder,
    this.sectionTitle,
    this.showSearch = false,
    this.searchHint,
    this.placeholder,
    this.style,
    this.compact,
    this.tooltip,
    this.showAsNavItem = false,
    this.mobilePriority = false,
    this.navItemSortOrder = 0,
    this.navItemLabel,
    this.cardBuilder,
    this.modalBuilder,
    this.itemBuilder,
  });

  /// Creates a copy with the given fields replaced
  VooContextSwitcherConfig copyWith({
    List<VooContextItem>? items,
    VooContextItem? selectedItem,
    ValueChanged<VooContextItem>? onContextChanged,
    VoidCallback? onCreateContext,
    String? createContextLabel,
    VooContextItemsBuilder? itemsBuilder,
    String? sectionTitle,
    bool? showSearch,
    String? searchHint,
    String? placeholder,
    VooContextSwitcherStyle? style,
    bool? compact,
    String? tooltip,
    bool? showAsNavItem,
    bool? mobilePriority,
    int? navItemSortOrder,
    String? navItemLabel,
    Widget Function(BuildContext context, VooContextSwitcherCardData data)?
        cardBuilder,
    Widget Function(BuildContext context, VooContextSwitcherModalData data)?
        modalBuilder,
    Widget Function(BuildContext context, VooContextItem item, bool isSelected)?
        itemBuilder,
  }) =>
      VooContextSwitcherConfig(
        items: items ?? this.items,
        selectedItem: selectedItem ?? this.selectedItem,
        onContextChanged: onContextChanged ?? this.onContextChanged,
        onCreateContext: onCreateContext ?? this.onCreateContext,
        createContextLabel: createContextLabel ?? this.createContextLabel,
        itemsBuilder: itemsBuilder ?? this.itemsBuilder,
        sectionTitle: sectionTitle ?? this.sectionTitle,
        showSearch: showSearch ?? this.showSearch,
        searchHint: searchHint ?? this.searchHint,
        placeholder: placeholder ?? this.placeholder,
        style: style ?? this.style,
        compact: compact ?? this.compact,
        tooltip: tooltip ?? this.tooltip,
        showAsNavItem: showAsNavItem ?? this.showAsNavItem,
        mobilePriority: mobilePriority ?? this.mobilePriority,
        navItemSortOrder: navItemSortOrder ?? this.navItemSortOrder,
        navItemLabel: navItemLabel ?? this.navItemLabel,
        cardBuilder: cardBuilder ?? this.cardBuilder,
        modalBuilder: modalBuilder ?? this.modalBuilder,
        itemBuilder: itemBuilder ?? this.itemBuilder,
      );
}

/// Data passed to custom card builder.
///
/// This class provides all the information needed to build a custom card
/// for the context switcher's closed state.
class VooContextSwitcherCardData {
  /// Currently selected context
  final VooContextItem? selectedItem;

  /// Whether the modal is currently expanded
  final bool isExpanded;

  /// Callback to toggle the modal open/closed
  final VoidCallback onTap;

  /// Placeholder text when no context is selected
  final String? placeholder;

  const VooContextSwitcherCardData({
    this.selectedItem,
    required this.isExpanded,
    required this.onTap,
    this.placeholder,
  });
}

/// Data passed to custom modal builder.
///
/// This class provides all the information needed to build a custom modal
/// for the context switcher's open state.
class VooContextSwitcherModalData {
  /// List of available contexts
  final List<VooContextItem> items;

  /// Currently selected context
  final VooContextItem? selectedItem;

  /// Callback to close the modal
  final VoidCallback onClose;

  /// Callback when a context is selected
  final ValueChanged<VooContextItem> onContextSelected;

  /// Callback to create a new context
  final VoidCallback? onCreateContext;

  /// Label for the create button
  final String? createContextLabel;

  /// Section title
  final String? sectionTitle;

  /// Current search query
  final String searchQuery;

  /// Callback when search query changes
  final ValueChanged<String> onSearchChanged;

  const VooContextSwitcherModalData({
    required this.items,
    this.selectedItem,
    required this.onClose,
    required this.onContextSelected,
    this.onCreateContext,
    this.createContextLabel,
    this.sectionTitle,
    required this.searchQuery,
    required this.onSearchChanged,
  });
}
