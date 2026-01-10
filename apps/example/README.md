# voo_navigation_showcase

[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A comprehensive showcase app demonstrating all features of the voo_navigation package suite.

## Overview

This example app demonstrates:

- **Adaptive Navigation**: Automatic switching between bottom navigation, navigation rail, and navigation drawer based on screen size
- **Theme Presets**: All 6 visual themes (glassmorphism, liquidGlass, blurry, neomorphism, material3Enhanced, minimalModern)
- **GoRouter Integration**: Navigation with StatefulShellRoute for state preservation
- **Per-Page Overrides**: Customizing scaffold elements on individual pages using VooPage
- **Navigation Sections**: Grouping items into collapsible sections
- **Badges**: Count badges, text badges, and dot notifications
- **User Profile Footer**: User profile component in navigation
- **Collapsible Drawer**: Desktop drawer collapsing to navigation rail

## Running the App

```bash
# Navigate to the example directory
cd apps/example

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Supported Platforms

- Android
- iOS
- Web
- macOS
- Windows
- Linux

## Screenshots

*Resize your browser window or rotate your device to see the adaptive navigation in action.*

| Mobile (< 600px) | Tablet (600-840px) | Desktop (> 1240px) |
|------------------|--------------------|--------------------|
| Bottom Navigation | Navigation Rail | Navigation Drawer |

## Project Structure

```
lib/
├── main.dart              # App entry point
├── router.dart            # GoRouter configuration
├── pages/                 # Page widgets
│   ├── home_page.dart
│   ├── search_page.dart
│   └── ...
└── widgets/               # Reusable widgets
```

## Key Code Examples

### Adaptive Scaffold Setup

```dart
VooAdaptiveScaffold(
  config: VooNavigationConfig(
    items: navigationItems,
    selectedId: currentItemId,
    onNavigationItemSelected: (id) {
      navigationShell.goBranch(getIndexForId(id));
    },
  ),
  body: navigationShell,
)
```

### Theme Preset Usage

```dart
VooNavigationConfig.glassmorphism(
  items: items,
  selectedId: selectedId,
  onNavigationItemSelected: onSelect,
)
```

### Per-Page Customization

```dart
VooPage(
  config: VooPageConfig(
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.add),
    ),
    showAppBar: false,
  ),
  child: PageContent(),
)
```

## Related

- [voo_navigation](../../packages/ui/voo_navigation) - Main package documentation
- [Package Example](../../packages/ui/voo_navigation/example) - Simpler usage examples

## License

MIT License - see [LICENSE](LICENSE) for details.

---

Built by [VooStack](https://voostack.com)
