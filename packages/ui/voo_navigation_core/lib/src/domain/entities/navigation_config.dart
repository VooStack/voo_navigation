import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/action_navigation_item.dart';
import 'package:voo_navigation_core/src/domain/entities/animation_config.dart';
import 'package:voo_navigation_core/src/domain/entities/body_card_config.dart';
import 'package:voo_navigation_core/src/domain/entities/breadcrumb_item.dart';
import 'package:voo_navigation_core/src/domain/entities/fab_config.dart';
import 'package:voo_navigation_core/src/domain/entities/breakpoint.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/content_area_config.dart';
import 'package:voo_navigation_core/src/domain/entities/context_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/drawer_slots.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_config.dart';
import 'package:voo_navigation_core/src/domain/entities/multi_switcher_style.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_destination.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_section.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_type.dart';
import 'package:voo_navigation_core/src/domain/entities/notification_item.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';
import 'package:voo_navigation_core/src/domain/entities/user_profile_config.dart';

/// Configuration for the adaptive navigation system
class VooNavigationConfig {
  /// List of navigation items to display
  final List<VooNavigationDestination> items;

  /// Currently selected navigation item ID
  final String? selectedId;

  /// Custom breakpoints (defaults to Material 3 breakpoints)
  final List<VooBreakpoint> breakpoints;

  /// Whether to automatically select navigation type based on screen size
  final bool isAdaptive;

  /// Force a specific navigation type (overrides adaptive behavior)
  final VooNavigationType? forcedNavigationType;

  /// Theme data for styling
  final ThemeData? theme;

  /// Whether to show labels in navigation rail
  final NavigationRailLabelType railLabelType;

  /// Whether to use extended navigation rail when possible
  final bool useExtendedRail;

  /// Customization slots for the navigation drawer/rail (header, trailing,
  /// footer). All three are optional. When null, the default header built
  /// from [headerConfig] is used.
  ///
  /// **2.0 note**: this replaces the three individual fields
  /// `drawerHeader`, `drawerHeaderTrailing`, `drawerFooter`.
  final VooDrawerSlots? drawerSlots;

  /// Simplified header configuration
  final VooHeaderConfig? headerConfig;

  /// Whether the app bar should be positioned alongside the navigation rail
  final bool appBarAlongsideRail;

  /// Whether to show the app bar
  final bool showAppBar;

  /// Whether to resize scaffold to avoid bottom inset (keyboard)
  final bool resizeToAvoidBottomInset;

  /// Whether to extend body behind bottom navigation
  final bool extendBody;

  /// Whether to extend body behind app bar
  final bool extendBodyBehindAppBar;

  /// Padding to apply to the body content
  final EdgeInsetsGeometry? bodyPadding;

  /// Configures whether the body is wrapped in a card and how it's styled.
  /// Pass `null` (the default) to render the body without a card wrapper.
  ///
  /// **2.0 note**: this replaces the four individual fields `useBodyCard`,
  /// `bodyCardElevation`, `bodyCardBorderRadius`, `bodyCardColor`, which
  /// were removed in this major.
  final VooBodyCardConfig? bodyCard;

  /// Floating action button configuration.
  ///
  /// Pass `null` (the default) for no FAB. Pass [VooFabConfig.hidden] to
  /// suppress a FAB that would otherwise be injected by a page config or
  /// page-level override.
  ///
  /// **2.0 note**: this replaces the four individual fields
  /// `floatingActionButton`, `floatingActionButtonLocation`,
  /// `floatingActionButtonAnimator`, `showFloatingActionButton`.
  final VooFabConfig? fab;

  /// Background color for the scaffold (the outer-most surface).
  final Color? backgroundColor;

  // ---------------------------------------------------------------------------
  // **2.0 note**: the six fields `navigationBackgroundColor`,
  // `selectedItemColor`, `unselectedItemColor`, `indicatorColor`,
  // `indicatorShape`, and `elevation` were removed in this major.
  //
  // Use [navigationTheme] to override these — `VooNavigationTheme` now
  // exposes all six (as `surfaceColor`, `selectedItemColor`,
  // `unselectedItemColor`, `indicatorColor`, `indicatorShape`, and
  // `elevation`).
  // ---------------------------------------------------------------------------

  /// Whether to show divider in navigation rail
  final bool showNavigationRailDivider;

  /// Custom navigation rail width
  final double? navigationRailWidth;

  /// Navigation rail margin
  final double navigationRailMargin;

  /// Margin around the navigation drawer
  final EdgeInsets? drawerMargin;

  /// Content area styling (margin, border radius, background color).
  ///
  /// **2.0 note**: this replaces the three individual fields
  /// `contentAreaMargin`, `contentAreaBorderRadius`,
  /// `contentAreaBackgroundColor`.
  final VooContentAreaConfig? contentArea;

  /// Custom extended navigation rail width
  final double? extendedNavigationRailWidth;

  /// Custom navigation drawer width
  final double? navigationDrawerWidth;

