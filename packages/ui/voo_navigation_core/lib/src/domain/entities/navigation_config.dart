import 'package:flutter/material.dart';
import 'package:voo_navigation_core/src/domain/entities/breadcrumb_item.dart';
import 'package:voo_navigation_core/src/domain/entities/breakpoint.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_item.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_section.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_theme.dart';
import 'package:voo_navigation_core/src/domain/entities/navigation_type.dart';
import 'package:voo_navigation_core/src/domain/entities/notification_item.dart';
import 'package:voo_navigation_core/src/domain/entities/organization.dart';
import 'package:voo_navigation_core/src/domain/entities/quick_action.dart';
import 'package:voo_navigation_core/src/domain/entities/search_action.dart';
import 'package:voo_navigation_core/src/domain/entities/user_profile_config.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Configuration for the adaptive navigation system
class VooNavigationConfig {
  /// Default animation tokens for the navigation
  static const _animationTokens = VooAnimationTokens();
  static const _spacingTokens = VooSpacingTokens();

  /// List of navigation items to display
  final List<VooNavigationItem> items;

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

  /// Custom header widget for navigation drawer (full override)
  ///
  /// When provided, completely replaces the default header.
  /// For simpler customization, use [headerConfig] instead.
  final Widget? drawerHeader;

  /// Simplified header configuration
  ///
  /// Provides easy customization of title, logo, and other header options.
  /// Ignored if [drawerHeader] is provided.
  ///
  /// Example:
  /// ```dart
  /// VooNavigationConfig(
  ///   headerConfig: VooHeaderConfig(
  ///     title: 'My App',
  ///     logoIcon: Icons.dashboard,
  ///   ),
  /// )
  /// ```
  final VooHeaderConfig? headerConfig;

  /// Trailing widget for drawer header (e.g., collapse toggle)
  /// Positioned to the right of the header content
  final Widget? drawerHeaderTrailing;

  /// Custom footer widget for navigation drawer
  final Widget? drawerFooter;

  /// Custom leading widget builder for app bar
  final Widget? Function(String? selectedId)? appBarLeadingBuilder;

  /// Custom actions builder for app bar
  final List<Widget>? Function(String? selectedId)? appBarActionsBuilder;

  /// App bar title builder
  final Widget? Function(String? selectedId)? appBarTitleBuilder;

  /// Whether to center the app bar title
  final bool centerAppBarTitle;

  /// Whether the app bar should be positioned alongside the navigation rail
  /// When true (default), app bar only spans the content area to the right of the rail
  /// When false, app bar spans the full width above the rail
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

  /// Whether to wrap body in a card with elevation (for desktop/tablet)
  final bool useBodyCard;

  /// Elevation for body card (if useBodyCard is true)
  final double bodyCardElevation;

  /// Border radius for body card (if useBodyCard is true)
  final BorderRadius? bodyCardBorderRadius;

  /// Color for body card (if useBodyCard is true)
  final Color? bodyCardColor;

  /// Custom floating action button
  final Widget? floatingActionButton;

  /// Floating action button location
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Floating action button animator
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// Whether to show floating action button
  final bool showFloatingActionButton;

  /// Background color for the scaffold
  final Color? backgroundColor;

  /// Background color for navigation components
  final Color? navigationBackgroundColor;

  /// Selected item color
  final Color? selectedItemColor;

  /// Unselected item color
  final Color? unselectedItemColor;

  /// Indicator color for selected items
  final Color? indicatorColor;

  /// Indicator shape
  final ShapeBorder? indicatorShape;

  /// Elevation for navigation components
  final double? elevation;

  /// Whether to show divider in navigation rail
  final bool showNavigationRailDivider;

  /// Custom navigation rail width
  final double? navigationRailWidth;

  final double navigationRailMargin;

  /// Margin around the navigation drawer
  /// When null, uses navigationRailMargin. Set to EdgeInsets.zero for full-height drawer.
  final EdgeInsets? drawerMargin;

  /// Margin around the content area
  /// When null, uses navigationRailMargin on top, bottom, and right
  final EdgeInsets? contentAreaMargin;

  /// Border radius for the content area container
  /// When null, uses the navigation theme's containerBorderRadius
  final BorderRadius? contentAreaBorderRadius;

  /// Background color for the content area
  /// When set, overrides the themed container's surface color
  /// Useful for creating contrast in inset layouts (e.g., light content on dark scaffold)
  final Color? contentAreaBackgroundColor;

  /// Custom extended navigation rail width
  final double? extendedNavigationRailWidth;

  /// Custom navigation drawer width
  final double? navigationDrawerWidth;

  /// Animation duration for transitions
  final Duration animationDuration;

  /// Animation curve for transitions
  final Curve animationCurve;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  /// Whether to enable animations
  final bool enableAnimations;

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

  /// Badge animation duration
  final Duration badgeAnimationDuration;

  /// Whether to group items by sections
  final bool groupItemsBySections;

  /// Navigation sections for organized grouping of items
  ///
  /// Sections provide a semantic way to group navigation items with headers.
  /// When provided, sections are rendered in addition to [items].
  final List<VooNavigationSection>? sections;

  /// Footer items displayed at the bottom of the navigation rail/drawer
  ///
  /// These items appear above the user profile section (if enabled) and are
  /// typically used for static routes like Settings, Integrations, Help, etc.
  final List<VooNavigationItem>? footerItems;

  /// Callback when the navigation collapse state changes
  ///
  /// Called when [enableCollapsibleRail] is true and user toggles collapse.
  final void Function(bool isCollapsed)? onCollapseChanged;

  /// Custom empty state widget
  final Widget? emptyStateWidget;

  /// Custom error widget
  final Widget Function(Object error)? errorBuilder;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Type of bottom navigation bar to use
  final VooNavigationBarType bottomNavigationType;

  /// Whether to use floating style for bottom navigation
  final bool floatingBottomNav;

  /// Horizontal margin for floating bottom navigation
  final double? floatingBottomNavMargin;

