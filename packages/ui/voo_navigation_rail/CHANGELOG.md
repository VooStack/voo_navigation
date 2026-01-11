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