  /// Motion configuration for transitions, hover effects, and badges.
  ///
  /// Defaults to a sensible Linear/Vercel-style motion config
  /// ([VooMinimal.motionNormal] + [VooMinimal.motionCurve]). Pass
  /// [VooAnimationConfig.disabled] to suppress animations entirely.
  ///
  /// **2.0 note**: this replaces the four individual fields
  /// `animationDuration`, `animationCurve`, `enableAnimations`,
  /// `badgeAnimationDuration`.
  final VooAnimationConfig animation;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  /// Custom transition builder for navigation animations
  final Widget Function(Widget child, Animation<double> animation)?
      transitionBuilder;

  /// Callback when navigation item is selected
  final void Function(String itemId)? onNavigationItemSelected;

  /// Whether to persist navigation state
  final bool persistNavigationState;

  /// Custom scroll controller for navigation drawer
  final ScrollController? drawerScrollController;

  /// Whether to show notification badge
  final bool showNotificationBadges;

  /// Whether to group items by sections
  final bool groupItemsBySections;

  /// Navigation sections for organized grouping of items
  final List<VooNavigationSection>? sections;

  /// Footer items displayed at the bottom of the navigation rail/drawer
  final List<VooNavigationDestination>? footerItems;

  /// Callback when the navigation collapse state changes
  final void Function(bool isCollapsed)? onCollapseChanged;

  /// Custom empty state widget
  final Widget? emptyStateWidget;

  /// Custom error widget
  final Widget Function(Object error)? errorBuilder;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Whether to use floating style for bottom navigation
  final bool floatingBottomNav;

  /// Horizontal margin for floating bottom navigation
  final double? floatingBottomNavMargin;

  /// Action item configuration for bottom navigation.
  ///
  /// This creates a special button (e.g., plus button) that opens a modal
  /// with custom content when tapped.
  final VooActionNavigationItem? actionItem;

  /// Whether to show user profile in drawer/rail footer
  final bool showUserProfile;

  /// User profile widget for drawer/rail footer
  final Widget? userProfileWidget;

  /// Configuration for user profile in drawer/rail footer
  final VooUserProfileConfig? userProfileConfig;

  /// Whether the rail/drawer supports collapsing
  final bool enableCollapsibleRail;

  /// Custom collapse toggle builder
  final Widget Function(bool isExpanded, VoidCallback onToggle)?
      collapseToggleBuilder;

  /// Visual theme for navigation styling
  final VooNavigationTheme? navigationTheme;

  /// Whether the mobile bottom nav should expose a hamburger button that opens
  /// a navigation Drawer listing all items.
  ///
  /// When true, [VooMobileScaffold] attaches a [Scaffold.drawer] and
  /// [VooNavigationBar] prepends a hamburger pill that opens it.
  final bool showHamburgerMenu;

  /// Optional builder for the Drawer body shown when the hamburger is tapped.
  ///
  /// If null and [showHamburgerMenu] is true, the default
  /// `VooMobileNavigationDrawer` is rendered listing every visible item and
  /// honoring [VooNavigationDestination] divider items as section breaks.
  final Widget Function(BuildContext context)? mobileDrawerBuilder;

  /// Gets the effective theme
  VooNavigationTheme get effectiveTheme =>
      navigationTheme ?? const VooNavigationTheme();

  // ============================================================================
  // COMMON NAVIGATION COMPONENTS
  // ============================================================================

  /// Organization switcher configuration
  final VooOrganizationSwitcherConfig? organizationSwitcher;

  /// Position of the organization switcher
  final VooOrganizationSwitcherPosition organizationSwitcherPosition;

  /// Search bar configuration
  final VooSearchBarConfig? searchBar;

  /// Position of the search bar
  final VooSearchBarPosition searchBarPosition;

  /// Notifications bell configuration
  final VooNotificationsBellConfig? notificationsBell;

  /// Quick actions menu configuration
  final VooQuickActionsConfig? quickActions;

  /// Position of the quick actions menu
  final VooQuickActionsPosition quickActionsPosition;

  /// Breadcrumbs configuration
  final VooBreadcrumbsConfig? breadcrumbs;

  /// Whether to show breadcrumbs in the app bar
  final bool showBreadcrumbsInAppBar;

  /// Multi-switcher configuration (replaces org switcher + user profile when set)
  final VooMultiSwitcherConfig? multiSwitcher;

  /// Position of the multi-switcher
  final VooMultiSwitcherPosition multiSwitcherPosition;

  /// Context switcher configuration for switching between contexts (projects, workspaces, etc.)
  final VooContextSwitcherConfig? contextSwitcher;

  /// Position of the context switcher
  final VooContextSwitcherPosition contextSwitcherPosition;

