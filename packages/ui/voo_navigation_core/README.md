# voo_navigation_core

[![Version](https://img.shields.io/badge/version-0.1.0-blue)](pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Core foundation package for the voo_navigation ecosystem. Contains shared entities, atoms, molecules, and utilities for building adaptive navigation in Flutter.

## Overview

This package provides the foundational building blocks used by all voo_navigation sub-packages:

- **Domain Entities**: Configuration and data models
- **Atoms**: 20+ foundational UI components
- **Molecules**: 12+ composite components
- **Utils**: Navigation helpers and animations

## Installation

```yaml
dependencies:
  voo_navigation_core: ^0.1.0
```

> **Note**: You typically don't need to install this package directly. It's automatically included when using the main `voo_navigation` package or any of its sub-packages (`voo_navigation_rail`, `voo_navigation_drawer`, `voo_navigation_bar`).

## Components

### Domain Entities

| Entity | Description |
|--------|-------------|
| `VooNavigationType` | Navigation layout types (bottomNavigation, navigationRail, etc.) |
| `VooNavigationItem` | Navigation item with icons, labels, badges, and routing |
| `VooNavigationConfig` | Master configuration for the navigation system |
| `VooBreakpoint` | Responsive breakpoints with Material 3 defaults |
| `VooNavigationTheme` | Visual styling (glassmorphism, liquidGlass, neomorphism, etc.) |
| `VooNavigationRoute` | GoRouter integration routes |
| `VooNavigationSection` | Hierarchical navigation grouping |
| `VooPageConfig` | Per-page scaffold customization |

### Atoms

Foundational UI components following atomic design principles:

**Badges**
- `VooAnimatedBadge` - Badge with scale animations
- `VooModernBadge` - Modern styled badge
- `VooDotBadge` - Simple notification dot
- `VooTextBadge` - Text-based badge
- `VooIconWithBadge` - Icon with attached badge

**Indicators**
- `VooNavigationIndicator` - Base selection indicator
- `VooThemedIndicator` - Theme-aware indicator
- `VooLineIndicator` - Line-style indicator
- `VooPillIndicator` - Pill-shaped indicator
- `VooGlowIndicator` - Glowing effect indicator
- `VooBackgroundIndicator` - Background highlight indicator

**Icons & Labels**
- `VooNavigationIcon` - Navigation icon with states
- `VooAnimatedIcon` - Animated icon transitions
- `VooModernIcon` - Modern styled icon
- `VooNavigationLabel` - Navigation text label

**Surfaces**
- `VooGlassSurface` - Glassmorphism surface with blur
- `VooLiquidGlassSurface` - Liquid glass effect surface
- `VooNeomorphSurface` - Neomorphism surface with shadows

**Controls**
- `VooCollapseToggle` - Collapse/expand toggle button

### Molecules

Composite components built from atoms:

**App Bar Components**
- `VooMobileAppBar` - Mobile-optimized app bar
- `VooAppBarLeading` - App bar leading widget
- `VooAppBarTitle` - App bar title with animations
- `VooAppBarActions` - App bar action buttons

**Themed Components**
- `VooThemedNavItem` - Theme-aware navigation item
- `VooThemedNavContainer` - Theme-aware container

**User Profile**
- `VooUserProfileFooter` - User profile footer component

### Utilities

- `VooNavigationAnimations` - Animation presets and transitions
- `VooNavigationHelper` - Static helper methods
- `VooNavigationInherited` - InheritedWidget for config propagation

## Usage

```dart
import 'package:voo_navigation_core/voo_navigation_core.dart';

// Create navigation items
final items = [
  VooNavigationItem(
    id: 'home',
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
  ),
  VooNavigationItem(
    id: 'settings',
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];

// Create configuration
final config = VooNavigationConfig(
  items: items,
  selectedId: 'home',
  onNavigationItemSelected: (id) => print('Selected: $id'),
);
```

## Theme Presets

The package includes several visual theme presets:

```dart
// Glassmorphism - frosted glass effect
VooNavigationConfig.glassmorphism(items: items, selectedId: selectedId)

// Liquid Glass - deep blur with layered effects
VooNavigationConfig.liquidGlass(items: items, selectedId: selectedId)

// Blurry - clean frosted blur
VooNavigationConfig.blurry(items: items, selectedId: selectedId)

// Neomorphism - soft embossed effect
VooNavigationConfig.neomorphism(items: items, selectedId: selectedId)

// Material 3 Enhanced - polished Material 3
VooNavigationConfig.material3Enhanced(items: items, selectedId: selectedId)

// Minimal Modern - clean flat design
VooNavigationConfig.minimalModern(items: items, selectedId: selectedId)
```

## Architecture

This package follows clean architecture with atomic design:

```
lib/
├── src/
│   ├── domain/
│   │   └── entities/       # Core business entities
│   └── presentation/
│       ├── atoms/          # Basic UI building blocks
│       ├── molecules/      # Composite components
│       └── utils/          # Helper utilities
└── voo_navigation_core.dart
```

## Related Packages

| Package | Description |
|---------|-------------|
| [voo_navigation](../voo_navigation) | Main orchestration package |
| [voo_navigation_rail](../voo_navigation_rail) | Navigation rail components |
| [voo_navigation_drawer](../voo_navigation_drawer) | Navigation drawer components |
| [voo_navigation_bar](../voo_navigation_bar) | Bottom navigation components |

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and follow the code style defined in the project.

---

Built by [VooStack](https://voostack.com)
