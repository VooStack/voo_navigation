# voo_navigation_rail

[![Version](https://img.shields.io/badge/version-0.1.0-blue)](pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Navigation rail components for Flutter - part of the voo_navigation package ecosystem. Provides adaptive navigation rails for tablet and desktop layouts with Material 3 design.

## Features

- Adaptive compact and extended modes
- Smooth hover states and animations
- Section headers and item grouping
- User profile footer integration
- Theme preset support (glassmorphism, neomorphism, etc.)
- Material 3 compliant design

## Installation

```yaml
dependencies:
  voo_navigation_rail: ^0.1.0
```

Or use the main package which includes all navigation components:

```yaml
dependencies:
  voo_navigation: ^1.2.0
```

## Components

| Component | Description |
|-----------|-------------|
| `VooAdaptiveNavigationRail` | Main navigation rail organism with adaptive behavior |
| `VooRailNavigationItems` | Container for rail navigation items |
| `VooRailNavigationItem` | Individual rail item with selection states |
| `VooRailDefaultHeader` | Default header component for rail |
| `VooRailSectionHeader` | Section header for grouping items |
| `VooRailModernBadge` | Badge component specific to rail styling |

## Usage

### Basic Navigation Rail

```dart
import 'package:voo_navigation_rail/voo_navigation_rail.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

VooAdaptiveNavigationRail(
  config: VooNavigationConfig(
    items: [
      VooNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
      ),
      VooNavigationItem(
        id: 'search',
        label: 'Search',
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
      ),
      VooNavigationItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outlined,
        selectedIcon: Icons.person,
      ),
    ],
    selectedId: 'home',
    onNavigationItemSelected: (id) {
      // Handle navigation
    },
  ),
  extended: false, // true for extended mode with labels
)
```

### Extended Mode

The navigation rail supports two display modes:

**Compact Mode** (< 840px): Icon-only display
- 80px width
- 48x48px items
- Tooltips for labels

**Extended Mode** (>= 840px): Icon + label display
- Variable width
- Icon with horizontal label
- Full item interactions

```dart
VooAdaptiveNavigationRail(
  config: config,
  extended: true, // Shows icons with labels
)
```

### With Sections

Group navigation items into collapsible sections:

```dart
VooAdaptiveNavigationRail(
  config: VooNavigationConfig(
    items: [
      VooNavigationItem.section(
        label: 'Main',
        children: [
          VooNavigationItem(id: 'home', label: 'Home', icon: Icons.home),
          VooNavigationItem(id: 'dashboard', label: 'Dashboard', icon: Icons.dashboard),
        ],
      ),
      VooNavigationItem.section(
        label: 'Settings',
        children: [
          VooNavigationItem(id: 'profile', label: 'Profile', icon: Icons.person),
          VooNavigationItem(id: 'settings', label: 'Settings', icon: Icons.settings),
        ],
      ),
    ],
    selectedId: 'home',
    onNavigationItemSelected: (id) {},
  ),
)
```

### With Badges

Display notification badges on items:

```dart
VooNavigationItem(
  id: 'messages',
  label: 'Messages',
  icon: Icons.message_outlined,
  selectedIcon: Icons.message,
  badgeCount: 5, // Shows "5"
)

VooNavigationItem(
  id: 'notifications',
  label: 'Alerts',
  icon: Icons.notifications_outlined,
  showDot: true, // Shows notification dot
)
```

### Theme Presets

Apply visual themes to the navigation rail:

```dart
VooAdaptiveNavigationRail(
  config: VooNavigationConfig.glassmorphism(
    items: items,
    selectedId: selectedId,
    onNavigationItemSelected: (id) {},
  ),
)
```

Available presets:
- `glassmorphism` - Frosted glass effect
- `liquidGlass` - Deep blur with layers
- `blurry` - Clean frosted blur
- `neomorphism` - Soft embossed effect
- `material3Enhanced` - Polished Material 3
- `minimalModern` - Clean flat design

## Responsive Breakpoints

The rail automatically adapts based on screen width:

| Width | Mode | Display |
|-------|------|---------|
| 600-840px | Compact | Icons only |
| 840px+ | Extended | Icons + labels |

## Dependencies

This package depends on:
- `voo_navigation_core` - Core entities and atoms
- `voo_tokens` - Design system tokens

## Related Packages

| Package | Description |
|---------|-------------|
| [voo_navigation](../voo_navigation) | Main orchestration package |
| [voo_navigation_core](../voo_navigation_core) | Core foundation package |
| [voo_navigation_drawer](../voo_navigation_drawer) | Navigation drawer components |
| [voo_navigation_bar](../voo_navigation_bar) | Bottom navigation components |

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and follow the code style defined in the project.

---

Built by [VooStack](https://voostack.com)