  /// Convenience factory for the most common case: a flat list of items
  /// plus a selection callback.
  ///
  /// All other options use their defaults. Use the main constructor when
  /// you need header, switchers, search bar, or any other customization.
  ///
  /// Example:
  /// ```dart
  /// VooAdaptiveScaffold(
  ///   config: VooNavigationConfig.simple(
  ///     items: items,
  ///     selectedId: _selectedId,
  ///     onItemSelected: (id) => setState(() => _selectedId = id),
  ///   ),
  ///   body: ...,
  /// )
  /// ```
  factory VooNavigationConfig.simple({
    required List<VooNavigationDestination> items,
    required ValueChanged<String> onItemSelected,
    String? selectedId,
    VooHeaderConfig? header,
    List<VooNavigationDestination>? footerItems,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onItemSelected,
      headerConfig: header,
      footerItems: footerItems,
    );
  }

  /// Convenience factory for the "app shell" case: items + header +
  /// org/user multi-switcher + search bar — the shape used by most
  /// product apps.
  ///
  /// All extra customization is still available via the main constructor.
  factory VooNavigationConfig.appShell({
    required List<VooNavigationDestination> items,
    required ValueChanged<String> onItemSelected,
    required VooHeaderConfig header,
    required VooMultiSwitcherConfig multiSwitcher,
    String? selectedId,
    VooSearchBarConfig? searchBar,
    List<VooNavigationDestination>? footerItems,
    VooNavigationTheme? navigationTheme,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onItemSelected,
      headerConfig: header,
      footerItems: footerItems,
      multiSwitcher: multiSwitcher,
      multiSwitcherPosition: VooMultiSwitcherPosition.footer,
      searchBar: searchBar,
      searchBarPosition: VooSearchBarPosition.header,
      navigationTheme: navigationTheme,
      // Sensible defaults for an app shell
      enableCollapsibleRail: true,
      showUserProfile: false, // the multi-switcher replaces this
    );
  }

  VooNavigationConfig({
    required this.items,
    this.selectedId,
    List<VooBreakpoint>? breakpoints,
    this.isAdaptive = true,
    this.forcedNavigationType,
    this.theme,
    this.railLabelType = NavigationRailLabelType.selected,
    this.useExtendedRail = true,
    this.drawerSlots,
    this.headerConfig,
    this.appBarAlongsideRail = true,
    this.showAppBar = true,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.bodyPadding,
    this.bodyCard,
    this.fab,
    this.backgroundColor,
    this.showNavigationRailDivider = true,
    this.navigationRailWidth,
    this.extendedNavigationRailWidth,
    this.navigationDrawerWidth,
    this.animation = const VooAnimationConfig(),
    this.enableHapticFeedback = true,
    this.transitionBuilder,
    this.onNavigationItemSelected,
    this.persistNavigationState = true,
    this.drawerScrollController,
    this.showNotificationBadges = true,
    this.groupItemsBySections = false,
    this.sections,
    this.footerItems,
    this.onCollapseChanged,
    this.emptyStateWidget,
    this.errorBuilder,
    this.loadingWidget,
    this.floatingBottomNav = true,
    this.floatingBottomNavMargin,
    this.actionItem,
    this.showUserProfile = true,
    this.userProfileWidget,
    this.userProfileConfig,
    this.enableCollapsibleRail = true,
    this.collapseToggleBuilder,
    this.navigationTheme,
    this.navigationRailMargin = 0,
    this.drawerMargin,
    this.contentArea,
    this.organizationSwitcher,
    this.organizationSwitcherPosition = VooOrganizationSwitcherPosition.header,
    this.searchBar,
    this.searchBarPosition = VooSearchBarPosition.header,
    this.notificationsBell,
    this.quickActions,
    this.quickActionsPosition = VooQuickActionsPosition.fab,
    this.breadcrumbs,
    this.showBreadcrumbsInAppBar = true,
    this.multiSwitcher,
    this.multiSwitcherPosition = VooMultiSwitcherPosition.footer,
    this.contextSwitcher,
    this.contextSwitcherPosition = VooContextSwitcherPosition.beforeItems,
    this.showHamburgerMenu = false,
    this.mobileDrawerBuilder,
  }) : breakpoints = breakpoints ?? VooBreakpoint.material3Breakpoints,
       assert(
         onNavigationItemSelected != null || _allItemsHaveNavigation(items),
         'When onNavigationItemSelected is not provided, each navigation item must have '
         'either a route, destination, onTap callback, or children',
       );

  /// Checks if all items (and their children) have navigation defined
  static bool _allItemsHaveNavigation(List<VooNavigationDestination> items) {
    for (final item in items) {
      // Skip dividers - they don't need navigation
      if (item.isDivider) continue;

      final hasNavigation = item.route != null ||
          item.destination != null ||
          item.onTap != null ||
          item.children != null;

      if (!hasNavigation) return false;

      // Recursively check children
      if (item.children != null && !_allItemsHaveNavigation(item.children!)) {
        return false;
      }
    }
    return true;
  }

