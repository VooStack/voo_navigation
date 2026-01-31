## 0.2.13

### Added
- **VooUserProfileConfig**: Added `navItemIndex` property for explicit position control in mobile bottom navigation
  - Accepts values 0-4 to specify exact position in the bottom nav bar
  - When `null` (default), user profile appears at the end
- **VooActionNavigationItem**: Added `navItemIndex` property for explicit position control
  - Accepts values 0-4 to specify exact position in the bottom nav bar
  - Takes precedence over `position` property when specified
  - When `null` (default), falls back to `position` behavior (start/center/end)

### Fixed
- **VooNavigationTokens**: Made expandable bottom nav colors theme-aware for proper light/dark mode support
  - `expandableNavBackground` now uses `surfaceContainer` in light mode
  - `expandableNavUnselectedCircle` now uses `surfaceContainerHighest` in light mode
  - `expandableNavSelectedBackground` now uses `surfaceContainerHigh` in light mode
  - `expandableNavUnselectedIcon` now uses `onSurfaceVariant` in light mode
  - `expandableNavSelectedIcon` now uses `onPrimary` in light mode
  - `expandableNavSelectedLabel` now uses `onSurface` in light mode

---

## 0.2.12

### Changed
- **VooUserProfileConfig**: Updated `effectiveNavItemLabel` fallback priority
  - Now returns `navItemLabel ?? userEmail ?? userName ?? 'Profile'`
  - Email is now preferred over userName when no explicit label is set

---

## 0.2.11

### Changed
- **VooNavigationDestination**: Icon type changed from `IconData` to `Widget`
  - Now accepts `Icon` widgets directly instead of `IconData`
  - Enables full customization of icon size, color, and other properties at definition time
  - Components use `IconTheme` to apply default styling when needed
  - `effectiveSelectedIcon` getter now returns `Widget` instead of `IconData`

### Added
- **VooUserProfileConfig**: Added mobile bottom navigation support
  - `mobilePriority` - Include user profile in mobile bottom navigation
  - `modalBuilder` - Custom modal builder for profile tap action in bottom nav
  - `navItemSortOrder` - Control positioning in bottom navigation
  - `navItemLabel` - Custom label for the nav item
  - `effectiveInitials` - Getter to derive initials from userName
  - `effectiveNavItemLabel` - Getter for resolved nav item label
- **VooUserProfileModalData**: Data class for modal builder callback

---

## 0.2.10

### Changed
- **NavigationItem → NavigationDestination**: Renamed `VooNavigationItem` to `VooNavigationDestination` for clarity
  - File renamed from `navigation_item.dart` to `navigation_destination.dart`
  - All usages updated across the package
- **VooCustomIndicator → VooScaleIndicator**: Renamed indicator for clarity
  - File renamed from `voo_custom_indicator.dart` to `voo_scale_indicator.dart`

### Updated
- Various component improvements and refinements

---

## 0.2.9

### Improved
- **Expandable Nav Tokens**: Updated design tokens for expandable bottom navigation
  - Increased `expandableNavBarHeight` from 56 to 64 for better proportions
  - Increased `expandableNavSelectedCircleSize` from 38 to 44 for larger tap targets
  - Increased `expandableNavBarPaddingHorizontal/Vertical` from 6 to 8
  - Increased `expandableNavAnimationDurationMs` from 250 to 300 for smoother animations
  - Added `expandableNavItemSpacing` token (8px)

---

## 0.2.8

### Fixed
- **Floating Nav Background Color**: Changed `floatingNavBackground` token from `surfaceContainerHighest` to `surface`
  - Floating bottom navigation bar now renders with a clean white background in light mode instead of noticeable grey
  - Dark mode continues to work correctly with the dark surface color
  - Shadow contrast is improved since the background is no longer grey

---

## 0.2.7

### Fixed
- **Mobile App Bar Leading Widget Taking Up Space**: Fixed `VooMobileAppBar` reserving space for the leading widget even when no content is shown
  - Uses `VooAppBarLeading.wouldShowContent()` to check if content would be rendered before building
  - Sets `leadingWidth: 0` when no leading content exists
  - Changed `automaticallyImplyLeading` to `false` to prevent Flutter from implying a leading widget
  - Mirrors the fix already applied to `VooAdaptiveAppBar` in v0.2.5

---

## 0.2.6

### Added
- **VooMultiSwitcherConfig.isLoading**: New `isLoading` field for the multi-switcher (user/org switcher)
  - Shows a `CircularProgressIndicator` in place of the chevron on the card when loading
  - Disables tap interaction on the card while loading
  - Passed through to `VooMultiSwitcherCardData` and `VooMultiSwitcherModalData` for custom builders

---

## 0.2.5

### Added
- **VooAppBarLeading.wouldShowContent()**: New static helper method to check if the leading widget would render actual content
  - Useful for determining if `leadingWidth` should be set to 0 in AppBar to avoid empty space

---

## 0.2.4

