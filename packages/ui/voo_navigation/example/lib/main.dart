import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoO Navigation Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  String _selectedId = 'home';

  final List<VooNavigationItem> _items = [
    const VooNavigationItem(
      id: 'home',
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      mobilePriority: true,
      route: '/home',
    ),
    const VooNavigationItem(
      id: 'search',
      label: 'Search',
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      mobilePriority: true,
      route: '/search',
    ),
    const VooNavigationItem(
      id: 'notifications',
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
      mobilePriority: true,
      badgeCount: 3,
      route: '/notifications',
    ),
    const VooNavigationItem(
      id: 'profile',
      label: 'Profile',
      icon: Icons.person_outlined,
      selectedIcon: Icons.person,
      mobilePriority: true,
      route: '/profile',
    ),
  ];

  final List<VooNavigationItem> _footerItems = [
    const VooNavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      route: '/settings',
    ),
  ];

  void _onNavigationItemSelected(String itemId) {
    setState(() {
      _selectedId = itemId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VooAdaptiveScaffold(
      config: VooNavigationConfig(
        items: _items,
        footerItems: _footerItems,
        selectedId: _selectedId,
        onNavigationItemSelected: _onNavigationItemSelected,
        // Simple theme configuration
        navigationTheme: const VooNavigationTheme(
          borderRadius: 12,
          elevation: 0,
        ),
        // Header configuration
        headerConfig: const VooHeaderConfig(
          title: 'Navigation',
          logoIcon: Icons.apps,
          showTitle: true,
        ),
        // Enable collapsible rail for desktop
        enableCollapsibleRail: true,
        // Show user profile in navigation
        showUserProfile: true,
        userProfileConfig: const VooUserProfileConfig(
          userName: 'John Doe',
          userEmail: 'john@example.com',
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForId(_selectedId),
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            _getLabelForId(_selectedId),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Selected: $_selectedId',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForId(String id) {
    final allItems = [..._items, ..._footerItems];
    final item = allItems.firstWhere(
      (item) => item.id == id,
      orElse: () => _items.first,
    );
    return item.selectedIcon ?? item.icon;
  }

  String _getLabelForId(String id) {
    final allItems = [..._items, ..._footerItems];
    final item = allItems.firstWhere(
      (item) => item.id == id,
      orElse: () => _items.first,
    );
    return item.label;
  }
}
