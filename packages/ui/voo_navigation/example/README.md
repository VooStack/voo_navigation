# voo_navigation_example

[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Example app demonstrating basic usage of the voo_navigation package.

## Overview

This example provides a simple introduction to using voo_navigation, including:

- Basic adaptive navigation setup
- Navigation item configuration
- Theme preset usage
- GoRouter integration

For a more comprehensive demonstration with all features, see the [showcase app](../../../../apps/example).

## Running the Example

```bash
# Navigate to the example directory
cd packages/ui/voo_navigation/example

# Get dependencies
flutter pub get

# Run the example
flutter run
```

## Available Examples

### Main Example (`main.dart`)

Basic adaptive navigation with go_router integration.

```bash
flutter run
```

### Modern Dashboard (`modern_dashboard_example.dart`)

Demonstrates the modern dashboard-style navigation with theme presets.

```bash
flutter run lib/modern_dashboard_example.dart
```

### GoRouter Example (`go_router_example.dart`)

Detailed go_router integration with StatefulShellRoute.

```bash
flutter run lib/go_router_example.dart
```

## Basic Usage

```dart
import 'package:voo_navigation/voo_navigation.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VooAdaptiveScaffold(
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
          ],
          selectedId: 'home',
          onNavigationItemSelected: (id) {
            // Handle navigation
          },
        ),
        body: Center(child: Text('Content')),
      ),
    );
  }
}
```

## Related

- [voo_navigation README](../README.md) - Complete package documentation
- [Showcase App](../../../../apps/example) - Full-featured demonstration

## License

MIT License - see [LICENSE](LICENSE) for details.

---

Built by [VooStack](https://voostack.com)
