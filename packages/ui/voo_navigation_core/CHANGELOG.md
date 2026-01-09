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
