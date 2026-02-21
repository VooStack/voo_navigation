## 0.1.20

### Fixed
- **Action Modal Theming**: Fixed hard-coded white colors in action item modal's `ListTileThemeData`
  - `textColor` now uses `theme.colorScheme.onSurface`
  - `iconColor` now uses `theme.colorScheme.onSurfaceVariant`
  - Modal content now properly respects custom dark themes

### Dependencies
- Updated `voo_navigation_core` to ^0.2.29

---

## 0.1.19

### Fixed
- **White Screen on Mobile**: Fixed body not rendering when using `VooNavigationBar` as `bottomNavigationBar`
  - Root `Align` widget was not reporting proper intrinsic height to Scaffold
  - Wrapped in `SizedBox` with explicit height so Scaffold can properly calculate body constraints

---

## 0.1.18

### Fixed
- **Overlay Theming**: Fixed overlay components not inheriting app theme
  - `VooActionNavItem` and `VooExpandableNavModal` now capture and pass theme context to overlays

---

## 0.1.17

### Changed
- **Exports**: Updated navigation bar exports
- **Cleanup**: Removed unused floating navigation tokens

---

## 0.1.16

### Fixed
- **VooNavigationBar**: Action item now correctly centered based on total item count
  - Center calculation accounts for profile at end, not just regular items
  - Fixes action appearing at wrong position when profile has mobilePriority

### Dependencies
- Updated `voo_navigation_core` to ^0.2.25

---

## 0.1.15

### Fixed
- **VooNavigationBar**: User profile now correctly uses custom `id` from config
  - Selection state properly reflects when `selectedId` matches user profile's `effectiveId`
  - `onNavigationItemSelected` callback now passes the correct custom ID
  - Action item stays centered when user profile is positioned at start

### Added
- **VooNavigationBar**: Support for `VooUserProfilePosition` (start/end) from config

### Dependencies
- Updated `voo_navigation_core` to ^0.2.24

---

## 0.1.14

### Dependencies
- Updated `voo_navigation_core` to ^0.2.16

---

## 0.1.13

### Fixed
- **VooActionNavItem**: Fixed `AnimationController.reverse() called after dispose()` error
  - Overlay is now removed synchronously during dispose without animation

### Dependencies
- Updated `voo_navigation_core` to ^0.2.15

---

## 0.1.12

### Added
- **VooNavigationBar**: Action item can now be positioned at a specific index via `navItemIndex`

### Dependencies
- Updated `voo_navigation_core` to ^0.2.14

---

## 0.1.11

### Added
- **VooNavigationBar**: User profile can now be positioned at a specific index in the bottom nav bar
  - Respects `navItemIndex` from `VooUserProfileConfig`
  - Inserts user profile at the specified position instead of always at the end

### Dependencies
- Updated `voo_navigation_core` to ^0.2.13

---

## 0.1.10

### Fixed
- **VooUserProfileNavItem**: Fixed expand/collapse animation not triggering when tapped without a modal builder
  - Added `onNavigationSelected` callback parameter to notify the navigation bar of selection changes
  - `VooNavigationBar` now passes this callback to update the selection state, enabling proper expand animation

---

## 0.1.9

### Fixed
- **ExpandableNavModalMixin**: Changed mixin constraint from `SingleTickerProviderStateMixin` to `TickerProviderStateMixin` to support states that need multiple animation controllers
- **VooUserProfileNavItem**: Fixed "multiple tickers created" assertion error when using expand/collapse animation alongside modal animation
- **VooContextSwitcherExpandableNavItem**: Updated to use `TickerProviderStateMixin`
- **VooCombinedSwitcherNavItem**: Updated to use `TickerProviderStateMixin`
- **VooMultiSwitcherExpandableNavItem**: Updated to use `TickerProviderStateMixin`

---

## 0.1.8

### Improved
- **VooExpandableNavItem**: Enhanced expand/collapse animations and layout
  - Labels now expand to the right by default (unless action item is present)
  - Synced collapse animation with expand animation for smoother transitions
  - Collapse uses `easeInCubic` curve to free up space quickly as new item expands
  - Label opacity fades out faster during collapse (first 50% of animation)
  - Consistent 6dp padding around icon circle on all sides (top, left, bottom, right)
  - Added `maxLabelWidth` parameter for dynamic label width limits
- **VooUserProfileNavItem**: Matching expand animation improvements
  - Same synced animation curves as VooExpandableNavItem
  - Consistent padding and spacing with other nav items
  - Added `maxLabelWidth` parameter
- **VooNavigationBar**: Overflow prevention and dynamic sizing
  - Uses `FittedBox` with `scaleDown` to prevent overflow on narrow screens
  - Dynamically calculates `maxLabelWidth` based on available space and item count
  - Proper label position logic: right (end) by default, left (start) after action item

### Dependencies
- Updated `voo_navigation_core` to ^0.2.12

---

## 0.1.7

### Fixed
- **Bottom Navigation Bar Padding**: Reduced default bottom margin from 24px to 8px
  - Bottom navigation bar now sits closer to the bottom on devices with home indicator
  - Total bottom spacing = 8px margin + safe area inset (~42px total on iPhone)
  - Modal positioning updated to match new margin

### Added
- **VooUserProfileNavItem**: User profile avatar in bottom navigation
  - Displays user avatar image, or initials if no image provided
  - Opens custom modal when `modalBuilder` is configured in `VooUserProfileConfig`
  - Falls back to `onTap` callback when no modal builder provided
  - Integrates with `VooNavigationBar` automatically when `mobilePriority` is enabled

### Dependencies
- Updated `voo_navigation_core` to ^0.2.11

---

## 0.1.6

### Changed
- **VooNavigationBar**: Now uses expandable pill-shaped design as the default
  - Pill-shaped dark container with subtle border
  - Selected item expands to show colored circle icon + label
  - Unselected items display as dark circles with muted icons
  - Supports optional action item with custom modal (e.g., + button)
- **Context Switcher & Multi-Switcher**: Now use consistent expandable nav design
  - `VooContextSwitcherExpandableNavItem` - Context switcher as dark circle with overlay modal
  - `VooMultiSwitcherExpandableNavItem` - Org/user switcher as dark circle with stacked avatars and overlay modal
  - Both use the same modal design as the action item (consistent UI/UX)
- **Combined Switcher**: When both context switcher and multi-switcher are present, they automatically combine into a single `VooCombinedSwitcherNavItem`
  - Triple-stacked avatar icon showing context, organization, and user
  - Unified modal for switching all three in one place
  - Reduces nav bar clutter by consolidating into one item
- **Consolidated Components**: Merged multiple navigation bar variants into single `VooNavigationBar`
  - Removed `VooExpandableBottomNavigation` - use `VooNavigationBar` instead
  - Removed `VooAdaptiveBottomNavigation` - use `VooNavigationBar` instead
  - Removed `VooCustomNavigationBar` - use `VooNavigationBar` instead
- **VooNavigationItem**: Renamed from `VooCustomNavigationItem` for consistency

### Added
- `VooCombinedSwitcherNavItem` - Combined context + org/profile switcher for when both are present
- `VooExpandableNavModal` - Shared modal component for expandable nav items
- `ExpandableNavModalMixin` - Mixin for nav items that show overlay modals

### Dependencies
- Updated `voo_navigation_core` to ^0.2.10

---

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
