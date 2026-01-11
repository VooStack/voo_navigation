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
