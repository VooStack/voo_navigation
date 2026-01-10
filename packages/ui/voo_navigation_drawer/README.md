# voo_navigation_drawer

[![Version](https://img.shields.io/badge/version-0.1.0-blue)](pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Navigation drawer components for Flutter - part of the voo_navigation package ecosystem. Provides full-featured navigation drawers for desktop layouts with Material 3 design.

## Features

- Expandable sections with smooth animations
- User profile footer integration
- Custom header and footer widgets
- Collapsible drawer-to-rail mode
- Theme preset support (glassmorphism, neomorphism, etc.)
- Material 3 compliant design

## Installation

```yaml
dependencies:
  voo_navigation_drawer: ^0.1.0
```

Or use the main package which includes all navigation components:

```yaml
dependencies:
  voo_navigation: ^1.2.0
```

## Components

| Component | Description |
|-----------|-------------|
| `VooAdaptiveNavigationDrawer` | Main navigation drawer organism |
| `VooDrawerNavigationItems` | Container for drawer navigation items |
| `VooDrawerNavigationItem` | Individual drawer navigation item |
| `VooDrawerChildNavigationItem` | Child item for expandable sections |
| `VooDrawerExpandableSection` | Expandable section with children |
| `VooDrawerDefaultHeader` | Default header component for drawer |
| `VooDrawerModernBadge` | Badge component specific to drawer styling |

## Usage

### Basic Navigation Drawer

```dart
import 'package:voo_navigation_drawer/voo_navigation_drawer.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

VooAdaptiveNavigationDrawer(
  config: VooNavigationConfig(
    items: [
      VooNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
      ),
      VooNavigationItem(
        id: 'projects',
        label: 'Projects',
        icon: Icons.folder_outlined,
        selectedIcon: Icons.folder,
      ),
      VooNavigationItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
      ),
    ],
    selectedId: 'home',
    onNavigationItemSelected: (id) {
      // Handle navigation
    },
  ),
)
```

### With Expandable Sections

Group navigation items into expandable sections:

```dart
VooAdaptiveNavigationDrawer(
  config: VooNavigationConfig(
    items: [
      VooNavigationItem.section(
        label: 'Workspace',
        icon: Icons.workspaces,
        isExpanded: true,
        children: [
          VooNavigationItem(id: 'projects', label: 'Projects', icon: Icons.folder),
          VooNavigationItem(id: 'tasks', label: 'Tasks', icon: Icons.task),
          VooNavigationItem(id: 'calendar', label: 'Calendar', icon: Icons.calendar_today),
        ],
      ),
      VooNavigationItem.section(
        label: 'Communication',
        icon: Icons.chat,
        children: [
          VooNavigationItem(id: 'messages', label: 'Messages', icon: Icons.message, badgeCount: 3),
          VooNavigationItem(id: 'email', label: 'Email', icon: Icons.email),
        ],
      ),
    ],
    selectedId: 'projects',
    onNavigationItemSelected: (id) {},
  ),
)
```

### With Custom Header and Footer

```dart
VooAdaptiveNavigationDrawer(
  config: VooNavigationConfig(
    items: items,
    selectedId: selectedId,
    onNavigationItemSelected: (id) {},
    drawerHeader: Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset('assets/logo.png', height: 32),
          SizedBox(width: 12),
          Text('My App', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ),
    drawerFooter: ListTile(
      leading: Icon(Icons.help_outline),
      title: Text('Help & Support'),
      onTap: () {},
    ),
  ),
)
```

### With User Profile Footer

```dart
VooAdaptiveNavigationDrawer(
  config: VooNavigationConfig(
    items: items,
    selectedId: selectedId,
    onNavigationItemSelected: (id) {},
    showUserProfile: true,
    userProfileWidget: VooUserProfileFooter(
      userName: 'John Doe',
      userEmail: 'john@example.com',
      avatarUrl: 'https://example.com/avatar.jpg',
      status: VooUserStatus.online,
      onTap: () => print('Profile tapped'),
      onSettingsTap: () => print('Settings'),
      onLogout: () => print('Logout'),
    ),
  ),
)
```

### With Badges

```dart
VooNavigationItem(
  id: 'inbox',
  label: 'Inbox',
  icon: Icons.inbox_outlined,
  selectedIcon: Icons.inbox,
  badgeCount: 12, // Shows "12"
)

VooNavigationItem(
  id: 'updates',
  label: 'Updates',
  icon: Icons.notifications_outlined,
  badgeText: 'NEW', // Shows custom text
  badgeColor: Colors.orange,
)
```

### Collapsible Drawer

Enable the drawer to collapse into a navigation rail:

```dart
VooNavigationConfig(
  items: items,
  selectedId: selectedId,
  enableCollapsibleRail: true,
  onCollapseChanged: (isCollapsed) {
    print('Drawer collapsed: $isCollapsed');
  },
)
```

### Theme Presets

Apply visual themes to the navigation drawer:

```dart
VooAdaptiveNavigationDrawer(
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

## Responsive Usage

The drawer is typically used on larger screens (> 1240px). For responsive layouts, use the main `voo_navigation` package which automatically switches between drawer, rail, and bottom navigation based on screen size.

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
| [voo_navigation_bar](../voo_navigation_bar) | Bottom navigation components |

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please read our contributing guidelines and follow the code style defined in the project.

---

Built by [VooStack](https://voostack.com)
