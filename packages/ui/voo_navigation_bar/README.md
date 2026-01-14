# voo_navigation_bar

[![Version](https://img.shields.io/badge/version-0.1.2-blue)](pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Bottom navigation bar components for Flutter - part of the voo_navigation package ecosystem. Provides modern bottom navigation for mobile layouts with Material 3 design.

## Features

- Material 2 and Material 3 navigation styles
- Modern floating navigation bar option
- Custom styled navigation bar
- Adaptive badge display with animations
- Theme preset support (glassmorphism, neomorphism, etc.)
- Responsive compact mode for 5 items

## Installation

```yaml
dependencies:
  voo_navigation_bar: ^0.1.2
```

Or use the main package which includes all navigation components:

```yaml
dependencies:
  voo_navigation: ^1.2.6
```

## Components

| Component | Description |
|-----------|-------------|
| `VooAdaptiveBottomNavigation` | Main bottom navigation organism |
| `VooFloatingBottomNavigation` | Modern floating bottom navigation bar |
| `VooMaterial3NavigationBar` | Material 3 compliant navigation bar |
| `VooMaterial2BottomNavigation` | Material 2 style bottom navigation |
| `VooCustomNavigationBar` | Custom styled navigation bar |
| `VooCustomNavigationItem` | Custom navigation item component |
| `VooNavigationDropdown` | Dropdown component for expandable items |

## Usage

### Basic Bottom Navigation

```dart
import 'package:voo_navigation_bar/voo_navigation_bar.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

VooAdaptiveBottomNavigation(
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
)
```

### Floating Bottom Navigation

Modern floating navigation bar with rounded corners and shadows:

```dart
VooFloatingBottomNavigation(
  config: VooNavigationConfig(
    items: items,
    selectedId: 'home',
    onNavigationItemSelected: (id) {},
    floatingBottomNav: true, // Enable floating style
  ),
)
```

Or use the config option:

```dart
VooNavigationConfig(
  items: items,
  selectedId: selectedId,
  floatingBottomNav: true, // Enables floating navigation
)
```

### Material 3 Navigation Bar

```dart
VooMaterial3NavigationBar(
  config: VooNavigationConfig(
    items: items,
    selectedId: selectedId,
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
  badgeColor: Colors.red,
)

VooNavigationItem(
  id: 'updates',
  label: 'Updates',
  icon: Icons.update,
  badgeText: 'NEW', // Shows custom text
  badgeColor: Colors.orange,
)
```

### Theme Presets

Apply visual themes to the navigation bar:

```dart
VooAdaptiveBottomNavigation(
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

### Mobile Priority Items

Control which items appear in bottom navigation (max 5):

```dart
VooNavigationItem(
  id: 'home',
  label: 'Home',
  icon: Icons.home,
  mobilePriority: true, // Will appear in bottom nav
)

VooNavigationItem(
  id: 'settings',
  label: 'Settings',
  icon: Icons.settings,
  mobilePriority: false, // Hidden in bottom nav, shown in menu
)
```

### Custom Navigation Bar

For complete control over styling:

```dart
VooCustomNavigationBar(
  config: config,
  backgroundColor: Colors.black87,
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white54,
  elevation: 8,
)
```

## Responsive Behavior

The bottom navigation automatically adapts:

| Items | Behavior |
|-------|----------|
| 3-4 items | Full size icons and labels |
| 5 items | Compact mode with smaller icons/labels |
| 5+ items | Uses `mobilePriorityItems` (max 5 shown) |

## Responsive Breakpoints

The bottom navigation is typically used on mobile screens (< 600px). For responsive layouts, use the main `voo_navigation` package which automatically switches between bottom navigation, rail, and drawer based on screen size.

## Dependencies

This package depends on:
- `voo_navigation_core` - Core entities and atoms
- `voo_tokens` - Design system tokens

## Related Packages

| Package | Description |
|---------|-------------|
| [voo_navigation](../voo_navigation) | Main orchestration package |
| [voo_navigation_core](../voo_navigation_core) | Core foundation package |
| [voo_navigation_rail](../voo_navigation_rail) | Navigation rail components |
| [voo_navigation_drawer](../voo_navigation_drawer) | Navigation drawer components |

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and follow the code style defined in the project.

---

Built by [VooStack](https://voostack.com)