  /// Creates a copy of this configuration with the given fields replaced
  VooNavigationConfig copyWith({
    List<VooNavigationDestination>? items,
    String? selectedId,
    List<VooBreakpoint>? breakpoints,
    bool? isAdaptive,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType? railLabelType,
    bool? useExtendedRail,
    VooDrawerSlots? drawerSlots,
    VooHeaderConfig? headerConfig,
    bool? appBarAlongsideRail,
    bool? showAppBar,
    bool? resizeToAvoidBottomInset,
    bool? extendBody,
    bool? extendBodyBehindAppBar,
    EdgeInsetsGeometry? bodyPadding,
    VooBodyCardConfig? bodyCard,
    VooFabConfig? fab,
    Color? backgroundColor,
    bool? showNavigationRailDivider,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    VooAnimationConfig? animation,
    bool? enableHapticFeedback,
    Widget Function(Widget child, Animation<double> animation)?
        transitionBuilder,
    void Function(String itemId)? onNavigationItemSelected,
    bool? persistNavigationState,
    ScrollController? drawerScrollController,
    bool? showNotificationBadges,
    bool? groupItemsBySections,
    List<VooNavigationSection>? sections,
    List<VooNavigationDestination>? footerItems,
    void Function(bool isCollapsed)? onCollapseChanged,
    Widget? emptyStateWidget,
    Widget Function(Object error)? errorBuilder,
    Widget? loadingWidget,
    bool? floatingBottomNav,
    double? floatingBottomNavMargin,
    VooActionNavigationItem? actionItem,
    bool? showUserProfile,
    Widget? userProfileWidget,
    VooUserProfileConfig? userProfileConfig,
    bool? enableCollapsibleRail,
    Widget Function(bool isExpanded, VoidCallback onToggle)?
        collapseToggleBuilder,
    VooNavigationTheme? navigationTheme,
    double? navigationRailMargin,
    EdgeInsets? drawerMargin,
    VooContentAreaConfig? contentArea,
    VooOrganizationSwitcherConfig? organizationSwitcher,
    VooOrganizationSwitcherPosition? organizationSwitcherPosition,
    VooSearchBarConfig? searchBar,
    VooSearchBarPosition? searchBarPosition,
    VooNotificationsBellConfig? notificationsBell,
    VooQuickActionsConfig? quickActions,
    VooQuickActionsPosition? quickActionsPosition,
    VooBreadcrumbsConfig? breadcrumbs,
    bool? showBreadcrumbsInAppBar,
    VooMultiSwitcherConfig? multiSwitcher,
    VooMultiSwitcherPosition? multiSwitcherPosition,
    VooContextSwitcherConfig? contextSwitcher,
    VooContextSwitcherPosition? contextSwitcherPosition,
    bool? showHamburgerMenu,
    Widget Function(BuildContext context)? mobileDrawerBuilder,
  }) =>
      VooNavigationConfig(
        items: items ?? this.items,
        selectedId: selectedId ?? this.selectedId,
        breakpoints: breakpoints ?? this.breakpoints,
        isAdaptive: isAdaptive ?? this.isAdaptive,
        forcedNavigationType: forcedNavigationType ?? this.forcedNavigationType,
        theme: theme ?? this.theme,
        railLabelType: railLabelType ?? this.railLabelType,
        useExtendedRail: useExtendedRail ?? this.useExtendedRail,
        drawerSlots: drawerSlots ?? this.drawerSlots,
        headerConfig: headerConfig ?? this.headerConfig,
        appBarAlongsideRail: appBarAlongsideRail ?? this.appBarAlongsideRail,
        showAppBar: showAppBar ?? this.showAppBar,
        resizeToAvoidBottomInset:
            resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
        extendBody: extendBody ?? this.extendBody,
        extendBodyBehindAppBar:
            extendBodyBehindAppBar ?? this.extendBodyBehindAppBar,
        bodyPadding: bodyPadding ?? this.bodyPadding,
        bodyCard: bodyCard ?? this.bodyCard,
        fab: fab ?? this.fab,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        showNavigationRailDivider:
            showNavigationRailDivider ?? this.showNavigationRailDivider,
        navigationRailWidth: navigationRailWidth ?? this.navigationRailWidth,
        extendedNavigationRailWidth:
            extendedNavigationRailWidth ?? this.extendedNavigationRailWidth,
        navigationDrawerWidth:
            navigationDrawerWidth ?? this.navigationDrawerWidth,
        animation: animation ?? this.animation,
        enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
        transitionBuilder: transitionBuilder ?? this.transitionBuilder,
        onNavigationItemSelected:
            onNavigationItemSelected ?? this.onNavigationItemSelected,
        persistNavigationState:
            persistNavigationState ?? this.persistNavigationState,
        drawerScrollController:
            drawerScrollController ?? this.drawerScrollController,
        showNotificationBadges:
            showNotificationBadges ?? this.showNotificationBadges,
        groupItemsBySections: groupItemsBySections ?? this.groupItemsBySections,
        sections: sections ?? this.sections,
        footerItems: footerItems ?? this.footerItems,
        onCollapseChanged: onCollapseChanged ?? this.onCollapseChanged,
        emptyStateWidget: emptyStateWidget ?? this.emptyStateWidget,
        errorBuilder: errorBuilder ?? this.errorBuilder,
        loadingWidget: loadingWidget ?? this.loadingWidget,
        floatingBottomNav: floatingBottomNav ?? this.floatingBottomNav,
        floatingBottomNavMargin:
            floatingBottomNavMargin ?? this.floatingBottomNavMargin,
        actionItem: actionItem ?? this.actionItem,
        showUserProfile: showUserProfile ?? this.showUserProfile,
        userProfileWidget: userProfileWidget ?? this.userProfileWidget,
        userProfileConfig: userProfileConfig ?? this.userProfileConfig,
        enableCollapsibleRail:
            enableCollapsibleRail ?? this.enableCollapsibleRail,
        collapseToggleBuilder:
            collapseToggleBuilder ?? this.collapseToggleBuilder,
        navigationTheme: navigationTheme ?? this.navigationTheme,
        navigationRailMargin: navigationRailMargin ?? this.navigationRailMargin,
        drawerMargin: drawerMargin ?? this.drawerMargin,
        contentArea: contentArea ?? this.contentArea,
        organizationSwitcher: organizationSwitcher ?? this.organizationSwitcher,
        organizationSwitcherPosition:
            organizationSwitcherPosition ?? this.organizationSwitcherPosition,
        searchBar: searchBar ?? this.searchBar,
        searchBarPosition: searchBarPosition ?? this.searchBarPosition,
        notificationsBell: notificationsBell ?? this.notificationsBell,
        quickActions: quickActions ?? this.quickActions,
        quickActionsPosition: quickActionsPosition ?? this.quickActionsPosition,
        breadcrumbs: breadcrumbs ?? this.breadcrumbs,
        showBreadcrumbsInAppBar:
            showBreadcrumbsInAppBar ?? this.showBreadcrumbsInAppBar,
        multiSwitcher: multiSwitcher ?? this.multiSwitcher,
        multiSwitcherPosition:
            multiSwitcherPosition ?? this.multiSwitcherPosition,
        contextSwitcher: contextSwitcher ?? this.contextSwitcher,
        contextSwitcherPosition:
            contextSwitcherPosition ?? this.contextSwitcherPosition,
        showHamburgerMenu: showHamburgerMenu ?? this.showHamburgerMenu,
        mobileDrawerBuilder: mobileDrawerBuilder ?? this.mobileDrawerBuilder,
      );