  /// Bottom margin for floating bottom navigation
  final double? floatingBottomNavBottomMargin;

  /// Whether to show user profile in drawer/rail footer
  final bool showUserProfile;

  /// User profile widget for drawer/rail footer (legacy - must handle compact manually)
  ///
  /// Consider using [userProfileConfig] instead, which automatically handles
  /// compact mode based on collapse state.
  final Widget? userProfileWidget;

  /// Configuration for user profile in drawer/rail footer (preferred)
  ///
  /// When provided, the drawer/rail will automatically create a [VooUserProfileFooter]
  /// with the correct compact mode based on collapse state.
  ///
  /// This is preferred over [userProfileWidget] because it handles
  /// compact mode automatically.
  final VooUserProfileConfig? userProfileConfig;

  /// Whether the rail/drawer supports collapsing
  final bool enableCollapsibleRail;

  /// Custom collapse toggle builder
  final Widget Function(bool isExpanded, VoidCallback onToggle)?
      collapseToggleBuilder;

  /// Visual theme for navigation styling
  ///
  /// Use preset themes via factory constructors:
  /// - [VooNavigationConfig.glassmorphism]
  /// - [VooNavigationConfig.neomorphism]
  /// - [VooNavigationConfig.material3Enhanced]
  /// - [VooNavigationConfig.minimalModern]
  final VooNavigationTheme? navigationTheme;

  /// Gets the effective theme, defaulting to Minimal Modern (clean flat design)
  VooNavigationTheme get effectiveTheme =>
      navigationTheme ?? VooNavigationTheme.minimalModern(
        borderWidth: 0, // No border for clean look
      ).copyWith(
        containerBorderRadius: 0, // Flush to edge, no rounding
        showContainerBorder: false, // No border on drawer
      );

  // ============================================================================
  // COMMON NAVIGATION COMPONENTS
  // ============================================================================

  /// Organization switcher configuration
  ///
  /// When provided, displays an organization switcher in the navigation.
  /// Position is controlled by [organizationSwitcherPosition].
  final VooOrganizationSwitcherConfig? organizationSwitcher;

  /// Position of the organization switcher
  final VooOrganizationSwitcherPosition organizationSwitcherPosition;

  /// Search bar configuration
  ///
  /// When provided, displays a search bar in the navigation.
  /// Position is controlled by [searchBarPosition].
  final VooSearchBarConfig? searchBar;

  /// Position of the search bar
  final VooSearchBarPosition searchBarPosition;

  /// Notifications bell configuration
  ///
  /// When provided, displays a notifications bell with dropdown.
  /// Typically displayed in the app bar actions.
  final VooNotificationsBellConfig? notificationsBell;

  /// Quick actions menu configuration
  ///
  /// When provided, displays a quick actions menu.
  /// Position is controlled by [quickActionsPosition].
  final VooQuickActionsConfig? quickActions;

  /// Position of the quick actions menu
  final VooQuickActionsPosition quickActionsPosition;

  /// Breadcrumbs configuration
  ///
  /// When provided, displays breadcrumbs for hierarchical navigation.
  final VooBreadcrumbsConfig? breadcrumbs;

  /// Whether to show breadcrumbs in the app bar
  final bool showBreadcrumbsInAppBar;

  VooNavigationConfig({
    required this.items,
    this.selectedId,
    List<VooBreakpoint>? breakpoints,
    this.isAdaptive = true,
    this.forcedNavigationType,
    this.theme,
    this.railLabelType = NavigationRailLabelType.selected,
    this.useExtendedRail = true,
    this.drawerHeader,
    this.headerConfig,
    this.drawerHeaderTrailing,
    this.drawerFooter,
    this.appBarLeadingBuilder,
    this.appBarActionsBuilder,
    this.appBarTitleBuilder,
    this.centerAppBarTitle = false,
    this.appBarAlongsideRail = true,
    this.showAppBar = true,
    this.resizeToAvoidBottomInset = true,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.bodyPadding,
    this.useBodyCard = false,
    this.bodyCardElevation = 0,
    this.bodyCardBorderRadius,
    this.bodyCardColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.showFloatingActionButton = true,
    this.backgroundColor,
    this.navigationBackgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.indicatorColor,
    this.indicatorShape,
    this.elevation,
    this.showNavigationRailDivider = true,
    this.navigationRailWidth,
    this.extendedNavigationRailWidth,
    this.navigationDrawerWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    this.enableHapticFeedback = true,
    this.enableAnimations = true,
    this.transitionBuilder,
    this.onNavigationItemSelected,
    this.persistNavigationState = true,
    this.drawerScrollController,
    this.showNotificationBadges = true,
    Duration? badgeAnimationDuration,
    this.groupItemsBySections = false,
    this.sections,
    this.footerItems,
    this.onCollapseChanged,
    this.emptyStateWidget,
    this.errorBuilder,
    this.loadingWidget,
    this.bottomNavigationType = VooNavigationBarType.custom,
    this.floatingBottomNav = true,
    this.floatingBottomNavMargin,
    this.floatingBottomNavBottomMargin,
    this.showUserProfile = true,
    this.userProfileWidget,
    this.userProfileConfig,
    this.enableCollapsibleRail = true,
    this.collapseToggleBuilder,
    this.navigationTheme,
    double? navigationRailMargin,
    this.drawerMargin,
    this.contentAreaMargin,
    this.contentAreaBorderRadius,
    this.contentAreaBackgroundColor,
    // Common navigation components
    this.organizationSwitcher,
    this.organizationSwitcherPosition = VooOrganizationSwitcherPosition.header,
    this.searchBar,
    this.searchBarPosition = VooSearchBarPosition.header,
    this.notificationsBell,
    this.quickActions,
    this.quickActionsPosition = VooQuickActionsPosition.fab,
    this.breadcrumbs,
    this.showBreadcrumbsInAppBar = true,
  }) : breakpoints = breakpoints ?? VooBreakpoint.material3Breakpoints,
       animationDuration = animationDuration ?? _animationTokens.durationNormal,
       animationCurve = animationCurve ?? _animationTokens.curveEaseInOut,
       badgeAnimationDuration =
           badgeAnimationDuration ?? _animationTokens.durationFast,
       navigationRailMargin = navigationRailMargin ?? 0; // Flush to edge by default

