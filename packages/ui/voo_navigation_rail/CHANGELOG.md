## 0.2.4

### Changed
- **Widget Icon Support**: Updated to support `Widget` type for icons (instead of `IconData`)
  - Enables full `IconTheme` support for consistent styling
  - Compatible with `Icon`, `ImageIcon`, or any custom widget

### Dependencies
- Updated `voo_navigation_core` to ^0.2.11

---

## 0.2.3

### Changed
- **NavigationDestination Support**: Updated to use renamed `VooNavigationDestination` from core

### Dependencies
- Updated `voo_navigation_core` to ^0.2.10

---

## 0.2.2

### Added
- **VooRailMultiSwitcher**: Rail support for multi-switcher (org/user switcher)
  - Follows existing `VooRailContextSwitcher` pattern
  - `forPosition()` factory method for position-based rendering
  - Supports `header`, `footer`, and `asNavItem` positions
- **Rail Container Integration**: `VooRailThemedContainer` now renders multi-switcher in all positions
  - Header position (after organization switcher)
  - Footer position (before user profile)
  - As nav item (before main navigation items)

### Dependencies
- Updated `voo_navigation_core` to ^0.2.3

---

## 0.2.1

### Improved
- **Tagline Layout**: Updated `VooRailDefaultHeader` to display tagline below title (when extended)
  - Title and tagline now render as two separate lines in a Column
  - Both texts limited to single line with ellipsis overflow
  - Consistent styling with drawer header

### Fixed
- **Header Height Alignment**: Header height now uses `kToolbarHeight + spacing.sm` to align with `VooAdaptiveAppBar`

---

## 0.2.0

### Dependencies
- Updated `voo_navigation_core` to ^0.2.0

---

## 0.1.2

### Improved
- **Design System Tokens**: All rail components now use `VooNavigationTokens` for consistent styling
  - `VooRailNavigationItem` - Uses token-based icon sizes, padding, border radius, and opacity values
  - Icon sizes now standardized: 18dp (extended) and 20dp (compact)
- **Modernized Appearance**: Updated border radius from 6dp to 8dp for modern look
- **Unified Selection States**: Selection and hover backgrounds now use theme-aware extension methods

### Dependencies
- Updated `voo_navigation_core` to ^0.1.4

---

## 0.1.1

### Added
- **VooCollapseState Integration**: Rail now wraps content with VooCollapseState
  - Enables child widgets to auto-detect collapse state
  - `onToggleCollapse` callback parameter for external collapse control
- **User Profile Auto-Handling**: Uses `userProfileConfig` when available
  - Automatically creates VooUserProfileFooter with correct compact state

### Changed
- **Unified Theme**: Removed legacy themed container variants
  - Removed glassmorphism, liquidGlass, blurry, neomorphism, material3Enhanced containers
  - Single clean flat container design for consistent appearance
  - Simpler codebase with ~400 lines removed

---

## 0.1.0

### Added
- Initial release - extracted from voo_navigation package
- **VooAdaptiveNavigationRail**: Main navigation rail organism with adaptive behavior
  - Supports compact and extended modes
  - Hover states and animations
  - Section headers and grouping
  - User profile footer integration
- **VooRailNavigationItems**: Container for rail navigation items
- **VooRailNavigationItem**: Individual rail item with selection states
- **VooRailDefaultHeader**: Default header component for rail
- **VooRailSectionHeader**: Section header for grouping items
- **VooRailModernBadge**: Badge component specific to rail styling
