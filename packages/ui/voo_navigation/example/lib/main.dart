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
  String _selectedId = 'dashboard';
  String _searchQuery = '';

  final List<VooNavigationItem> _items = [
    const VooNavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      mobilePriority: true,
      route: '/dashboard',
    ),
    VooNavigationItem.section(
      label: 'Teams',
      id: 'teams',
      isExpanded: false,
      children: const [
        VooNavigationItem(
          id: 'team_overview',
          label: 'Overview',
          icon: Icons.groups_outlined,
          selectedIcon: Icons.groups,
          route: '/teams/overview',
        ),
        VooNavigationItem(
          id: 'team_members',
          label: 'Members',
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          route: '/teams/members',
        ),
      ],
    ),
    VooNavigationItem.section(
      label: 'Employee',
      id: 'employee',
      isExpanded: true,
      children: const [
        VooNavigationItem(
          id: 'attendance',
          label: 'Attendance',
          icon: Icons.access_time_outlined,
          selectedIcon: Icons.access_time,
          route: '/employee/attendance',
        ),
        VooNavigationItem(
          id: 'checklist',
          label: 'Checklist',
          icon: Icons.checklist_outlined,
          selectedIcon: Icons.checklist,
          route: '/employee/checklist',
        ),
        VooNavigationItem(
          id: 'time_off',
          label: 'Time off',
          icon: Icons.beach_access_outlined,
          selectedIcon: Icons.beach_access,
          route: '/employee/time-off',
        ),
      ],
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

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
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
        // Header configuration with tagline
        headerConfig: const VooHeaderConfig(
          title: 'ACME',
          tagline: 'Corp',
          logoIcon: Icons.rocket_launch,
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
        // Search bar configuration
        searchBar: VooSearchBarConfig(
          hintText: 'Search...',
          onSearch: _onSearch,
          enableKeyboardShortcut: true,
          keyboardShortcutHint: '⌘K',
        ),
        searchBarPosition: VooSearchBarPosition.header,
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
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Search: $_searchQuery',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  VooNavigationItem? _findItemById(String id) {
    final allItems = [..._items, ..._footerItems];
    for (final item in allItems) {
      if (item.id == id) return item;
      if (item.children != null) {
        for (final child in item.children!) {
          if (child.id == id) return child;
        }
      }
    }
    return null;
  }

  IconData _getIconForId(String id) {
    final item = _findItemById(id) ?? _items.first;
    return item.selectedIcon ?? item.icon;
  }

  String _getLabelForId(String id) {
    final item = _findItemById(id) ?? _items.first;
    return item.label;
  }
}
