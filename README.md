# voo_navigation

[![Version](https://img.shields.io/badge/version-1.2.0-blue)](packages/ui/voo_navigation/pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![Material 3](https://img.shields.io/badge/Material%203-compliant-green)](https://m3.material.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A comprehensive, adaptive navigation package suite for Flutter that automatically adjusts to different screen sizes and platforms with Material 3 design.

## Features

- **Fully Adaptive**: Automatically switches between Bottom Navigation, Navigation Rail, and Navigation Drawer based on screen size
- **Material 3 Compliant**: Built with Material 3 design guidelines
- **Context Switcher**: Inline project/workspace switching with dynamic navigation items
- **Multi-Switcher**: Unified organization and user switching with animated overlay
- **Theme Presets**: Glassmorphism, Liquid Glass, Blurry, Neomorphism, Material 3 Enhanced, Minimal Modern
- **GoRouter Integration**: Native integration with StatefulNavigationShell
- **Per-Page Customization**: Override scaffold elements on individual pages
- **Collapsible Drawer**: Desktop drawer can collapse to a rail
- **Cross-Platform**: Works on Android, iOS, Web, macOS, Windows, and Linux

## Packages

| Package | Version | Description |
|---------|---------|-------------|
| [voo_navigation](packages/ui/voo_navigation) | 1.2.0 | Main orchestration package - re-exports all sub-packages |
| [voo_navigation_core](packages/ui/voo_navigation_core) | 0.1.0 | Shared foundation - entities, atoms, molecules, utilities |
| [voo_navigation_rail](packages/ui/voo_navigation_rail) | 0.1.0 | Rail navigation components for tablet/desktop |
| [voo_navigation_drawer](packages/ui/voo_navigation_drawer) | 0.1.0 | Drawer navigation components for desktop |
| [voo_navigation_bar](packages/ui/voo_navigation_bar) | 0.1.0 | Bottom navigation bar components for mobile |

## Architecture

```
voo_navigation_core (v0.1.0)
       ↑
       ├──────────────┬──────────────┐
       ↑              ↑              ↑
voo_navigation_rail  voo_navigation_drawer  voo_navigation_bar
   (v0.1.0)              (v0.1.0)              (v0.1.0)
       ↑              ↑              ↑
       └──────────────┴──────────────┘
                      ↑
               voo_navigation (v1.2.0)
```

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_navigation: ^1.2.0
```

Or import individual packages for specific use cases:

```yaml
dependencies:
  voo_navigation_core: ^0.1.0
  voo_navigation_rail: ^0.1.0
```

## Quick Start

```dart
import 'package:voo_navigation/voo_navigation.dart';

// Define navigation items
final items = [
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
];

// Use the adaptive scaffold
VooAdaptiveScaffold(
  config: VooNavigationConfig(
    items: items,
    selectedId: 'home',
    onNavigationItemSelected: (id) {
      // Handle navigation
    },
  ),
  body: YourPageContent(),
)
```

## Context Switcher

Embed inline context/project switchers in navigation sections with dynamic items:

```dart
// Define contexts (projects, workspaces, environments, etc.)
final projects = [
  VooContextItem(
    id: 'proj-1',
    name: 'Marketing Website',
    icon: Icons.web,
    color: Colors.blue,
    subtitle: '12 tasks',
  ),
  VooContextItem(
    id: 'proj-2',
    name: 'Mobile App',
    icon: Icons.phone_android,
    color: Colors.green,
    subtitle: '8 tasks',
  ),
];

// Navigation items that change based on selected context
List<VooNavigationItem> getProjectItems(VooContextItem? project) {
  if (project == null) return [
    VooNavigationItem(id: 'hint', label: 'Select a project', icon: Icons.info, route: '/'),
  ];
  return [
    VooNavigationItem(id: 'overview', label: 'Overview', icon: Icons.dashboard, route: '/projects/${project.id}/overview'),
    VooNavigationItem(id: 'tasks', label: 'Tasks', icon: Icons.check_circle, route: '/projects/${project.id}/tasks'),
    VooNavigationItem(id: 'files', label: 'Files', icon: Icons.folder, route: '/projects/${project.id}/files'),
  ];
}

// Embed in expandable navigation section
VooNavigationItem(
  id: 'projects-section',
  label: 'Projects',
  icon: Icons.folder_special,
  isExpanded: true,
  sectionHeaderLineColor: selectedProject?.color, // Vertical line matches project color
  sectionHeaderWidget: VooContextSwitcher(
    config: VooContextSwitcherConfig(
      items: projects,
      selectedItem: selectedProject,
      onContextChanged: (project) => setState(() => selectedProject = project),
      showSearch: true,
      searchHint: 'Search projects...',
      placeholder: 'Select project',
      onCreateContext: () => showCreateProjectDialog(),
      createContextLabel: 'New Project',
    ),
  ),
  children: getProjectItems(selectedProject),
)
```

## Multi-Switcher

Combine organization and user switching into a single animated component:

```dart
VooNavigationConfig(
  // ... other config
  multiSwitcher: VooMultiSwitcherConfig(
    organizations: myOrganizations,
    selectedOrganization: currentOrg,
    onOrganizationChanged: (org) => setState(() => currentOrg = org),
    userName: 'John Doe',
    userEmail: 'john@example.com',
    userAvatarUrl: 'https://example.com/avatar.jpg',
    status: VooUserStatus.online,
    onSettingsTap: () => openSettings(),
    onLogout: () => logout(),
  ),
  multiSwitcherPosition: VooMultiSwitcherPosition.footer,
)
```

## Responsive Breakpoints

| Width | Navigation Type |
|-------|-----------------|
| < 600px | Bottom Navigation |
| 600-840px | Navigation Rail |
| 840-1240px | Extended Rail |
| > 1240px | Navigation Drawer |

## Development

This project uses [Melos](https://melos.invertase.dev/) for monorepo management.

```bash
# Install Melos globally
dart pub global activate melos

# Bootstrap the workspace
melos bootstrap

# Run tests for all packages
melos run test_all

# Analyze code
melos run analyze

# Clean build artifacts
melos run clean
```

## Example Apps

- **[Showcase App](apps/example)**: Full-featured demo of all voo_navigation capabilities
- **[Package Example](packages/ui/voo_navigation/example)**: Basic usage examples

```bash
# Run the showcase app
cd apps/example
flutter run

# Run the package example
cd packages/ui/voo_navigation/example
flutter run
```

## Documentation

For detailed documentation, see the README files in each package:

- [voo_navigation README](packages/ui/voo_navigation/README.md) - Complete API documentation
- [voo_navigation_core README](packages/ui/voo_navigation_core/README.md) - Core entities and atoms
- [voo_navigation_rail README](packages/ui/voo_navigation_rail/README.md) - Navigation rail usage
- [voo_navigation_drawer README](packages/ui/voo_navigation_drawer/README.md) - Navigation drawer usage
- [voo_navigation_bar README](packages/ui/voo_navigation_bar/README.md) - Bottom navigation usage

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and follow the code style defined in the project.

---

Built by [VooStack](https://voostack.com)