  /// Gets the current navigation type based on screen width
  VooNavigationType getNavigationType(double screenWidth) {
    if (!isAdaptive || forcedNavigationType != null) {
      return forcedNavigationType ?? VooNavigationType.bottomNavigation;
    }

    final breakpoint = VooBreakpoint.fromWidth(screenWidth, breakpoints);
    return breakpoint.navigationType;
  }

  /// Gets visible navigation items
  List<VooNavigationDestination> get visibleItems =>
      items.where((item) => item.isVisible).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  /// Gets mobile priority navigation items (max 5 items for bottom navigation)
  List<VooNavigationDestination> get mobilePriorityItems {
    final priorityItems = <VooNavigationDestination>[];

    // Add context switcher as nav item if configured with mobilePriority
    if (contextSwitcher != null &&
        contextSwitcher!.showAsNavItem &&
        contextSwitcher!.mobilePriority &&
        contextSwitcherPosition == VooContextSwitcherPosition.asNavItem) {
      priorityItems.add(_createContextSwitcherNavItem());
    }

    // Add multi-switcher as nav item if configured with mobilePriority
    // Note: Unlike context switcher, multi-switcher shows in mobile nav regardless
    // of its desktop position (header/footer/asNavItem) when mobilePriority is true
    if (multiSwitcher != null &&
        multiSwitcher!.showAsNavItem &&
        multiSwitcher!.mobilePriority) {
      priorityItems.add(_createMultiSwitcherNavItem());
    }

    // Add user profile as nav item if configured with mobilePriority
    if (userProfileConfig != null && userProfileConfig!.mobilePriority) {
      priorityItems.add(_createUserProfileNavItem());
    }

    for (final item in items) {
      if (item.isVisible && item.mobilePriority) {
        priorityItems.add(item);
      }
      if (item.hasChildren && item.children != null) {
        for (final child in item.children!) {
          if (child.isVisible && child.mobilePriority) {
            priorityItems.add(child);
          }
        }
      }
    }

    if (priorityItems.isEmpty) {
      final fallbackItems = <VooNavigationDestination>[];
      for (final item in items) {
        if (item.isVisible && !item.hasChildren) {
          fallbackItems.add(item);
        }
      }
      fallbackItems.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return fallbackItems.take(5).toList();
    }

    priorityItems.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return priorityItems.take(5).toList();
  }

