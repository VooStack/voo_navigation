## 0.2.0

### Added
- **VooMultiSwitcher Integration**: Unified organization and user switching in drawer footer
  - `VooDrawerMultiSwitcher` - Drawer wrapper with `forPosition()` factory method
  - Replaces separate org switcher and user profile with single animated component
  - Slides up as overlay within drawer using Flutter's `Overlay` system
  - Tap outside to dismiss modal
- **VooAdaptiveNavigationDrawer** now renders `VooMultiSwitcher` when configured
  - Backwards compatible - existing org switcher and user profile still work
  - Set `multiSwitcher` config and `showUserProfile: false` to use new component

### Dependencies
- Updated `voo_navigation_core` to ^0.2.0

---

## 0.1.4

### Improved
- **Design System Tokens**: All drawer components now use `VooNavigationTokens` for consistent styling
  - `VooDrawerNavigationItem` - Uses token-based icon sizes, padding, border radius, and opacity values
  - `VooDrawerFooterItem` - Consistent styling with navigation items
  - `VooDrawerChildNavigationItem` - Uses child-specific padding tokens
- **Modernized Appearance**: Updated border radius from 6dp to 8dp for modern look
- **Unified Selection States**: Selection and hover backgrounds now use theme-aware extension methods

### Dependencies
- Updated `voo_navigation_core` to ^0.1.4

---

## 0.1.3

### Fixed
- **Logo Widget Support**: `VooDrawerDefaultHeader` now supports custom `logo` widget from `VooHeaderConfig`
  - Added `logo` and `logoBackgroundColor` parameters to `VooDrawerDefaultHeader`
  - `VooDrawerHeader` now passes logo properties from `headerConfig`
  - Logo widget now applies consistently to both rail and drawer navigation

---

## 0.1.2

### Changed
- Internal dependency updates

---

## 0.1.1

### Added
- **VooCollapseState Integration**: Drawer now wraps content with VooCollapseState
  - Enables child widgets to auto-detect collapse state
  - `onToggleCollapse` callback parameter for external collapse control
- **User Profile Auto-Handling**: Uses `userProfileConfig` when available
  - Automatically creates VooUserProfileFooter with correct compact state

### Changed
- **Unified Theme**: Removed legacy themed container variants
  - Removed glassmorphism, liquidGlass, blurry, neomorphism, material3Enhanced containers
  - Single clean flat container design for consistent appearance
  - Simpler codebase with ~500 lines removed

### Fixed
- **Vertical Line Alignment**: Fixed expandable section indicator lines
  - Lines now horizontally align with parent section icon center (17px from left)
  - Added connector line that extends from section icon down to children
  - Uses `clipBehavior: Clip.none` to allow line to extend into header area

---

## 0.1.0

### Added
- Initial release - extracted from voo_navigation package
- **VooAdaptiveNavigationDrawer**: Main navigation drawer organism
  - Supports expandable sections
  - User profile footer integration
  - Custom header and footer widgets
  - Themed styling support
- **DrawerNavigationItem**: Individual drawer navigation item
- **DrawerNavigationItems**: Container for drawer navigation items
- **DrawerChildNavigationItem**: Child item for expandable sections
- **DrawerExpandableSection**: Expandable section with children
- **DrawerDefaultHeader**: Default header component for drawer
- **DrawerModernBadge**: Badge component specific to drawer styling
