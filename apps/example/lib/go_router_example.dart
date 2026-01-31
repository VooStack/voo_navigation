import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const GoRouterExampleApp());
}

/// Example demonstrating VooAdaptiveScaffold with GoRouter's StatefulNavigationShell.
///
/// This shows how to integrate voo_navigation with GoRouter for
/// stateful navigation where each branch maintains its own navigation stack.
class GoRouterExampleApp extends StatelessWidget {
  const GoRouterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'VooNavigation GoRouter Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

// =============================================================================
// ROUTER CONFIGURATION
// =============================================================================

final _router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainPage(shell: navigationShell);
      },
      branches: [
        // Branch 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                  path: 'details/:id',
                  builder: (context, state) => HomeDetailsPage(
                    id: state.pathParameters['id'] ?? '',
                  ),
                ),
              ],
            ),
          ],
        ),
        // Branch 1: Explore
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/explore',
              builder: (context, state) => const ExplorePage(),
              routes: [
                GoRoute(
                  path: 'category/:category',
                  builder: (context, state) => CategoryPage(
                    category: state.pathParameters['category'] ?? '',
                  ),
                ),
              ],
            ),
          ],
        ),
        // Branch 2: Library
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryPage(),
            ),
          ],
        ),
        // Branch 3: Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
        // Branch 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

// =============================================================================
// MAIN PAGE WITH VOO ADAPTIVE SCAFFOLD
// =============================================================================

class MainPage extends StatelessWidget {
  final StatefulNavigationShell shell;
  const MainPage({super.key, required this.shell});

  /// Navigation items for the scaffold
  static const _items = [
    VooNavigationDestination(
      id: 'home',
      label: 'Home',
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      mobilePriority: true,
    ),
    VooNavigationDestination(
      id: 'explore',
      label: 'Explore',
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore),
      mobilePriority: true,
    ),
    VooNavigationDestination(
      id: 'library',
      label: 'Library',
      icon: Icon(Icons.library_music_outlined),
      selectedIcon: Icon(Icons.library_music),
      mobilePriority: true,
    ),
    VooNavigationDestination(
      id: 'settings',
      label: 'Settings',
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      mobilePriority: true,
    ),
  ];

  /// Get the item ID for the current branch index
  String _getSelectedId() {
    if (shell.currentIndex == 4) return 'profile';
    return _items[shell.currentIndex].id;
  }

  /// Get the branch index for a given item ID
  int _getIndexForId(String id) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == id) return i;
    }
    if (id == 'profile') return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return VooAdaptiveScaffold(
      config: VooNavigationConfig(
        items: _items,
        selectedId: _getSelectedId(),
        onNavigationItemSelected: (itemId) => shell.goBranch(_getIndexForId(itemId)),

        // User profile configuration - appears in drawer/rail footer and mobile nav
        userProfileConfig: VooUserProfileConfig(
          userName: 'Alex Johnson',
          userEmail: 'alex@example.com',
          avatarUrl: 'https://i.pravatar.cc/150?img=12',
          status: VooUserStatus.online,
          navItemLabel: 'Profile',
          mobilePriority: true,
          onTap: () => shell.goBranch(4),
          onSettingsTap: () => shell.goBranch(3),
          onLogout: () {
            // Handle logout
            debugPrint('Logout tapped');
          },
        ),

        // Header configuration
        headerConfig: const VooHeaderConfig(
          title: 'GoRouter Demo',
          tagline: 'Stateful Navigation',
          logoIcon: Icons.navigation_rounded,
        ),

        // Theming
        navigationTheme: const VooNavigationTheme(borderRadius: 8),

        // Layout
        drawerMargin: EdgeInsets.zero,
        navigationRailMargin: 0,
        contentAreaMargin: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
        contentAreaBorderRadius: BorderRadius.circular(12),
        navigationBackgroundColor: const Color(0xFFF9FAFB),
        contentAreaBackgroundColor: Colors.white,

        // Sizing
        navigationDrawerWidth: 240,
        navigationRailWidth: 72,
        extendedNavigationRailWidth: 240,

        // Features
        enableCollapsibleRail: true,
        showUserProfile: true,
        enableAnimations: true,
        enableHapticFeedback: true,
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: shell,
    );
  }
}

// =============================================================================
// PAGE WIDGETS
// =============================================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Welcome Home',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap an item to navigate while preserving this branch state.',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            5,
            (index) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Item ${index + 1}'),
                subtitle: const Text('Tap to see details'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/home/details/${index + 1}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeDetailsPage extends StatelessWidget {
  final String id;
  const HomeDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details #$id'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Details for Item #$id',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'This is a nested route within the Home branch.\nSwitch tabs and come back - the state is preserved!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  static const _categories = ['Music', 'Movies', 'Books', 'Games', 'Art', 'Tech'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Discover new content by category.',
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.go('/explore/category/$category'),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primaryContainer,
                              theme.colorScheme.primary.withValues(alpha: 0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/explore'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              '$category Category',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nested route in the Explore branch.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_music, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Your Library',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your saved content will appear here.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Settings',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: 'Theme, colors, and display',
          ),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your notifications',
          ),
          _SettingsTile(
            icon: Icons.lock_outline,
            title: 'Privacy',
            subtitle: 'Account and data privacy',
          ),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'FAQ and contact support',
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version and legal info',
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Alex Johnson',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'alex@example.com',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          // Profile stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ProfileStat(value: '127', label: 'Following'),
              _ProfileStat(value: '89', label: 'Followers'),
              _ProfileStat(value: '24', label: 'Posts'),
            ],
          ),
          const SizedBox(height: 32),
          // Profile actions
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Favorites'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Downloads'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
