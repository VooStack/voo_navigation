# VooNavigation

[![Version](https://img.shields.io/badge/version-1.3.0-blue)](pubspec.yaml)
[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A53.0.0-blue)](https://flutter.dev)
[![Material 3](https://img.shields.io/badge/Material%203-compliant-green)](https://m3.material.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A comprehensive, adaptive navigation package for Flutter that automatically adjusts to different screen sizes and platforms with Material 3 design. Features a modern, production-ready UI inspired by leading SaaS applications like Notion, Linear, and Figma.

## ✨ Features

- **🎯 Fully Adaptive**: Automatically switches between navigation types based on screen size
  - Bottom Navigation (< 600px)
  - Navigation Rail (600-840px)
  - Extended Navigation Rail (840-1240px)
  - Navigation Drawer (> 1240px)

- **🔄 Collapsible Drawer**: Desktop drawer can collapse to a rail with animated toggle
- **📄 Per-Page Overrides**: Customize scaffold elements (FAB, app bar, etc.) on individual pages with `VooPage`
- **🎨 Theme Presets**: Six distinct visual styles - Glassmorphism, Liquid Glass, Blurry, Neomorphism, Material 3, Minimal
- **🔀 Multi-Switcher**: Unified organization and user switching with animated overlay
- **👤 User Profile Footer**: Built-in user profile component with avatar, name, and status
- **📁 Navigation Sections**: Group items into collapsible sections with headers
- **🚀 go_router Integration**: Native integration with StatefulNavigationShell
- **🔔 Rich Navigation Items**: Badges, dropdowns, custom icons, tooltips
- **✨ Smooth Animations**: AnimatedSwitcher for icon transitions, micro-interactions
- **💎 Production Ready**: Battle-tested UI matching modern SaaS applications
- **🛠️ Extensive Customization**: Colors, shapes, elevations, headers, footers
- **♿ Accessibility**: Full semantic labels and focus management
- **📱 Platform Agnostic**: Works seamlessly across all platforms

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_navigation: ^1.3.0
  # Or for local development:
  # voo_navigation:
  #   path: packages/ui/voo_navigation
```

## 🚀 Quick Start

### With go_router (Recommended)

```dart
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/voo_navigation.dart';

// 1. Define your router with StatefulShellRoute
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Pass the navigation shell to your scaffold
        return ScaffoldWithNavigation(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomePage(),
              routes: [
                // Nested routes
                GoRoute(
                  path: 'details',
                  builder: (context, state) => HomeDetailsPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

// 2. Create your navigation scaffold
class ScaffoldWithNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavigation({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final items = [
      VooNavigationItem(
        id: 'home',
        label: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        badgeCount: 3,
      ),
      VooNavigationItem(
        id: 'profile',
        label: 'Profile',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
      ),
    ];

    return VooAdaptiveScaffold(
      config: VooNavigationConfig(
        items: items,
        selectedId: items[navigationShell.currentIndex].id,
        onNavigationItemSelected: (itemId) {
          final index = items.indexWhere((item) => item.id == itemId);
          if (index != -1) {
            navigationShell.goBranch(index);
          }
        },
      ),
      body: navigationShell,  // Pass the shell as body
    );
  }
}

// 3. Use with MaterialApp.router
MaterialApp.router(
  routerConfig: router,
)
```

## 🎯 Navigation Types

### Bottom Navigation (Mobile)
Automatically used on screens < 600px wide. Perfect for mobile devices.

### Navigation Rail (Tablet)
Used on screens 600-840px. Ideal for tablets in portrait mode.

### Extended Navigation Rail (Small Laptop)
Used on screens 840-1240px. Shows labels alongside icons.

### Navigation Drawer (Desktop)
Used on screens > 1240px. Full-featured drawer with sections and headers.

## 🛠️ Customization

### Navigation Items

```dart
VooNavigationItem(
  id: 'unique_id',
  label: 'Display Label',
  icon: Icons.icon_outlined,
  selectedIcon: Icons.icon,  // Optional different icon when selected

  // Badges
  badgeCount: 5,              // Shows "5"
  badgeText: 'NEW',           // Custom badge text
  showDot: true,              // Simple notification dot
  badgeColor: Colors.red,     // Custom badge color

  // Navigation
  route: '/route',            // Route to navigate to
  destination: CustomWidget(), // Or custom widget
  onTap: () {},               // Custom callback

  // Icon Customization
  iconColor: Colors.blue,            // Custom icon color
  selectedIconColor: Colors.green,   // Icon color when selected
  leadingWidget: CustomWidget(),     // Replace icon with custom widget

  // Label Customization
  labelStyle: TextStyle(...),        // Custom label style
  selectedLabelStyle: TextStyle(...), // Label style when selected

  // Accessibility
  tooltip: 'Custom tooltip',
  semanticLabel: 'Accessible label for screen readers',

  // Additional Widgets
  trailingWidget: Icon(Icons.arrow_forward),

  // State
  isEnabled: true,
  isVisible: true,
  sortOrder: 0,
  key: ValueKey('my_item'),

  // Children for sections
  children: [...],            // Nested items for dropdowns
  isExpanded: true,           // Start expanded
)
```

### Configuration Options

```dart
VooNavigationConfig(
  // Core
  items: [...],
  selectedId: 'current_id',
  
  // Behavior
  isAdaptive: true,           // Auto-adapt to screen size
  forcedNavigationType: NavigationType.rail,  // Override adaptive
  
  // Animation
  enableAnimations: true,
  animationDuration: Duration(milliseconds: 300),
  animationCurve: Curves.easeInOut,
  
  // Appearance
  railLabelType: NavigationRailLabelType.selected,
  useExtendedRail: true,
  showNavigationRailDivider: true,
  centerAppBarTitle: false,
  
  // Colors (v0.0.5 defaults to modern dark theme)
  backgroundColor: Colors.white,
  navigationBackgroundColor: Color(0xFF1F2937), // Professional dark gray
  selectedItemColor: Theme.of(context).colorScheme.primary,
  unselectedItemColor: Colors.white.withValues(alpha: 0.8),
  indicatorColor: Colors.primary.withValues(alpha: 0.12),
  
  // Custom Widgets
  drawerHeader: CustomHeader(),
  drawerFooter: CustomFooter(),
  appBarLeading: CustomLeading(),
  appBarActions: [...],
  floatingActionButton: FAB(),
  
  // Callbacks
  onNavigationItemSelected: (itemId) {...},
)
```

## 📱 Responsive Breakpoints

The package uses Material 3 breakpoints by default:

| Breakpoint | Width | Navigation Type |
|------------|-------|----------------|
| Compact | < 600px | Bottom Navigation |
| Medium | 600-840px | Navigation Rail |
| Expanded | 840-1240px | Extended Rail |
| Large | 1240-1440px | Navigation Drawer |
| Extra Large | > 1440px | Navigation Drawer |

You can customize breakpoints:

```dart
VooNavigationConfig(
  breakpoints: [
    VooBreakpoint(
      minWidth: 0,
      maxWidth: 500,
      navigationType: VooNavigationType.bottomNavigation,
      columns: 4,
      margin: EdgeInsets.all(16),
      gutter: 8,
    ),
    // Add more custom breakpoints
  ],
)
```

## 🎨 Theming

The package fully integrates with your app's theme:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    navigationBarTheme: NavigationBarThemeData(...),
    navigationRailTheme: NavigationRailThemeData(...),
    drawerTheme: DrawerThemeData(...),
  ),
)
```

## 🔔 Badges & Notifications

Show badges on navigation items:

```dart
// Count badge
VooNavigationItem(
  badgeCount: 10,  // Shows "10"
)

// Custom text badge
VooNavigationItem(
  badgeText: 'NEW',
  badgeColor: Colors.orange,
)

// Simple dot indicator
VooNavigationItem(
  showDot: true,
  badgeColor: Colors.red,
)
```

## 📂 Sections & Groups

Organize items into sections using `VooNavigationItem.section()` or the dedicated `VooNavigationSection`:

```dart
// Simple approach using item factory
VooNavigationItem.section(
  label: 'Communication',
  children: [
    VooNavigationItem(id: 'messages', ...),
    VooNavigationItem(id: 'email', ...),
  ],
  isExpanded: true,
)

// Semantic approach using VooNavigationSection
VooNavigationSection(
  id: 'main_section',
  title: 'Main',
  icon: Icons.dashboard,
  items: [
    VooNavigationItem(id: 'home', label: 'Home', icon: Icons.home, route: '/'),
    VooNavigationItem(id: 'dashboard', label: 'Dashboard', icon: Icons.dashboard, route: '/dashboard'),
  ],
  isExpanded: true,
  isCollapsible: true,
  showDividerBefore: false,
  showDividerAfter: true,
)
```

Use sections in config:

```dart
VooNavigationConfig(
  items: [...],           // Direct items
  sections: [             // Organized sections
    VooNavigationSection(...),
    VooNavigationSection(...),
  ],
)
```

## 🔄 Collapsible Drawer

Enable the desktop drawer to collapse into a navigation rail:

```dart
VooNavigationConfig(
  enableCollapsibleRail: true,
  onCollapseChanged: (isCollapsed) {
    print('Drawer collapsed: $isCollapsed');
  },
  // Optional: custom toggle button
  collapseToggleBuilder: (isExpanded, onToggle) {
    return IconButton(
      icon: Icon(isExpanded ? Icons.chevron_left : Icons.chevron_right),
      onPressed: onToggle,
    );
  },
)
```

## 📄 Per-Page Scaffold Overrides (VooPage)

Customize scaffold elements on individual pages without affecting the global config:

```dart
// Basic usage - custom FAB position
VooPage(
  config: VooPageConfig(
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () {},
      label: Text('Compose'),
      icon: Icon(Icons.create),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  ),
  child: MyPageContent(),
)

// Custom app bar for a specific page
VooPage.withAppBar(
  appBar: AppBar(
    title: Text('Custom Title'),
    backgroundColor: Colors.teal,
    actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
  ),
  child: MyPageContent(),
)

// Fullscreen page (no app bar)
VooPage.fullscreen(
  child: MyImmersiveContent(),
)

// Clean page (no scaffold elements)
VooPage.clean(
  child: MyMinimalContent(),
)

// Hide FAB on specific page
VooPage(
  config: VooPageConfig(
    showFloatingActionButton: false,
  ),
  child: MyPageContent(),
)
```

### Available VooPageConfig Options

```dart
VooPageConfig(
  // App Bar
  appBar: PreferredSizeWidget?,
  showAppBar: bool,

  // Floating Action Button
  floatingActionButton: Widget?,
  floatingActionButtonLocation: FloatingActionButtonLocation?,
  showFloatingActionButton: bool,

  // Scaffold Properties
  backgroundColor: Color?,
  resizeToAvoidBottomInset: bool?,
  extendBody: bool?,
  extendBodyBehindAppBar: bool?,

  // Additional Elements
  bottomSheet: Widget?,
  endDrawer: Widget?,
  persistentFooterButtons: List<Widget>?,

  // Body Styling
  bodyPadding: EdgeInsetsGeometry?,
  useBodyCard: bool?,
  bodyCardElevation: double?,
  bodyCardBorderRadius: BorderRadius?,
  bodyCardColor: Color?,

  // Custom Scaffold (full control)
  useCustomScaffold: bool,
  scaffoldBuilder: Widget Function(BuildContext, Widget)?,
)
```

## 🎨 Theme Presets

Apply distinct visual styles to your navigation components:

```dart
// Glassmorphism - frosted glass effect with blur and translucent surfaces
VooNavigationConfig.glassmorphism(
  items: navigationItems,
  selectedId: selectedId,
)

// Liquid Glass - deep blur with layered effects and edge refraction
VooNavigationConfig.liquidGlass(
  items: navigationItems,
  selectedId: selectedId,
)

// Blurry - clean frosted blur with minimal styling
VooNavigationConfig.blurry(
  items: navigationItems,
  selectedId: selectedId,
)

// Neomorphism - soft embossed/debossed effect with dual shadows
VooNavigationConfig.neomorphism(
  items: navigationItems,
  selectedId: selectedId,
)

// Material 3 Enhanced - polished Material 3 with richer animations
VooNavigationConfig.material3Enhanced(
  items: navigationItems,
  selectedId: selectedId,
)

// Minimal Modern - clean flat design
VooNavigationConfig.minimalModern(
  items: navigationItems,
  selectedId: selectedId,
)
```

### Custom Theme

Create your own navigation theme:

```dart
VooNavigationConfig(
  items: items,
  navigationTheme: VooNavigationTheme(
    preset: VooNavigationPreset.glassmorphism,
    surfaceOpacity: 0.8,
    blurSigma: 20,
    borderWidth: 1.5,
    borderOpacity: 0.2,
    indicatorStyle: VooThemeIndicatorStyle.glow,
    indicatorGlowBlur: 16,
    containerBorderRadius: 28,
    animationDuration: Duration(milliseconds: 250),
    animationCurve: Curves.easeInOut,
    // Liquid Glass specific properties
    innerGlowIntensity: 0.6,
    edgeHighlightIntensity: 0.8,
    secondaryBlurSigma: 8,
    tintIntensity: 0.3,
  ),
)
```

### Theme Preset Characteristics

| Preset | Surface | Shadows | Border | Indicator |
|--------|---------|---------|--------|-----------|
| **Glassmorphism** | Translucent (75%) with blur | Soft glow | Subtle light border | Glow effect |
| **Liquid Glass** | Translucent (60%) with deep blur | Multi-layer glow | Light border with edge highlights | Glow effect |
| **Blurry** | Translucent (55%) with heavy blur | None | Thin subtle border | Glow effect |
| **Neomorphism** | Opaque | Dual shadows (light + dark) | None | Embossed |
| **Material 3** | Opaque | Elevation shadow | None | Pill |
| **Minimal** | Opaque | None | Thin outline | Line |

## 🔀 Multi-Switcher (Unified Org + User)

The new multi-switcher combines organization switching and user profile into a single, beautifully animated component:

```dart
VooNavigationConfig(
  // ... other config

  multiSwitcher: VooMultiSwitcherConfig(
    // Organizations
    organizations: [
      VooOrganization(id: 'acme', name: 'ACME Corp', subtitle: '12 members'),
      VooOrganization(id: 'startup', name: 'Startup Inc', subtitle: '5 members'),
    ],
    selectedOrganization: currentOrg,
    onOrganizationChanged: (org) => setState(() => currentOrg = org),
    onCreateOrganization: () => showCreateOrgDialog(),

    // User
    userName: 'John Doe',
    userEmail: 'john@example.com',
    avatarUrl: 'https://example.com/avatar.jpg',
    status: VooUserStatus.online,

    // Actions
    onSettingsTap: () => openSettings(),
    onLogout: () => logout(),

    // Display options
    showOrganizationSection: true,
    showUserSection: true,
    showSearch: true,
    organizationSectionTitle: 'Workspaces',
    userSectionTitle: 'Account',
  ),
  multiSwitcherPosition: VooMultiSwitcherPosition.footer,

  // Disable old components when using multi-switcher
  showUserProfile: false,
  organizationSwitcher: null,
)
```

The multi-switcher features:
- **Card State**: Stacked avatars showing current org and user
- **Modal State**: Slides up as overlay with organization list and user actions
- **Smooth Animation**: Spring physics with `Curves.easeOutBack`
- **Customizable**: Use `cardBuilder` and `modalBuilder` for full control

## 👤 User Profile Footer

Show a user profile in the drawer/rail footer:

```dart
VooNavigationConfig(
  showUserProfile: true,
  // Use default profile widget or provide custom one
  userProfileWidget: VooUserProfileFooter(
    userName: 'John Doe',
    userEmail: 'john@example.com',
    avatarUrl: 'https://example.com/avatar.jpg',
    status: VooUserStatus.online,
    onTap: () => print('Profile tapped'),
    onSettingsTap: () => print('Settings tapped'),
    onLogout: () => print('Logout'),
  ),
)
```

## 📭 Empty & Loading States

Handle empty and loading states:

```dart
VooNavigationConfig(
  items: items,
  // Show when items list is empty
  emptyStateWidget: Center(
    child: Text('No navigation items'),
  ),
  // Show while loading
  loadingWidget: Center(
    child: CircularProgressIndicator(),
  ),
)
```

## 🎭 Animations

All transitions are animated by default (enhanced in v0.0.5):

- Navigation type changes with smooth transitions
- Item selection with AnimatedSwitcher (200ms)
- Badge updates with scale animations
- Drawer/rail expansion with easing curves
- FAB position changes with Material 3 motion
- Icon transitions between selected/unselected states
- Hover effects with subtle opacity changes (5% overlay)

Control animations:

```dart
VooNavigationConfig(
  enableAnimations: false,  // Disable all animations
  animationDuration: Duration(milliseconds: 500),
  animationCurve: Curves.elasticOut,
)
```

## 📱 Example App

Check out the example apps for complete demonstrations:

```bash
cd packages/ui/voo_navigation/example

# Run the main example
flutter run

# Run the modern dashboard example (v0.0.5)
flutter run lib/modern_dashboard_example.dart

# Run the go_router integration example
flutter run lib/go_router_example.dart
```

## 🏗️ Architecture

The package follows clean architecture with Atomic Design Pattern:

```
lib/
├── src/
│   ├── domain/
│   │   └── entities/        # Core business entities
│   │       ├── navigation_config.dart
│   │       ├── navigation_item.dart
│   │       ├── navigation_route.dart  # go_router integration (v0.0.4+)
│   │       └── navigation_type.dart
│   └── presentation/
│       ├── organisms/        # Complex components
│       │   ├── voo_adaptive_scaffold.dart
│       │   ├── voo_adaptive_navigation_rail.dart
│       │   └── voo_adaptive_navigation_drawer.dart
│       ├── molecules/        # Composite components
│       ├── atoms/           # Basic components
│       └── utils/           # Animation utilities
```

## 🧪 Testing

Run tests:

```bash
flutter test
```

## 📝 License

This package is part of the VooFlutter ecosystem.

## 📊 Version History

- **1.3.0** - Multi-Switcher
  - New `VooMultiSwitcher` component for unified organization and user switching
  - Animated overlay modal with spring physics
  - Stacked avatars in card state
  - Full customization via builders
  - Replaces separate org switcher and user profile
- **1.2.6** - Design system consistency
  - Centralized `VooNavigationTokens` for consistent styling across all components
  - Theme-aware floating navigation (no more hardcoded colors)
  - Unified selection states (subtle primary tint @ 10% opacity)
  - Modern 8dp border radius throughout
- **1.0.3** - New theme presets
  - Added **Liquid Glass** preset - deep blur with layered effects, inner glow, and edge refraction
  - Added **Blurry** preset - clean frosted blur with minimal styling (inspired by BlurryContainer)
  - New theme properties: `innerGlowIntensity`, `edgeHighlightIntensity`, `secondaryBlurSigma`, `tintIntensity`
  - Enhanced gradient backgrounds in example app for better blur visibility
- **1.0.2** - Per-page scaffold overrides & theme fixes
  - VooPage system for customizing scaffold elements per page
  - Theme presets now properly apply to navigation components
  - Fixed styled layout for fullscreen pages
  - More visually distinct theme presets
- **1.0.1** - Mobile navigation improvements
  - Floating bottom navigation redesign
  - Responsive compact mode for 5 items
- **1.0.0** - Stable release with polished animations
  - Full collapsible drawer-to-rail implementation
  - Enhanced animation system (dropdown arrows, badges, indicators)
  - Performance optimizations for collapse transitions
- **0.1.1** - Theme preset system with glassmorphism, neomorphism, Material 3 enhanced, and minimal modern styles
- **0.1.0** - App bar builder pattern for dynamic content
- **0.0.7** - Major feature release (sections, collapsible drawer, user profile)
- **0.0.6** - Updated go_router dependency to ^16.2.2
- **0.0.5** - Visual design overhaul, UX improvements, bug fixes
- **0.0.4** - go_router integration, Material You support
- **0.0.3** - Package maintenance
- **0.0.2** - Animation enhancements, badge system refinements
- **0.0.1** - Initial release

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines and follow the code style defined in `rules.md`.

## 🆕 What's New in v1.3.0

### Multi-Switcher Component
A unified organization and user switching component that replaces the separate org switcher and user profile:

- **Card State**: Shows stacked avatars (org + user) with chevron indicator
- **Modal State**: Slides up as overlay with organization list and user actions
- **Smooth Animation**: Spring physics using `Curves.easeOutBack` (300ms)
- **Tap Outside**: Dismiss modal by tapping outside
- **Full Customization**: Use `cardBuilder` and `modalBuilder` for custom UI

```dart
multiSwitcher: VooMultiSwitcherConfig(
  organizations: myOrgs,
  selectedOrganization: currentOrg,
  onOrganizationChanged: handleOrgChange,
  userName: 'John Doe',
  userEmail: 'john@example.com',
  onLogout: handleLogout,
),
```

---

## What's New in v1.2.6

### Design System Tokens
Centralized design tokens ensure consistent styling across all navigation components:

```dart
// All navigation components now use VooNavigationTokens
VooNavigationTokens.iconSizeDefault      // 18dp
VooNavigationTokens.itemBorderRadius     // 8dp (modernized)
VooNavigationTokens.opacitySelectedBackground  // 10%
```

### Theme-Aware Colors
New extension methods for consistent, theme-aware color generation:

```dart
context.navSelectedBackground()  // primary @ 10% opacity
context.navHoverBackground       // onSurface @ 4% opacity
context.floatingNavBackground    // surfaceContainerHighest
```

### Floating Navigation Improvements
- **Theme-aware background**: Uses `surfaceContainerHighest` instead of hardcoded black
- **Proper dark/light mode support**: Colors adapt automatically to theme
- **Consistent selection states**: Matches drawer and rail styling

### Unified Selection States
All navigation components (drawer, rail, bottom nav) now use the same selection style:
- **Default**: Transparent background
- **Hover**: `onSurface @ 4%` - subtle feedback
- **Selected**: `primary @ 10%` - unified tint across all components

## 🐛 Issues

Report issues on the [GitHub repository](https://github.com/VooFlutter/voo_navigation).

---

## Built by VooStack

Need help with Flutter development or custom navigation solutions?

**[Contact Us](https://voostack.com/contact)**

VooStack builds enterprise Flutter applications and developer tools. We're here to help with your next project.