### Fixed
- **shouldShowBackButton Not Working**: Fixed `VooPageConfig.shouldShowBackButton` not showing the back button
  - `VooAppBarLeading.build()` was short-circuiting on `!showMenuButton` before checking `shouldShowBackButton`
  - Reordered logic so `shouldShowBackButton` is evaluated even when `showMenuButton=false`
  - `VooMobileAppBar` now always creates `VooAppBarLeading` so back button logic can run

---

## 0.2.3

### Added
- **VooMultiSwitcherNavItem**: Mobile navigation support for the multi-switcher (org/user switcher)
  - Displays stacked avatars (organization + user) in compact form
  - Supports `isCompact`, `useFloatingStyle`, `enableHapticFeedback` properties
  - Opens `VooMultiSwitcherBottomSheet` on tap with combined organization and user sections
- **VooMultiSwitcherBottomSheet**: Bottom sheet modal for mobile multi-switcher interaction
  - Shows organization section with search (if enabled)
  - Shows user section with account info, multi-account list, settings, and logout
  - Reuses existing `VooMultiSwitcherOrganizationSection` and `VooMultiSwitcherUserSection`
- **VooMultiSwitcherConfig**: Added mobile nav item properties
  - `showAsNavItem` - Whether to show as navigation item
  - `mobilePriority` - Include in mobile priority items (max 5)
  - `navItemSortOrder` - Sort order among priority items
  - `navItemLabel` - Optional label for the nav item
- **VooMultiSwitcherPosition**: Added `asNavItem` position for rendering as navigation item
- **VooNavigationConfig**: Updated `mobilePriorityItems` getter to include multi-switcher when configured with `mobilePriority: true`

---

## 0.2.2

### Added
- **VooPageConfig**: Added `shouldShowBackButton` property for per-page back button control
  - `null` (default): Auto behavior based on `Navigator.canPop()`
  - `true`: Always show the back button
  - `false`: Never show the back button
- **VooPageConfig**: Added `wrapInScaffold` property for simple scaffold wrapping
  - When `true`, wraps the page child in a basic `Scaffold(body: child)`
  - Simpler alternative to `useCustomScaffold` + `scaffoldBuilder`
- **VooAppBarLeading**: Added `pageConfig` parameter to pass `VooPageConfig` for back button control
- **VooMobileAppBar**: Added `pageConfig` parameter to pass to `VooAppBarLeading`

---

## 0.2.1

### Changed
- **VooNavigationItem**: Removed strict assertion requiring `route`, `destination`, `onTap`, or `children`
  - Items can now be created without navigation callbacks when using scaffold-level `onNavigationItemSelected`
  - Cleaned up `VooNavigationItem.divider()` factory to no longer require unnecessary `onTap`

### Added
- **VooNavigationConfig**: Added validation that ensures navigation is properly configured
  - When `onNavigationItemSelected` is provided, items don't need individual navigation callbacks
  - When `onNavigationItemSelected` is NOT provided, items must have `route`, `destination`, `onTap`, or `children`
  - Dividers are automatically skipped during validation
  - Recursive validation for nested children items

---

## 0.2.0

### Added
- **VooContextSwitcher**: Inline context/project switching component for dynamic navigation
  - `VooContextItem` - Entity representing a switchable context (project, workspace, environment)
  - `VooContextSwitcherConfig` - Main configuration class with items, callbacks, and customization
  - `VooContextSwitcherStyle` - Style configuration for card, modal, and item appearance
  - `VooContextSwitcherPosition` - Enum for positioning (beforeItems, afterHeader)
- **Context Switcher Widgets**:
  - `VooContextSwitcher` - Main widget combining card and modal with overlay animation
  - `VooContextSwitcherCard` - Elegant pill-style selector with color indicator dot
  - `VooContextSwitcherModal` - Dropdown modal with context list, search, and create button
- **Navigation Item Enhancement**:
  - `sectionHeaderWidget` - Embed custom widgets (like context switcher) inside expandable sections
  - `sectionHeaderLineColor` - Custom color for the vertical line next to section header widgets
- **Custom Builders**: Full customization support with `cardBuilder` and `modalBuilder`

- **VooMultiSwitcher**: Unified organization and user switching component
  - `VooMultiSwitcherConfig` - Main configuration class for the multi-switcher
  - `VooMultiSwitcherUser` - Entity representing a switchable user account
  - `VooMultiSwitcherStyle` - Style configuration for card, modal, and sections
  - `VooMultiSwitcherPosition` - Enum for positioning (header, footer)
- **Multi-Switcher Widgets**:
  - `VooMultiSwitcher` - Main widget combining card and modal with overlay animation
  - `VooMultiSwitcherCard` - Closed state showing stacked org + user avatars
  - `VooMultiSwitcherModal` - Expanded state with organization and user sections
  - `VooMultiSwitcherOrganizationSection` - Organization list with selection
  - `VooMultiSwitcherUserSection` - User info with settings and logout actions
  - `VooStackedAvatars` - Overlapping org + user avatar display
  - `VooMultiSwitcherOrgTile`, `VooMultiSwitcherUserTile`, `VooMultiSwitcherActionTile` - List tiles