  /// Creates a pseudo-navigation item for the context switcher.
  /// This item is used in bottom navigation to render the context switcher.
  VooNavigationDestination _createContextSwitcherNavItem() {
    final selected = contextSwitcher?.selectedItem;
    return VooNavigationDestination(
      id: '_context_switcher_nav',
      label: contextSwitcher?.navItemLabel ??
          selected?.name ??
          contextSwitcher?.placeholder ??
          'Context',
      icon: Icon(selected?.icon ?? Icons.layers_outlined),
      sortOrder: contextSwitcher?.navItemSortOrder ?? 0,
      mobilePriority: true,
      isVisible: true,
      isEnabled: true,
    );
  }

  /// Creates a pseudo-navigation item for the multi-switcher.
  /// This item is used in bottom navigation to render the multi-switcher.
  VooNavigationDestination _createMultiSwitcherNavItem() {
    return VooNavigationDestination(
      id: '_multi_switcher_nav',
      label: multiSwitcher?.navItemLabel ??
          multiSwitcher?.userName ??
          'Account',
      icon: const Icon(Icons.account_circle_outlined),
      sortOrder: multiSwitcher?.navItemSortOrder ?? 0,
      mobilePriority: true,
      isVisible: true,
      isEnabled: true,
    );
  }

  /// Creates a pseudo-navigation item for the user profile.
  /// This item is used in bottom navigation to render the user profile avatar.
  VooNavigationDestination _createUserProfileNavItem() {
    return VooNavigationDestination(
      id: userProfileConfig?.effectiveId ?? '_user_profile_nav',
      label: userProfileConfig?.effectiveNavItemLabel ?? 'Profile',
      icon: const Icon(Icons.person_outlined),
      sortOrder: userProfileConfig?.navItemSortOrder ?? 0,
      mobilePriority: true,
      isVisible: true,
      isEnabled: true,
    );
  }

  /// Gets the selected navigation item
  VooNavigationDestination? get selectedItem {
    if (selectedId == null) return null;
    try {
      return items.firstWhere((item) => item.id == selectedId);
    } catch (e) {
      return null;
    }
  }