  /// Creates a copy of this configuration with the given fields replaced
  VooNavigationConfig copyWith({
    List<VooNavigationItem>? items,
    String? selectedId,
    List<VooBreakpoint>? breakpoints,
    bool? isAdaptive,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType? railLabelType,
    bool? useExtendedRail,
    Widget? drawerHeader,
    VooHeaderConfig? headerConfig,
    Widget? drawerHeaderTrailing,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool? centerAppBarTitle,
    bool? appBarAlongsideRail,
    bool? showAppBar,
    bool? resizeToAvoidBottomInset,
    bool? extendBody,
    bool? extendBodyBehindAppBar,
    EdgeInsetsGeometry? bodyPadding,
    bool? useBodyCard,
    double? bodyCardElevation,
    BorderRadius? bodyCardBorderRadius,
    Color? bodyCardColor,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    bool? showFloatingActionButton,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    ShapeBorder? indicatorShape,
    double? elevation,
    bool? showNavigationRailDivider,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableHapticFeedback,
    bool? enableAnimations,
    Widget Function(Widget child, Animation<double> animation)?
    transitionBuilder,
    void Function(String itemId)? onNavigationItemSelected,
    bool? persistNavigationState,
    ScrollController? drawerScrollController,
    bool? showNotificationBadges,
    Duration? badgeAnimationDuration,
    bool? groupItemsBySections,
    List<VooNavigationSection>? sections,
    List<VooNavigationItem>? footerItems,
    void Function(bool isCollapsed)? onCollapseChanged,
    Widget? emptyStateWidget,
    Widget Function(Object error)? errorBuilder,
    Widget? loadingWidget,
    VooNavigationBarType? bottomNavigationType,
    bool? floatingBottomNav,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool? showUserProfile,
    Widget? userProfileWidget,
    VooUserProfileConfig? userProfileConfig,
    bool? enableCollapsibleRail,
    Widget Function(bool isExpanded, VoidCallback onToggle)?
        collapseToggleBuilder,
    VooNavigationTheme? navigationTheme,
    double? navigationRailMargin,
    EdgeInsets? drawerMargin,
    EdgeInsets? contentAreaMargin,
    BorderRadius? contentAreaBorderRadius,
    Color? contentAreaBackgroundColor,
    // Common navigation components
    VooOrganizationSwitcherConfig? organizationSwitcher,
    VooOrganizationSwitcherPosition? organizationSwitcherPosition,
    VooSearchBarConfig? searchBar,
    VooSearchBarPosition? searchBarPosition,
    VooNotificationsBellConfig? notificationsBell,
    VooQuickActionsConfig? quickActions,
    VooQuickActionsPosition? quickActionsPosition,
    VooBreadcrumbsConfig? breadcrumbs,
    bool? showBreadcrumbsInAppBar,
  }) => VooNavigationConfig(
    items: items ?? this.items,
    selectedId: selectedId ?? this.selectedId,
    breakpoints: breakpoints ?? this.breakpoints,
    isAdaptive: isAdaptive ?? this.isAdaptive,
    forcedNavigationType: forcedNavigationType ?? this.forcedNavigationType,
    theme: theme ?? this.theme,
    railLabelType: railLabelType ?? this.railLabelType,
    useExtendedRail: useExtendedRail ?? this.useExtendedRail,
    drawerHeader: drawerHeader ?? this.drawerHeader,
    headerConfig: headerConfig ?? this.headerConfig,
    drawerHeaderTrailing: drawerHeaderTrailing ?? this.drawerHeaderTrailing,
    drawerFooter: drawerFooter ?? this.drawerFooter,
    appBarLeadingBuilder: appBarLeadingBuilder ?? this.appBarLeadingBuilder,
    appBarActionsBuilder: appBarActionsBuilder ?? this.appBarActionsBuilder,
    appBarTitleBuilder: appBarTitleBuilder ?? this.appBarTitleBuilder,
    centerAppBarTitle: centerAppBarTitle ?? this.centerAppBarTitle,
    appBarAlongsideRail: appBarAlongsideRail ?? this.appBarAlongsideRail,
    showAppBar: showAppBar ?? this.showAppBar,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
    extendBody: extendBody ?? this.extendBody,
    extendBodyBehindAppBar: extendBodyBehindAppBar ?? this.extendBodyBehindAppBar,
    bodyPadding: bodyPadding ?? this.bodyPadding,
    useBodyCard: useBodyCard ?? this.useBodyCard,
    bodyCardElevation: bodyCardElevation ?? this.bodyCardElevation,
    bodyCardBorderRadius: bodyCardBorderRadius ?? this.bodyCardBorderRadius,
    bodyCardColor: bodyCardColor ?? this.bodyCardColor,
    floatingActionButton: floatingActionButton ?? this.floatingActionButton,
    floatingActionButtonLocation:
        floatingActionButtonLocation ?? this.floatingActionButtonLocation,
    floatingActionButtonAnimator:
        floatingActionButtonAnimator ?? this.floatingActionButtonAnimator,
    showFloatingActionButton:
        showFloatingActionButton ?? this.showFloatingActionButton,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    navigationBackgroundColor:
        navigationBackgroundColor ?? this.navigationBackgroundColor,
    selectedItemColor: selectedItemColor ?? this.selectedItemColor,
    unselectedItemColor: unselectedItemColor ?? this.unselectedItemColor,
    indicatorColor: indicatorColor ?? this.indicatorColor,
    indicatorShape: indicatorShape ?? this.indicatorShape,
    elevation: elevation ?? this.elevation,
    showNavigationRailDivider:
        showNavigationRailDivider ?? this.showNavigationRailDivider,
    navigationRailWidth: navigationRailWidth ?? this.navigationRailWidth,
    extendedNavigationRailWidth:
        extendedNavigationRailWidth ?? this.extendedNavigationRailWidth,
    navigationDrawerWidth: navigationDrawerWidth ?? this.navigationDrawerWidth,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
    enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    enableAnimations: enableAnimations ?? this.enableAnimations,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    onNavigationItemSelected:
        onNavigationItemSelected ?? this.onNavigationItemSelected,
    persistNavigationState:
        persistNavigationState ?? this.persistNavigationState,
    drawerScrollController:
        drawerScrollController ?? this.drawerScrollController,
    showNotificationBadges:
        showNotificationBadges ?? this.showNotificationBadges,
    badgeAnimationDuration:
        badgeAnimationDuration ?? this.badgeAnimationDuration,
    groupItemsBySections: groupItemsBySections ?? this.groupItemsBySections,
    sections: sections ?? this.sections,
    footerItems: footerItems ?? this.footerItems,
    onCollapseChanged: onCollapseChanged ?? this.onCollapseChanged,
    emptyStateWidget: emptyStateWidget ?? this.emptyStateWidget,
    errorBuilder: errorBuilder ?? this.errorBuilder,
    loadingWidget: loadingWidget ?? this.loadingWidget,
    bottomNavigationType: bottomNavigationType ?? this.bottomNavigationType,
    floatingBottomNav: floatingBottomNav ?? this.floatingBottomNav,
    floatingBottomNavMargin:
        floatingBottomNavMargin ?? this.floatingBottomNavMargin,
    floatingBottomNavBottomMargin:
        floatingBottomNavBottomMargin ?? this.floatingBottomNavBottomMargin,
    showUserProfile: showUserProfile ?? this.showUserProfile,
    userProfileWidget: userProfileWidget ?? this.userProfileWidget,
    userProfileConfig: userProfileConfig ?? this.userProfileConfig,
    enableCollapsibleRail: enableCollapsibleRail ?? this.enableCollapsibleRail,
    collapseToggleBuilder: collapseToggleBuilder ?? this.collapseToggleBuilder,
    navigationTheme: navigationTheme ?? this.navigationTheme,
    navigationRailMargin: navigationRailMargin ?? this.navigationRailMargin,
    drawerMargin: drawerMargin ?? this.drawerMargin,
    contentAreaMargin: contentAreaMargin ?? this.contentAreaMargin,
    contentAreaBorderRadius: contentAreaBorderRadius ?? this.contentAreaBorderRadius,
    contentAreaBackgroundColor: contentAreaBackgroundColor ?? this.contentAreaBackgroundColor,
    organizationSwitcher: organizationSwitcher ?? this.organizationSwitcher,
    organizationSwitcherPosition: organizationSwitcherPosition ?? this.organizationSwitcherPosition,
    searchBar: searchBar ?? this.searchBar,
    searchBarPosition: searchBarPosition ?? this.searchBarPosition,
    notificationsBell: notificationsBell ?? this.notificationsBell,
    quickActions: quickActions ?? this.quickActions,
    quickActionsPosition: quickActionsPosition ?? this.quickActionsPosition,
    breadcrumbs: breadcrumbs ?? this.breadcrumbs,
    showBreadcrumbsInAppBar: showBreadcrumbsInAppBar ?? this.showBreadcrumbsInAppBar,
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
  List<VooNavigationItem> get visibleItems =>
      items.where((item) => item.isVisible).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  /// Gets mobile priority navigation items (max 5 items for bottom navigation)
  /// Includes both direct items and children of sections marked with mobilePriority
  /// Falls back to first 5 visible non-section items if no items have mobilePriority
  List<VooNavigationItem> get mobilePriorityItems {
    final priorityItems = <VooNavigationItem>[];

    for (final item in items) {
      // Check direct item mobilePriority
      if (item.isVisible && item.mobilePriority) {
        priorityItems.add(item);
      }

      // Check children mobilePriority (for sections)
      if (item.hasChildren && item.children != null) {
        for (final child in item.children!) {
          if (child.isVisible && child.mobilePriority) {
            priorityItems.add(child);
          }
        }
      }
    }

    // If no items have mobilePriority, fall back to first 5 visible non-section items
    if (priorityItems.isEmpty) {
      final fallbackItems = <VooNavigationItem>[];
      for (final item in items) {
        // Skip sections (items with children) - only show leaf items in bottom nav
        if (item.isVisible && !item.hasChildren) {
          fallbackItems.add(item);
        }
      }
      fallbackItems.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return fallbackItems.take(5).toList();
    }

    // Sort by sortOrder and take first 5 (Material 3 supports 3-5 destinations)
    priorityItems.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return priorityItems.take(5).toList();
  }

  /// Gets the selected navigation item
  VooNavigationItem? get selectedItem {
    if (selectedId == null) return null;
    try {
      return items.firstWhere((item) => item.id == selectedId);
    } catch (e) {
      return null;
    }
  }

  /// Gets all navigation items including those from sections
  ///
  /// This combines direct items and items from all sections into a single list.
  List<VooNavigationItem> get allItems {
    final allItemsList = <VooNavigationItem>[...items];

    if (sections != null) {
      for (final section in sections!) {
        if (section.isVisible) {
          allItemsList.add(section.toNavigationItem());
        }
      }
    }

    return allItemsList
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Gets visible sections sorted by sortOrder
  List<VooNavigationSection> get visibleSections {
    if (sections == null) return [];
    return sections!
        .where((section) => section.isVisible)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Gets visible footer items sorted by sortOrder
  List<VooNavigationItem> get visibleFooterItems {
    if (footerItems == null) return [];
    return footerItems!
        .where((item) => item.isVisible)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  // ============================================================================
  // THEME PRESET FACTORY CONSTRUCTORS
  // ============================================================================

  /// Creates a glassmorphism-themed navigation configuration
  ///
  /// Features frosted glass effect with blur, translucent surfaces,
  /// subtle borders, and glow indicators.
  ///
  /// ```dart
  /// VooNavigationConfig.glassmorphism(
  ///   items: navigationItems,
  ///   selectedId: 'home',
  ///   onNavigationItemSelected: (id) => handleNavigation(id),
  /// )
  /// ```
  factory VooNavigationConfig.glassmorphism({
    required List<VooNavigationItem> items,
    String? selectedId,
    void Function(String itemId)? onNavigationItemSelected,
    List<VooBreakpoint>? breakpoints,
    bool isAdaptive = true,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType railLabelType = NavigationRailLabelType.selected,
    bool useExtendedRail = true,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool centerAppBarTitle = false,
    bool appBarAlongsideRail = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showFloatingActionButton = true,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    bool showNavigationRailDivider = false,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    bool enableHapticFeedback = true,
    bool enableAnimations = true,
    bool persistNavigationState = true,
    bool showNotificationBadges = true,
    bool groupItemsBySections = false,
    VooNavigationBarType bottomNavigationType = VooNavigationBarType.custom,
    bool floatingBottomNav = true,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool showUserProfile = true,
    Widget? userProfileWidget,
    VooUserProfileConfig? userProfileConfig,
    bool enableCollapsibleRail = true,
    double? navigationRailMargin,
    // Glassmorphism-specific options
    double surfaceOpacity = 0.75,
    double blurSigma = 16,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      breakpoints: breakpoints,
      isAdaptive: isAdaptive,
      forcedNavigationType: forcedNavigationType,
      theme: theme,
      railLabelType: railLabelType,
      useExtendedRail: useExtendedRail,
      drawerHeader: drawerHeader,
      drawerFooter: drawerFooter,
      appBarLeadingBuilder: appBarLeadingBuilder,
      appBarActionsBuilder: appBarActionsBuilder,
      appBarTitleBuilder: appBarTitleBuilder,
      centerAppBarTitle: centerAppBarTitle,
      appBarAlongsideRail: appBarAlongsideRail,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      showFloatingActionButton: showFloatingActionButton,
      backgroundColor: backgroundColor,
      navigationBackgroundColor: navigationBackgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      indicatorColor: indicatorColor,
      indicatorShape: const StadiumBorder(),
      elevation: 0,
      showNavigationRailDivider: showNavigationRailDivider,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      navigationDrawerWidth: navigationDrawerWidth,
      animationDuration: _animationTokens.durationNormal,
      animationCurve: Curves.easeInOut,
      enableHapticFeedback: enableHapticFeedback,
      enableAnimations: enableAnimations,
      persistNavigationState: persistNavigationState,
      showNotificationBadges: showNotificationBadges,
      groupItemsBySections: groupItemsBySections,
      bottomNavigationType: bottomNavigationType,
      floatingBottomNav: floatingBottomNav,
      floatingBottomNavMargin: floatingBottomNavMargin ?? _spacingTokens.md,
      floatingBottomNavBottomMargin:
          floatingBottomNavBottomMargin ?? _spacingTokens.lg,
      showUserProfile: showUserProfile,
      userProfileWidget: userProfileWidget,
      userProfileConfig: userProfileConfig,
      enableCollapsibleRail: enableCollapsibleRail,
      navigationRailMargin: navigationRailMargin,
      navigationTheme: VooNavigationTheme.glassmorphism(
        surfaceOpacity: surfaceOpacity,
        blurSigma: blurSigma,
        indicatorColor: indicatorColor,
      ),
    );
  }

  /// Creates a neomorphism-themed navigation configuration
  ///
  /// Features soft embossed/debossed effect with dual shadows,
  /// no visible borders, and pressed-in indicators.
  ///
  /// ```dart
  /// VooNavigationConfig.neomorphism(
  ///   items: navigationItems,
  ///   selectedId: 'home',
  ///   onNavigationItemSelected: (id) => handleNavigation(id),
  /// )
  /// ```
  factory VooNavigationConfig.neomorphism({
    required List<VooNavigationItem> items,
    String? selectedId,
    void Function(String itemId)? onNavigationItemSelected,
    List<VooBreakpoint>? breakpoints,
    bool isAdaptive = true,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType railLabelType = NavigationRailLabelType.selected,
    bool useExtendedRail = true,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool centerAppBarTitle = false,
    bool appBarAlongsideRail = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showFloatingActionButton = true,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    bool showNavigationRailDivider = false,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    bool enableHapticFeedback = true,
    bool enableAnimations = true,
    bool persistNavigationState = true,
    bool showNotificationBadges = true,
    bool groupItemsBySections = false,
    VooNavigationBarType bottomNavigationType = VooNavigationBarType.custom,
    bool floatingBottomNav = false,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool showUserProfile = true,
    Widget? userProfileWidget,
    VooUserProfileConfig? userProfileConfig,
    bool enableCollapsibleRail = true,
    double? navigationRailMargin,
    // Neomorphism-specific options
    double shadowBlur = 12,
    double shadowOffset = 6,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      breakpoints: breakpoints,
      isAdaptive: isAdaptive,
      forcedNavigationType: forcedNavigationType,
      theme: theme,
      railLabelType: railLabelType,
      useExtendedRail: useExtendedRail,
      drawerHeader: drawerHeader,
      drawerFooter: drawerFooter,
      appBarLeadingBuilder: appBarLeadingBuilder,
      appBarActionsBuilder: appBarActionsBuilder,
      appBarTitleBuilder: appBarTitleBuilder,
      centerAppBarTitle: centerAppBarTitle,
      appBarAlongsideRail: appBarAlongsideRail,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      showFloatingActionButton: showFloatingActionButton,
      backgroundColor: backgroundColor,
      navigationBackgroundColor: navigationBackgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      indicatorColor: indicatorColor,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      showNavigationRailDivider: showNavigationRailDivider,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      navigationDrawerWidth: navigationDrawerWidth,
      animationDuration: _animationTokens.durationFast,
      animationCurve: Curves.easeOut,
      enableHapticFeedback: enableHapticFeedback,
      enableAnimations: enableAnimations,
      persistNavigationState: persistNavigationState,
      showNotificationBadges: showNotificationBadges,
      groupItemsBySections: groupItemsBySections,
      bottomNavigationType: bottomNavigationType,
      floatingBottomNav: floatingBottomNav,
      floatingBottomNavMargin: floatingBottomNavMargin,
      floatingBottomNavBottomMargin: floatingBottomNavBottomMargin,
      showUserProfile: showUserProfile,
      userProfileWidget: userProfileWidget,
      userProfileConfig: userProfileConfig,
      enableCollapsibleRail: enableCollapsibleRail,
      navigationRailMargin: navigationRailMargin ?? _spacingTokens.lg,
      navigationTheme: VooNavigationTheme.neomorphism(
        shadowBlur: shadowBlur,
        shadowOffset: shadowOffset,
        indicatorColor: indicatorColor,
      ),
    );
  }

  /// Creates a Material 3 Enhanced themed navigation configuration
  ///
  /// Features polished Material 3 styling with richer animations,
  /// animated pill indicators, and subtle glow effects.
  ///
  /// ```dart
  /// VooNavigationConfig.material3Enhanced(
  ///   items: navigationItems,
  ///   selectedId: 'home',
  ///   onNavigationItemSelected: (id) => handleNavigation(id),
  /// )
  /// ```
  factory VooNavigationConfig.material3Enhanced({
    required List<VooNavigationItem> items,
    String? selectedId,
    void Function(String itemId)? onNavigationItemSelected,
    List<VooBreakpoint>? breakpoints,
    bool isAdaptive = true,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType railLabelType = NavigationRailLabelType.all,
    bool useExtendedRail = true,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool centerAppBarTitle = false,
    bool appBarAlongsideRail = true,
    bool showAppBar = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showFloatingActionButton = true,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    bool showNavigationRailDivider = true,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    bool enableHapticFeedback = true,
    bool enableAnimations = true,
    bool persistNavigationState = true,
    bool showNotificationBadges = true,
    bool groupItemsBySections = false,
    VooNavigationBarType bottomNavigationType = VooNavigationBarType.custom,
    bool floatingBottomNav = false,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool showUserProfile = true,
    Widget? userProfileWidget,
    VooUserProfileConfig? userProfileConfig,
    bool enableCollapsibleRail = true,
    double? navigationRailMargin,
    EdgeInsets? drawerMargin,
    EdgeInsets? contentAreaMargin,
    BorderRadius? contentAreaBorderRadius,
    Color? contentAreaBackgroundColor,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      breakpoints: breakpoints,
      isAdaptive: isAdaptive,
      forcedNavigationType: forcedNavigationType,
      theme: theme,
      railLabelType: railLabelType,
      useExtendedRail: useExtendedRail,
      drawerHeader: drawerHeader,
      drawerFooter: drawerFooter,
      appBarLeadingBuilder: appBarLeadingBuilder,
      appBarActionsBuilder: appBarActionsBuilder,
      appBarTitleBuilder: appBarTitleBuilder,
      centerAppBarTitle: centerAppBarTitle,
      appBarAlongsideRail: appBarAlongsideRail,
      showAppBar: showAppBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      showFloatingActionButton: showFloatingActionButton,
      backgroundColor: backgroundColor,
      navigationBackgroundColor: navigationBackgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      indicatorColor: indicatorColor,
      indicatorShape: const StadiumBorder(),
      elevation: 2,
      showNavigationRailDivider: showNavigationRailDivider,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      navigationDrawerWidth: navigationDrawerWidth,
      animationDuration: _animationTokens.durationNormal,
      animationCurve: Curves.easeOutBack,
      enableHapticFeedback: enableHapticFeedback,
      enableAnimations: enableAnimations,
      persistNavigationState: persistNavigationState,
      showNotificationBadges: showNotificationBadges,
      groupItemsBySections: groupItemsBySections,
      bottomNavigationType: bottomNavigationType,
      floatingBottomNav: floatingBottomNav,
      floatingBottomNavMargin: floatingBottomNavMargin,
      floatingBottomNavBottomMargin: floatingBottomNavBottomMargin,
      showUserProfile: showUserProfile,
      userProfileWidget: userProfileWidget,
      userProfileConfig: userProfileConfig,
      enableCollapsibleRail: enableCollapsibleRail,
      navigationRailMargin: navigationRailMargin,
      drawerMargin: drawerMargin,
      contentAreaMargin: contentAreaMargin,
      contentAreaBorderRadius: contentAreaBorderRadius,
      contentAreaBackgroundColor: contentAreaBackgroundColor,
      navigationTheme: VooNavigationTheme.material3Enhanced(
        indicatorColor: indicatorColor,
      ),
    );
  }

  /// Creates a minimal modern themed navigation configuration
  ///
  /// Features clean flat design with no shadows, thin line indicators,
  /// and fast linear animations.
  ///
  /// ```dart
  /// VooNavigationConfig.minimalModern(
  ///   items: navigationItems,
  ///   selectedId: 'home',
  ///   onNavigationItemSelected: (id) => handleNavigation(id),
  /// )
  /// ```
  factory VooNavigationConfig.minimalModern({
    required List<VooNavigationItem> items,
    String? selectedId,
    void Function(String itemId)? onNavigationItemSelected,
    List<VooBreakpoint>? breakpoints,
    bool isAdaptive = true,
    VooNavigationType? forcedNavigationType,
    ThemeData? theme,
    NavigationRailLabelType railLabelType = NavigationRailLabelType.none,
    bool useExtendedRail = false,
    Widget? drawerHeader,
    Widget? drawerFooter,
    Widget? Function(String? selectedId)? appBarLeadingBuilder,
    List<Widget>? Function(String? selectedId)? appBarActionsBuilder,
    Widget? Function(String? selectedId)? appBarTitleBuilder,
    bool centerAppBarTitle = false,
    bool appBarAlongsideRail = true,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    bool showFloatingActionButton = true,
    Color? backgroundColor,
    Color? navigationBackgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    Color? indicatorColor,
    bool showNavigationRailDivider = false,
    double? navigationRailWidth,
    double? extendedNavigationRailWidth,
    double? navigationDrawerWidth,
    bool enableHapticFeedback = true,
    bool enableAnimations = true,
    bool persistNavigationState = true,
    bool showNotificationBadges = true,
    bool groupItemsBySections = false,
    VooNavigationBarType bottomNavigationType = VooNavigationBarType.custom,
    bool floatingBottomNav = false,
    double? floatingBottomNavMargin,
    double? floatingBottomNavBottomMargin,
    bool showUserProfile = true,
    Widget? userProfileWidget,
    VooUserProfileConfig? userProfileConfig,
    bool enableCollapsibleRail = true,
    double? navigationRailMargin,
    // Minimal-specific options
    double borderWidth = 1,
  }) {
    return VooNavigationConfig(
      items: items,
      selectedId: selectedId,
      onNavigationItemSelected: onNavigationItemSelected,
      breakpoints: breakpoints,
      isAdaptive: isAdaptive,
      forcedNavigationType: forcedNavigationType,
      theme: theme,
      railLabelType: railLabelType,
      useExtendedRail: useExtendedRail,
      drawerHeader: drawerHeader,
      drawerFooter: drawerFooter,
      appBarLeadingBuilder: appBarLeadingBuilder,
      appBarActionsBuilder: appBarActionsBuilder,
      appBarTitleBuilder: appBarTitleBuilder,
      centerAppBarTitle: centerAppBarTitle,
      appBarAlongsideRail: appBarAlongsideRail,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      showFloatingActionButton: showFloatingActionButton,
      backgroundColor: backgroundColor,
      navigationBackgroundColor: navigationBackgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      indicatorColor: indicatorColor,
      indicatorShape: const RoundedRectangleBorder(),
      elevation: 0,
      showNavigationRailDivider: showNavigationRailDivider,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      navigationDrawerWidth: navigationDrawerWidth,
      animationDuration: _animationTokens.durationFast,
      animationCurve: Curves.linear,
      enableHapticFeedback: enableHapticFeedback,
      enableAnimations: enableAnimations,
      persistNavigationState: persistNavigationState,
      showNotificationBadges: showNotificationBadges,
      groupItemsBySections: groupItemsBySections,
      bottomNavigationType: bottomNavigationType,
      floatingBottomNav: floatingBottomNav,
      floatingBottomNavMargin: floatingBottomNavMargin,
      floatingBottomNavBottomMargin: floatingBottomNavBottomMargin,
      showUserProfile: showUserProfile,
      userProfileWidget: userProfileWidget,
      userProfileConfig: userProfileConfig,
      enableCollapsibleRail: enableCollapsibleRail,
      navigationRailMargin: navigationRailMargin ?? _spacingTokens.xl,
      navigationTheme: VooNavigationTheme.minimalModern(
        borderWidth: borderWidth,
        indicatorColor: indicatorColor,
      ),
    );
  }
}

// ============================================================================
// COMMON NAVIGATION COMPONENT CONFIGURATIONS
// ============================================================================

/// Configuration for the organization switcher
class VooOrganizationSwitcherConfig {
  /// List of available organizations
  final List<VooOrganization> organizations;

  /// Currently selected organization
  final VooOrganization? selectedOrganization;

  /// Callback when an organization is selected
  final ValueChanged<VooOrganization>? onOrganizationChanged;

  /// Callback when create organization is tapped
  final VoidCallback? onCreateOrganization;

  /// Whether to show search (auto-enabled when >5 orgs)
  final bool? showSearch;

  /// Whether to show the create organization button
  final bool showCreateButton;

  /// Label for the create button
  final String? createButtonLabel;

  /// Hint text for search
  final String? searchHint;

  /// Style configuration
  final VooOrganizationSwitcherStyle? style;

  /// Whether to show in compact mode (avatar only)
  ///
  /// When null, auto-detects from [VooCollapseState] in widget tree.
  /// Set explicitly to override auto-detection.
  final bool? compact;

  /// Tooltip text
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

  /// Creates a copy with the given fields replaced
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
  }) => VooOrganizationSwitcherConfig(
    organizations: organizations ?? this.organizations,
    selectedOrganization: selectedOrganization ?? this.selectedOrganization,
    onOrganizationChanged: onOrganizationChanged ?? this.onOrganizationChanged,
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

  /// Callback when a navigation item is selected
  final ValueChanged<VooNavigationItem>? onNavigationItemSelected;

  /// Callback when a search action is selected
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

  /// Creates a copy with the given fields replaced
  VooSearchBarConfig copyWith({
    List<VooNavigationItem>? navigationItems,
    ValueChanged<List<VooNavigationItem>>? onFilteredItemsChanged,
    ValueChanged<String>? onSearch,
    VoidCallback? onSearchSubmit,
    List<VooSearchAction>? searchActions,
    String? hintText,
    bool? showFilteredResults,
    bool? enableKeyboardShortcut,
    String? keyboardShortcutHint,
    VooSearchBarStyle? style,
    bool? expanded,
    ValueChanged<VooNavigationItem>? onNavigationItemSelected,
    ValueChanged<VooSearchAction>? onSearchActionSelected,
  }) => VooSearchBarConfig(
    navigationItems: navigationItems ?? this.navigationItems,
    onFilteredItemsChanged: onFilteredItemsChanged ?? this.onFilteredItemsChanged,
    onSearch: onSearch ?? this.onSearch,
    onSearchSubmit: onSearchSubmit ?? this.onSearchSubmit,
    searchActions: searchActions ?? this.searchActions,
    hintText: hintText ?? this.hintText,
    showFilteredResults: showFilteredResults ?? this.showFilteredResults,
    enableKeyboardShortcut: enableKeyboardShortcut ?? this.enableKeyboardShortcut,
    keyboardShortcutHint: keyboardShortcutHint ?? this.keyboardShortcutHint,
    style: style ?? this.style,
    expanded: expanded ?? this.expanded,
    onNavigationItemSelected: onNavigationItemSelected ?? this.onNavigationItemSelected,
    onSearchActionSelected: onSearchActionSelected ?? this.onSearchActionSelected,
  );
}

/// Configuration for the notifications bell
class VooNotificationsBellConfig {
  /// List of notifications
  final List<VooNotificationItem> notifications;

  /// Override for unread count badge
  final int? unreadCount;

  /// Callback when a notification is tapped
  final ValueChanged<VooNotificationItem>? onNotificationTap;

  /// Callback when a notification is dismissed
  final ValueChanged<VooNotificationItem>? onNotificationDismiss;

  /// Callback when mark all as read is tapped
  final VoidCallback? onMarkAllRead;

  /// Callback when view all is tapped
  final VoidCallback? onViewAll;

  /// Maximum visible notifications in dropdown
  final int maxVisibleNotifications;

  /// Whether to show mark all as read button
  final bool showMarkAllRead;

  /// Whether to show view all button
  final bool showViewAllButton;

  /// Message to show when no notifications
  final String? emptyStateMessage;

  /// Style configuration
  final VooNotificationsBellStyle? style;

  /// Whether to show in compact mode
  final bool compact;

  /// Tooltip text
  final String? tooltip;

  /// Custom empty state widget
  final Widget? emptyStateWidget;

  /// Custom header widget for the dropdown
  final Widget? headerWidget;

  /// Custom footer widget for the dropdown
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

  /// Creates a copy with the given fields replaced
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
  }) => VooNotificationsBellConfig(
    notifications: notifications ?? this.notifications,
    unreadCount: unreadCount ?? this.unreadCount,
    onNotificationTap: onNotificationTap ?? this.onNotificationTap,
    onNotificationDismiss: onNotificationDismiss ?? this.onNotificationDismiss,
    onMarkAllRead: onMarkAllRead ?? this.onMarkAllRead,
    onViewAll: onViewAll ?? this.onViewAll,
    maxVisibleNotifications: maxVisibleNotifications ?? this.maxVisibleNotifications,
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
  /// List of quick actions
  final List<VooQuickAction> actions;

  /// Icon for the trigger button
  final IconData? triggerIcon;

  /// Custom trigger widget
  final Widget? triggerWidget;

  /// Tooltip for the trigger
  final String? tooltip;

  /// Whether to show labels in grid layout
  final bool showLabelsInGrid;

  /// Style configuration
  final VooQuickActionsStyle? style;

  /// Whether to show in compact mode
  final bool compact;

  /// Callback when an action is selected
  final ValueChanged<VooQuickAction>? onActionSelected;

  /// Whether to use grid layout
  final bool useGridLayout;

  /// Number of columns in grid layout
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

  /// Creates a copy with the given fields replaced
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
  }) => VooQuickActionsConfig(
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
///
/// Provides a simplified API for configuring the navigation header
/// with title, logo, and other common options.
///
/// For full customization, use [VooNavigationConfig.drawerHeader] instead.
class VooHeaderConfig {
  /// Title text displayed in the header
  final String? title;

  /// Logo widget to display (takes precedence over logoIcon)
  final Widget? logo;

  /// Icon to use for the logo when no logo widget is provided
  final IconData? logoIcon;

  /// Background color for the logo container
  final Color? logoBackgroundColor;

  /// Whether to show the title (hidden in compact/collapsed mode)
  final bool showTitle;

  /// Text style for the title
  final TextStyle? titleStyle;

  /// Padding around the header content
  final EdgeInsets? padding;

  /// Callback when the header is tapped
  final VoidCallback? onTap;

  const VooHeaderConfig({
    this.title,
    this.logo,
    this.logoIcon,
    this.logoBackgroundColor,
    this.showTitle = true,
    this.titleStyle,
    this.padding,
    this.onTap,
  });

  /// Creates a copy with the given fields replaced
  VooHeaderConfig copyWith({
    String? title,
    Widget? logo,
    IconData? logoIcon,
    Color? logoBackgroundColor,
    bool? showTitle,
    TextStyle? titleStyle,
    EdgeInsets? padding,
    VoidCallback? onTap,
  }) => VooHeaderConfig(
    title: title ?? this.title,
    logo: logo ?? this.logo,
    logoIcon: logoIcon ?? this.logoIcon,
    logoBackgroundColor: logoBackgroundColor ?? this.logoBackgroundColor,
    showTitle: showTitle ?? this.showTitle,
    titleStyle: titleStyle ?? this.titleStyle,
    padding: padding ?? this.padding,
    onTap: onTap ?? this.onTap,
  );
}

/// Configuration for breadcrumbs
class VooBreadcrumbsConfig {
  /// List of breadcrumb items
  final List<VooBreadcrumbItem> items;

  /// Callback when a breadcrumb is tapped
  final ValueChanged<VooBreadcrumbItem>? onItemTap;

  /// Custom separator widget
  final Widget? separator;

  /// Maximum visible items before collapsing
  final int? maxVisibleItems;

  /// Whether to show home icon for first item
  final bool showHomeIcon;

  /// Style configuration
  final VooBreadcrumbsStyle? style;

  const VooBreadcrumbsConfig({
    required this.items,
    this.onItemTap,
    this.separator,
    this.maxVisibleItems,
    this.showHomeIcon = true,
    this.style,
  });

  /// Creates a copy with the given fields replaced
  VooBreadcrumbsConfig copyWith({
    List<VooBreadcrumbItem>? items,
    ValueChanged<VooBreadcrumbItem>? onItemTap,
    Widget? separator,
    int? maxVisibleItems,
    bool? showHomeIcon,
    VooBreadcrumbsStyle? style,
  }) => VooBreadcrumbsConfig(
    items: items ?? this.items,
    onItemTap: onItemTap ?? this.onItemTap,
    separator: separator ?? this.separator,
    maxVisibleItems: maxVisibleItems ?? this.maxVisibleItems,
    showHomeIcon: showHomeIcon ?? this.showHomeIcon,
    style: style ?? this.style,
  );
}
