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
