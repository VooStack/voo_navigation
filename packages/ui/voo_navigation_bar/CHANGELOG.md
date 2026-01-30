## 0.1.5

### Improved
- **VooExpandableBottomNavigation**: Navigation bar now sizes to fit its contents
  - Removed forced full-width layout, bar expands/contracts based on items
  - Fixed 12px spacing between items for consistent layout
- **VooExpandableNavItem**: Improved spacing and animation
  - Cleaner spacing: 4px circle padding, 12px icon-to-text gap, 16px text padding
  - Smoother row-based animation that expands from icon position
  - Fixed overflow issues during animation

### Dependencies
- Updated `voo_navigation_core` to ^0.2.9

---

## 0.1.4

### Added
- **VooMultiSwitcherNavItem Integration**: Bottom navigation bars now support multi-switcher nav items
  - `VooFloatingBottomNavigation` renders `VooMultiSwitcherNavItem` for `_multi_switcher_nav` items
  - `VooCustomNavigationBar` renders `VooMultiSwitcherNavItem` for `_multi_switcher_nav` items
  - Stacked avatars display (org + user) with floating style

### Dependencies
- Updated `voo_navigation_core` to ^0.2.3

---

## 0.1.3

### Dependencies
- Updated `voo_navigation_core` to ^0.2.1 for flexible navigation item validation

---

## 0.1.2

### Fixed
- **Floating Bottom Navigation Theme**: Fixed hardcoded `Colors.black` background
  - Now uses `context.floatingNavBackground` (`surfaceContainerHighest`) from theme
  - Properly adapts to light and dark mode
- **Floating Nav Item Colors**: Fixed hardcoded `Colors.white` icons
  - Selected: Uses `theme.colorScheme.primary`
  - Unselected: Uses `theme.colorScheme.onSurface` with 50% opacity
  - Proper theme awareness for light/dark mode support

### Improved
- **Design System Tokens**: Bottom navigation components now use `VooNavigationTokens`
  - `VooCustomNavigationItem` - Simplified selection state to match drawer/rail (removed heavy border and shadow)
  - `VooFloatingNavItem` - Uses standardized icon sizes
- **Modernized Appearance**: Updated border radius to 8dp for consistency

### Dependencies
- Updated `voo_navigation_core` to ^0.1.4

---

## 0.1.1

### Fixed
- Updated to be compatible with `voo_navigation_core` 0.1.1 simplified theme API
- Removed dependency on deprecated theme properties (`VooNavigationBarType`, `VooNavigationPreset`, `containerBorderRadius`, `preset`, `blurSigma`, `surfaceOpacity`, etc.)

## 0.1.0

### Added
- Initial release - extracted from voo_navigation package
- **VooAdaptiveBottomNavigation**: Main bottom navigation organism
  - Supports Material 2, Material 3, and custom styles
  - Adaptive badge display
  - Floating mode support
- **VooFloatingBottomNavigation**: Modern floating bottom navigation bar
- **VooMaterial3NavigationBar**: Material 3 compliant navigation bar
- **VooMaterial2BottomNavigation**: Material 2 style bottom navigation
- **VooCustomNavigationBar**: Custom styled navigation bar
- **VooCustomNavigationItem**: Custom navigation item component
- **VooNavigationDropdown**: Dropdown component for expandable items
