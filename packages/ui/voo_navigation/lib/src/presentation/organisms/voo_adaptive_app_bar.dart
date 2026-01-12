import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Adaptive app bar that adjusts based on screen size and navigation type
///
/// Automatically integrates common navigation elements from [VooNavigationConfig]:
/// - **Notifications Bell**: Shown in actions when [VooNavigationConfig.notificationsBell] is configured
/// - **Breadcrumbs**: Shown after title when [VooNavigationConfig.showBreadcrumbsInAppBar] is true
/// - **Search Bar**: Shown in actions when [VooNavigationConfig.searchBarPosition] is [VooSearchBarPosition.appBar]
class VooAdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Navigation configuration (optional if provided at scaffold level)
  final VooNavigationConfig? config;

  /// Currently selected item ID (optional if config is provided)
  final String? selectedId;

  /// Callback when an item is selected (optional if config is provided)
  final void Function(String itemId)? onNavigationItemSelected;

  /// Whether to show menu button (for drawer)
  final bool showMenuButton;

  /// Custom title widget
  final Widget? title;

  /// Custom leading widget
  final Widget? leading;

  /// Custom actions
  final List<Widget>? actions;

  /// Whether to center the title
  final bool? centerTitle;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom foreground color
  final Color? foregroundColor;

  /// Custom elevation
  final double? elevation;

  /// Custom toolbar height
  final double? toolbarHeight;

  /// Whether to show bottom border
  final bool showBottomBorder;

  /// Custom scroll behavior
  final ScrollNotificationPredicate notificationPredicate;

  /// Optional margin around the app bar
  final EdgeInsets? margin;

  const VooAdaptiveAppBar({
    super.key,
    this.config,
    this.selectedId,
    this.onNavigationItemSelected,
    this.showMenuButton = true,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.toolbarHeight,
    this.showBottomBorder = false,
    this.margin,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  });

  @override
  Size get preferredSize {
    const spacingTokens = VooSpacingTokens();
    final marginVertical = (margin?.top ?? 0) + (margin?.bottom ?? 0);
    // Height = toolbarHeight + spacing.sm (internal padding) + 1 (bottom border) + margin
    return Size.fromHeight(
      (toolbarHeight ?? kToolbarHeight) + spacingTokens.sm + 1 + marginVertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Try to get config from scaffold if not provided
    final effectiveConfig = config ?? _getConfigFromScaffold(context);
    final effectiveSelectedId = selectedId ?? _getSelectedIdFromScaffold(context);

    // Get the selected navigation item for title (if config is available)
    final selectedItem = effectiveConfig != null && effectiveSelectedId != null
        ? effectiveConfig.items.firstWhere((item) => item.id == effectiveSelectedId, orElse: () => effectiveConfig.items.first)
        : null;

    // Build title with optional breadcrumbs
    Widget effectiveTitle;
    if (title != null) {
      effectiveTitle = title!;
    } else if (effectiveConfig?.appBarTitleBuilder != null) {
      final customTitle = effectiveConfig!.appBarTitleBuilder!.call(effectiveSelectedId);
      effectiveTitle = customTitle ?? const Text('');
    } else if (selectedItem != null) {
      // Check if breadcrumbs should be shown in app bar
      if (effectiveConfig?.showBreadcrumbsInAppBar == true &&
          effectiveConfig?.breadcrumbs != null) {
        final breadcrumbsConfig = effectiveConfig!.breadcrumbs!;
        effectiveTitle = Row(
          children: [
            VooAppBarTitle(item: selectedItem, config: effectiveConfig),
            const SizedBox(width: 16),
            Expanded(
              child: VooBreadcrumbs(
                items: breadcrumbsConfig.items,
                onItemTap: breadcrumbsConfig.onItemTap,
                separator: breadcrumbsConfig.separator,
                maxVisibleItems: breadcrumbsConfig.maxVisibleItems,
                showHomeIcon: breadcrumbsConfig.showHomeIcon,
                style: breadcrumbsConfig.style,
              ),
            ),
          ],
        );
      } else {
        effectiveTitle = VooAppBarTitle(item: selectedItem, config: effectiveConfig);
      }
    } else {
      effectiveTitle = const Text('');
    }

    final effectiveLeading =
        leading ??
        effectiveConfig?.appBarLeadingBuilder?.call(effectiveSelectedId) ??
        (showMenuButton ? VooAppBarLeading(showMenuButton: showMenuButton, config: effectiveConfig) : null);

    // Build actions with integrated components
    List<Widget>? effectiveActions;
    if (actions != null) {
      effectiveActions = actions;
    } else if (effectiveConfig?.appBarActionsBuilder != null) {
      effectiveActions = effectiveConfig!.appBarActionsBuilder!.call(effectiveSelectedId);
    } else {
      // Build default actions with integrated components
      effectiveActions = _buildIntegratedActions(context, effectiveConfig);
    }

    final effectiveCenterTitle = centerTitle ?? effectiveConfig?.centerAppBarTitle ?? false;
    // When appBarAlongsideRail is true, the app bar is inside the content container
    // so it should be transparent to show the container's background
    final isInsideContentContainer = effectiveConfig?.appBarAlongsideRail ?? true;
    final effectiveBackgroundColor = backgroundColor ??
        (isInsideContentContainer ? Colors.transparent : colorScheme.surface);
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;

    // Align app bar title with the vertical center of the collapse toggle icon
    // The collapse icon is centered within the drawer header row (between title and tagline)
    // Fine-tuned offset to match the icon's vertical center
    final titleTopPadding = 6.0;

    return Container(
      margin: margin,
      color: effectiveBackgroundColor,
      child: AppBar(
          title: Padding(
            padding: EdgeInsets.only(
              left: context.vooSpacing.xs,
              right: context.vooSpacing.xs,
              top: titleTopPadding,
            ),
            child: effectiveTitle,
          ),
          leading: effectiveLeading,
          automaticallyImplyLeading: effectiveLeading != null,
          actions: effectiveActions?.isNotEmpty == true ? [...effectiveActions!, SizedBox(width: context.vooSpacing.md)] : null,
          centerTitle: effectiveCenterTitle,
          backgroundColor: Colors.transparent,
          foregroundColor: effectiveForegroundColor,
          elevation: 0,
          toolbarHeight: (toolbarHeight ?? kToolbarHeight) + context.vooSpacing.sm,
          titleSpacing: context.vooSpacing.md,
          titleTextStyle: theme.textTheme.titleLarge?.copyWith(color: effectiveForegroundColor, fontWeight: FontWeight.w600),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: context.vooSize.borderThin, color: theme.dividerColor.withValues(alpha: 0.08)),
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: theme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
            statusBarBrightness: theme.brightness,
          ),
        ),
    );
  }

  VooNavigationConfig? _getConfigFromScaffold(BuildContext context) => VooNavigationInherited.maybeOf(context)?.config;

  String? _getSelectedIdFromScaffold(BuildContext context) => VooNavigationInherited.maybeOf(context)?.selectedId;

  /// Builds the integrated actions list with search bar, notifications bell, etc.
  List<Widget>? _buildIntegratedActions(
      BuildContext context, VooNavigationConfig? config) {
    if (config == null) return null;

    final List<Widget> actionWidgets = [];

    // Add search bar in app bar position
    if (config.searchBar != null &&
        config.searchBarPosition == VooSearchBarPosition.appBar) {
      final searchConfig = config.searchBar!;
      actionWidgets.add(
        SizedBox(
          width: 280,
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
            expanded: false,
            onNavigationItemSelected: searchConfig.onNavigationItemSelected,
            onSearchActionSelected: searchConfig.onSearchActionSelected,
          ),
        ),
      );
    }

    // Add notifications bell
    if (config.notificationsBell != null) {
      final notifConfig = config.notificationsBell!;
      actionWidgets.add(
        VooNotificationsBell(
          notifications: notifConfig.notifications,
          unreadCount: notifConfig.unreadCount,
          onNotificationTap: notifConfig.onNotificationTap,
          onNotificationDismiss: notifConfig.onNotificationDismiss,
          onMarkAllRead: notifConfig.onMarkAllRead,
          onViewAll: notifConfig.onViewAll,
          maxVisibleNotifications: notifConfig.maxVisibleNotifications,
          showMarkAllRead: notifConfig.showMarkAllRead,
          showViewAllButton: notifConfig.showViewAllButton,
          emptyStateMessage: notifConfig.emptyStateMessage,
          style: notifConfig.style,
          compact: notifConfig.compact,
          emptyStateWidget: notifConfig.emptyStateWidget,
          headerWidget: notifConfig.headerWidget,
          footerWidget: notifConfig.footerWidget,
        ),
      );
    }

    return actionWidgets.isEmpty ? null : actionWidgets;
  }
}

/// Function to determine if a notification should be handled
bool defaultScrollNotificationPredicate(ScrollNotification notification) => notification.depth == 0;
