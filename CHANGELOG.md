# Changelog

All notable changes to the voo_navigation workspace will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **VooContextSwitcher**: Inline context/project switching for dynamic navigation
  - Embed context switchers inside expandable navigation sections
  - Navigation items dynamically change based on selected context
  - Elegant pill-style card with color indicator and dropdown modal
  - Vertical line color syncs with selected context
- **VooMultiSwitcher**: Unified organization and user switching component
  - Combines org switching and user profile into single animated widget
  - Card shows stacked avatars, modal slides up as overlay
- Comprehensive README documentation for all packages
- LICENSE files for all packages (MIT)
- CHANGELOG files for workspace and example apps

## [1.2.0] - 2025-01-10

### Changed
- **Major Package Split**: Extracted navigation components into separate, focused packages for better modularity
  - `voo_navigation_core` (v0.1.0): Shared foundation - entities, atoms, molecules, and utilities
  - `voo_navigation_rail` (v0.1.0): Rail navigation components
  - `voo_navigation_drawer` (v0.1.0): Drawer navigation components
  - `voo_navigation_bar` (v0.1.0): Bottom navigation bar components
  - `voo_navigation` now acts as an orchestration layer, re-exporting all sub-packages

### Added
- Melos workspace configuration for monorepo management
- Workspace-level pubspec.yaml for coordinated development
- Individual package CHANGELOGs for version tracking

## Package Versions

| Package | Current Version |
|---------|-----------------|
| voo_navigation | 1.2.0 |
| voo_navigation_core | 0.1.0 |
| voo_navigation_rail | 0.1.0 |
| voo_navigation_drawer | 0.1.0 |
| voo_navigation_bar | 0.1.0 |

---

For detailed changes to individual packages, see their respective CHANGELOG files:
- [voo_navigation CHANGELOG](packages/ui/voo_navigation/CHANGELOG.md)
- [voo_navigation_core CHANGELOG](packages/ui/voo_navigation_core/CHANGELOG.md)
- [voo_navigation_rail CHANGELOG](packages/ui/voo_navigation_rail/CHANGELOG.md)
- [voo_navigation_drawer CHANGELOG](packages/ui/voo_navigation_drawer/CHANGELOG.md)
- [voo_navigation_bar CHANGELOG](packages/ui/voo_navigation_bar/CHANGELOG.md)