  /// Gets all navigation items including those from sections
  List<VooNavigationDestination> get allItems {
    final allItemsList = <VooNavigationDestination>[...items];

    if (sections != null) {
      for (final section in sections!) {
        if (section.isVisible) {
          allItemsList.add(section.toNavigationItem());
        }
      }
    }

    return allItemsList..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Gets visible sections sorted by sortOrder
  List<VooNavigationSection> get visibleSections {
    if (sections == null) return [];
    return sections!.where((section) => section.isVisible).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Gets visible footer items sorted by sortOrder
  List<VooNavigationDestination> get visibleFooterItems {
    if (footerItems == null) return [];
    return footerItems!.where((item) => item.isVisible).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}

// ============================================================================
// COMMON NAVIGATION COMPONENT CONFIGURATIONS
// ============================================================================

/// Configuration for the organization switcher
class VooOrganizationSwitcherConfig {
  final List<VooOrganization> organizations;
  final VooOrganization? selectedOrganization;
  final ValueChanged<VooOrganization>? onOrganizationChanged;
  final VoidCallback? onCreateOrganization;
  final bool? showSearch;
  final bool showCreateButton;
  final String? createButtonLabel;
  final String? searchHint;
  final VooOrganizationSwitcherStyle? style;
  final bool? compact;
  final String? tooltip;

  const VooOrganizationSwitcherConfig({
    required this.organizations,
    this.selectedOrganization,
    this.onOrganizationChanged,
    this.onCreateOrganization,
    this.showSearch,
    this.showCreateButton = true,
    this.createButtonLabel,
    this.searchHint,
    this.style,
    this.compact,
    this.tooltip,
  });

  VooOrganizationSwitcherConfig copyWith({
    List<VooOrganization>? organizations,
    VooOrganization? selectedOrganization,
    ValueChanged<VooOrganization>? onOrganizationChanged,
    VoidCallback? onCreateOrganization,
    bool? showSearch,
    bool? showCreateButton,
    String? createButtonLabel,
    String? searchHint,
    VooOrganizationSwitcherStyle? style,
    bool? compact,
    String? tooltip,
  }) =>
      VooOrganizationSwitcherConfig(
        organizations: organizations ?? this.organizations,
        selectedOrganization: selectedOrganization ?? this.selectedOrganization,
        onOrganizationChanged:
            onOrganizationChanged ?? this.onOrganizationChanged,
        onCreateOrganization: onCreateOrganization ?? this.onCreateOrganization,
        showSearch: showSearch ?? this.showSearch,
        showCreateButton: showCreateButton ?? this.showCreateButton,
        createButtonLabel: createButtonLabel ?? this.createButtonLabel,
        searchHint: searchHint ?? this.searchHint,
        style: style ?? this.style,
        compact: compact ?? this.compact,
        tooltip: tooltip ?? this.tooltip,
      );
}

/// Configuration for the search bar
class VooSearchBarConfig {
  final List<VooNavigationDestination>? navigationItems;
  final ValueChanged<List<VooNavigationDestination>>? onFilteredItemsChanged;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onSearchSubmit;
  final List<VooSearchAction>? searchActions;
  final String? hintText;
  final bool showFilteredResults;
  final bool enableKeyboardShortcut;
  final String? keyboardShortcutHint;
  final VooSearchBarStyle? style;
  final bool expanded;
  final ValueChanged<VooNavigationDestination>? onNavigationItemSelected;
  final ValueChanged<VooSearchAction>? onSearchActionSelected;

  const VooSearchBarConfig({
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
    this.onNavigationItemSelected,
    this.onSearchActionSelected,
  });

  VooSearchBarConfig copyWith({
    List<VooNavigationDestination>? navigationItems,
    ValueChanged<List<VooNavigationDestination>>? onFilteredItemsChanged,
    ValueChanged<String>? onSearch,
    VoidCallback? onSearchSubmit,
    List<VooSearchAction>? searchActions,
    String? hintText,
    bool? showFilteredResults,
    bool? enableKeyboardShortcut,
    String? keyboardShortcutHint,
    VooSearchBarStyle? style,
    bool? expanded,
    ValueChanged<VooNavigationDestination>? onNavigationItemSelected,
    ValueChanged<VooSearchAction>? onSearchActionSelected,
  }) =>
      VooSearchBarConfig(
        navigationItems: navigationItems ?? this.navigationItems,
        onFilteredItemsChanged:
            onFilteredItemsChanged ?? this.onFilteredItemsChanged,
        onSearch: onSearch ?? this.onSearch,
        onSearchSubmit: onSearchSubmit ?? this.onSearchSubmit,
        searchActions: searchActions ?? this.searchActions,
        hintText: hintText ?? this.hintText,
        showFilteredResults: showFilteredResults ?? this.showFilteredResults,
        enableKeyboardShortcut:
            enableKeyboardShortcut ?? this.enableKeyboardShortcut,
        keyboardShortcutHint: keyboardShortcutHint ?? this.keyboardShortcutHint,
        style: style ?? this.style,
        expanded: expanded ?? this.expanded,
        onNavigationItemSelected:
            onNavigationItemSelected ?? this.onNavigationItemSelected,
        onSearchActionSelected:
            onSearchActionSelected ?? this.onSearchActionSelected,
      );
}

/// Configuration for the notifications bell
class VooNotificationsBellConfig {
  final List<VooNotificationItem> notifications;
  final int? unreadCount;
  final ValueChanged<VooNotificationItem>? onNotificationTap;
  final ValueChanged<VooNotificationItem>? onNotificationDismiss;
  final VoidCallback? onMarkAllRead;
  final VoidCallback? onViewAll;
  final int maxVisibleNotifications;
  final bool showMarkAllRead;
  final bool showViewAllButton;
  final String? emptyStateMessage;
  final VooNotificationsBellStyle? style;
  final bool compact;
  final String? tooltip;
  final Widget? emptyStateWidget;
  final Widget? headerWidget;
  final Widget? footerWidget;

  const VooNotificationsBellConfig({
    required this.notifications,
    this.unreadCount,
    this.onNotificationTap,
    this.onNotificationDismiss,
    this.onMarkAllRead,
    this.onViewAll,
    this.maxVisibleNotifications = 5,
    this.showMarkAllRead = true,
    this.showViewAllButton = true,
    this.emptyStateMessage,
    this.style,
    this.compact = false,
    this.tooltip,
    this.emptyStateWidget,
    this.headerWidget,
    this.footerWidget,
  });

  VooNotificationsBellConfig copyWith({
    List<VooNotificationItem>? notifications,
    int? unreadCount,
    ValueChanged<VooNotificationItem>? onNotificationTap,
    ValueChanged<VooNotificationItem>? onNotificationDismiss,
    VoidCallback? onMarkAllRead,
    VoidCallback? onViewAll,
    int? maxVisibleNotifications,
    bool? showMarkAllRead,
    bool? showViewAllButton,
    String? emptyStateMessage,
    VooNotificationsBellStyle? style,
    bool? compact,
    String? tooltip,
    Widget? emptyStateWidget,
    Widget? headerWidget,
    Widget? footerWidget,
  }) =>
      VooNotificationsBellConfig(
        notifications: notifications ?? this.notifications,
        unreadCount: unreadCount ?? this.unreadCount,
        onNotificationTap: onNotificationTap ?? this.onNotificationTap,
        onNotificationDismiss:
            onNotificationDismiss ?? this.onNotificationDismiss,
        onMarkAllRead: onMarkAllRead ?? this.onMarkAllRead,
        onViewAll: onViewAll ?? this.onViewAll,
        maxVisibleNotifications:
            maxVisibleNotifications ?? this.maxVisibleNotifications,
        showMarkAllRead: showMarkAllRead ?? this.showMarkAllRead,
        showViewAllButton: showViewAllButton ?? this.showViewAllButton,
        emptyStateMessage: emptyStateMessage ?? this.emptyStateMessage,
        style: style ?? this.style,
        compact: compact ?? this.compact,
        tooltip: tooltip ?? this.tooltip,
        emptyStateWidget: emptyStateWidget ?? this.emptyStateWidget,
        headerWidget: headerWidget ?? this.headerWidget,
        footerWidget: footerWidget ?? this.footerWidget,
      );
}

/// Configuration for the quick actions menu
class VooQuickActionsConfig {
  final List<VooQuickAction> actions;
  final IconData? triggerIcon;
  final Widget? triggerWidget;
  final String? tooltip;
  final bool showLabelsInGrid;
  final VooQuickActionsStyle? style;
  final bool compact;
  final ValueChanged<VooQuickAction>? onActionSelected;
  final bool useGridLayout;
  final int gridColumns;

  const VooQuickActionsConfig({
    required this.actions,
    this.triggerIcon,
    this.triggerWidget,
    this.tooltip,
    this.showLabelsInGrid = true,
    this.style,
    this.compact = false,
    this.onActionSelected,
    this.useGridLayout = false,
    this.gridColumns = 4,
  });

  VooQuickActionsConfig copyWith({
    List<VooQuickAction>? actions,
    IconData? triggerIcon,
    Widget? triggerWidget,
    String? tooltip,
    bool? showLabelsInGrid,
    VooQuickActionsStyle? style,
    bool? compact,
    ValueChanged<VooQuickAction>? onActionSelected,
    bool? useGridLayout,
    int? gridColumns,
  }) =>
      VooQuickActionsConfig(
        actions: actions ?? this.actions,
        triggerIcon: triggerIcon ?? this.triggerIcon,
        triggerWidget: triggerWidget ?? this.triggerWidget,
        tooltip: tooltip ?? this.tooltip,
        showLabelsInGrid: showLabelsInGrid ?? this.showLabelsInGrid,
        style: style ?? this.style,
        compact: compact ?? this.compact,
        onActionSelected: onActionSelected ?? this.onActionSelected,
        useGridLayout: useGridLayout ?? this.useGridLayout,
        gridColumns: gridColumns ?? this.gridColumns,
      );
}

/// Configuration for the navigation header
class VooHeaderConfig {
  final String? title;
  final String? tagline;
  final Widget? logo;
  final IconData? logoIcon;
  final Color? logoBackgroundColor;
  final bool showTitle;
  final TextStyle? titleStyle;
  final TextStyle? taglineStyle;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  /// Height of the header. Defaults to kToolbarHeight (56dp) to align with app bar.
  final double? height;

  const VooHeaderConfig({
    this.title,
    this.tagline,
    this.logo,
    this.logoIcon,
    this.logoBackgroundColor,
    this.showTitle = true,
    this.titleStyle,
    this.taglineStyle,
    this.padding,
    this.onTap,
    this.height,
  });

  VooHeaderConfig copyWith({
    String? title,
    String? tagline,
    Widget? logo,
    IconData? logoIcon,
    Color? logoBackgroundColor,
    bool? showTitle,
    TextStyle? titleStyle,
    TextStyle? taglineStyle,
    EdgeInsets? padding,
    VoidCallback? onTap,
    double? height,
  }) =>
      VooHeaderConfig(
        title: title ?? this.title,
        tagline: tagline ?? this.tagline,
        logo: logo ?? this.logo,
        logoIcon: logoIcon ?? this.logoIcon,
        logoBackgroundColor: logoBackgroundColor ?? this.logoBackgroundColor,
        showTitle: showTitle ?? this.showTitle,
        titleStyle: titleStyle ?? this.titleStyle,
        taglineStyle: taglineStyle ?? this.taglineStyle,
        padding: padding ?? this.padding,
        onTap: onTap ?? this.onTap,
        height: height ?? this.height,
      );
}

/// Configuration for breadcrumbs
class VooBreadcrumbsConfig {
  final List<VooBreadcrumbItem> items;
  final ValueChanged<VooBreadcrumbItem>? onItemTap;
  final Widget? separator;
  final int? maxVisibleItems;
  final bool showHomeIcon;
  final VooBreadcrumbsStyle? style;

  const VooBreadcrumbsConfig({
    required this.items,
    this.onItemTap,
    this.separator,
    this.maxVisibleItems,
    this.showHomeIcon = true,
    this.style,
  });

  VooBreadcrumbsConfig copyWith({
    List<VooBreadcrumbItem>? items,
    ValueChanged<VooBreadcrumbItem>? onItemTap,
    Widget? separator,
    int? maxVisibleItems,
    bool? showHomeIcon,
    VooBreadcrumbsStyle? style,
  }) =>
      VooBreadcrumbsConfig(
        items: items ?? this.items,
        onItemTap: onItemTap ?? this.onItemTap,
        separator: separator ?? this.separator,
        maxVisibleItems: maxVisibleItems ?? this.maxVisibleItems,
        showHomeIcon: showHomeIcon ?? this.showHomeIcon,
        style: style ?? this.style,
      );
}