- **Custom Builders**: Full customization support with `cardBuilder` and `modalBuilder`
- **Animation**: Smooth overlay animation with spring physics using `Curves.easeOutBack`

### Changed
- `VooNavigationConfig` now includes `multiSwitcher` and `multiSwitcherPosition` fields

---

## 0.1.4

### Added
- **VooNavigationTokens**: New centralized design tokens for consistent styling across all navigation components
  - `VooNavigationTokens` class with static constants for icon sizes, spacing, typography, border radius, and opacity values
  - `VooNavigationTokensTheme` extension on `BuildContext` for theme-aware color generation:
    - `context.navSelectedBackground([customColor])` - Selected item background with 10% opacity
    - `context.navHoverBackground` - Hover background with 4% opacity
    - `context.navMutedIconColor` - Muted icon color with 70% opacity
    - `context.floatingNavBackground` - Theme-aware floating nav background (surface)
    - `context.floatingNavForeground` - Floating nav foreground color
    - `context.floatingNavSelectedColor` - Primary color for selected floating nav items
    - `context.navDividerColor` - Divider color with proper opacity
    - `context.navBorderSubtle` - Subtle border color

### Improved
- **Design System Consistency**: All navigation packages now use shared tokens from `voo_navigation_core`
- **Modern Appearance**: Updated default `itemBorderRadius` to 8dp for a more modern look

---

## 0.1.3

### Fixed
- **VooPageConfig Properties Not Applied**: Fixed `appBarTitle`, `appBarLeading`, and `additionalAppBarActions` from `VooPageConfig` not being applied to the app bar
  - Added `additionalActions` parameter to `VooMobileAppBar` to support appending actions to the default actions
  - Actions are now properly merged instead of being ignored

---

## 0.1.1

### Added
- **VooCollapseState**: InheritedWidget for propagating collapse state to descendants
  - Enables auto-detection of compact mode for child widgets
  - `VooCollapseState.isCollapsedOf(context)` to read collapse state
  - `VooCollapseState.toggleCallbackOf(context)` to get toggle callback
- **VooUserProfileConfig**: Data-only config class for user profile
  - Simpler API for configuring user profile in navigation
  - Auto-handles compact mode based on VooCollapseState

### Changed
- **Default Behavior**: Made collapsible navigation and user profile the default
  - `enableCollapsibleRail` now defaults to `true`
  - `showUserProfile` now defaults to `true`
- **VooUserProfileFooter**: `compact` parameter now nullable (`bool?`)
  - When null, auto-detects from VooCollapseState in widget tree
- **VooOrganizationSwitcher**: `compact` parameter now nullable (`bool?`)
  - When null, auto-detects from VooCollapseState in widget tree
- **Unified Theme**: Default theme changed to clean flat design
  - Default theme is now `minimalModern` with `containerBorderRadius: 0`
  - `navigationRailMargin` defaults to `0` (flush to edge)

---

## 0.1.0

### Added
- Initial release - extracted from voo_navigation package
- **Domain Entities**: Core navigation configuration and data models
  - `VooNavigationType` - Navigation layout types (bottomNavigation, navigationRail, extendedNavigationRail, navigationDrawer)
  - `VooNavigationItem` - Navigation item with icons, labels, badges, routing
  - `VooNavigationConfig` - Master configuration for navigation system
  - `VooBreakpoint` - Responsive breakpoints with Material 3 defaults
  - `VooNavigationTheme` - Visual styling configuration (glassmorphism, liquidGlass, blurry, neomorphism, material3Enhanced, minimalModern)
  - `VooNavigationRoute` - GoRouter integration routes
  - `VooNavigationSection` - Hierarchical navigation grouping
  - `VooPageConfig` - Per-page scaffold customization

- **Atoms**: 20 foundational UI components
  - Badges: `VooAnimatedBadge`, `VooModernBadge`, `VooDotBadge`, `VooTextBadge`, `VooIconWithBadge`
  - Indicators: `VooNavigationIndicator`, `VooThemedIndicator`, `VooLineIndicator`, `VooPillIndicator`, `VooGlowIndicator`, `VooCustomIndicator`, `VooBackgroundIndicator`
  - Icons: `VooNavigationIcon`, `VooAnimatedIcon`, `VooModernIcon`
  - Labels: `VooNavigationLabel`
  - Surfaces: `VooGlassSurface`, `VooLiquidGlassSurface`, `VooNeomorphSurface`
  - Controls: `VooCollapseToggle`

- **Molecules**: 12 composite components
  - App Bar: `VooMobileAppBar`, `VooAppBarLeading`, `VooAppBarTitle`, `VooAppBarActions`
  - Themed: `VooThemedNavItem`, `VooThemedNavContainer`
  - Generic: `VooNavigationBadge`, `VooNavigationItemWidget`, `VooDropdownHeader`, `VooDropdownChildren`, `VooDropdownChildItem`
  - User Profile: `VooUserProfileFooter`

- **Utils**: Navigation helper utilities
  - `VooNavigationAnimations` - Animation presets and transitions
  - `VooNavigationHelper` - Static helper methods for navigation
  - `VooNavigationInherited` - InheritedWidget for config propagation
