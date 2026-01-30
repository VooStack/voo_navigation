import 'package:flutter/material.dart';
import 'package:voo_navigation_drawer/voo_navigation_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoO Navigation Drawer Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const NavigationDrawerExample(),
    );
  }
}

class NavigationDrawerExample extends StatefulWidget {
  const NavigationDrawerExample({super.key});

  @override
  State<NavigationDrawerExample> createState() => _NavigationDrawerExampleState();
}

class _NavigationDrawerExampleState extends State<NavigationDrawerExample> {
  String _selectedId = 'dashboard';

  // Organization switcher state
  late VooOrganization _selectedOrganization;
  final List<VooOrganization> _organizations = [
    const VooOrganization(
      id: 'acme',
      name: 'ACME Corp',
      subtitle: '12 members',
      avatarColor: Colors.blue,
    ),
    const VooOrganization(
      id: 'startup',
      name: 'Startup Inc',
      subtitle: '5 members',
      avatarColor: Colors.green,
    ),
    const VooOrganization(
      id: 'enterprise',
      name: 'Enterprise Ltd',
      subtitle: '50 members',
      avatarColor: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedOrganization = _organizations.first;
  }

  final List<VooNavigationDestination> _items = [
    const VooNavigationDestination(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      route: '/dashboard',
    ),
    VooNavigationDestination.section(
      label: 'Teams',
      id: 'teams',
      isExpanded: true,
      children: const [
        VooNavigationDestination(
          id: 'team_overview',
          label: 'Overview',
          icon: Icon(Icons.groups_outlined),
          selectedIcon: Icon(Icons.groups),
          route: '/teams/overview',
        ),
        VooNavigationDestination(
          id: 'team_members',
          label: 'Members',
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          route: '/teams/members',
        ),
      ],
    ),
    VooNavigationDestination.section(
      label: 'Employee',
      id: 'employee',
      isExpanded: true,
      children: const [
        VooNavigationDestination(
          id: 'attendance',
          label: 'Attendance',
          icon: Icon(Icons.access_time_outlined),
          selectedIcon: Icon(Icons.access_time),
          route: '/employee/attendance',
        ),
        VooNavigationDestination(
          id: 'checklist',
          label: 'Checklist',
          icon: Icon(Icons.checklist_outlined),
          selectedIcon: Icon(Icons.checklist),
          route: '/employee/checklist',
        ),
        VooNavigationDestination(
          id: 'time_off',
          label: 'Time off',
          icon: Icon(Icons.beach_access_outlined),
          selectedIcon: Icon(Icons.beach_access),
          route: '/employee/time-off',
        ),
      ],
    ),
    const VooNavigationDestination(
      id: 'notifications',
      label: 'Notifications',
      icon: Icon(Icons.notifications_outlined),
      selectedIcon: Icon(Icons.notifications),
      badgeCount: 3,
      route: '/notifications',
    ),
  ];

  final List<VooNavigationDestination> _footerItems = [];

  void _onNavigationItemSelected(String itemId) {
    setState(() {
      _selectedId = itemId;
    });
  }

  void _onOrganizationChanged(VooOrganization org) {
    setState(() {
      _selectedOrganization = org;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // Navigation Drawer
          SizedBox(
            width: 280,
            child: VooAdaptiveNavigationDrawer(
              config: VooNavigationConfig(
                items: _items,
                footerItems: _footerItems,
                selectedId: _selectedId,
                onNavigationItemSelected: _onNavigationItemSelected,
                headerConfig: const VooHeaderConfig(
                  title: 'ACME',
                  tagline: 'Corp',
                  logoIcon: Icons.rocket_launch,
                  showTitle: true,
                ),
                organizationSwitcher: VooOrganizationSwitcherConfig(
                  organizations: _organizations,
                  selectedOrganization: _selectedOrganization,
                  onOrganizationChanged: _onOrganizationChanged,
                  onCreateOrganization: () {
                    debugPrint('Create organization tapped');
                  },
                ),
                userProfileConfig: VooUserProfileConfig(
                  userName: 'John Doe',
                  userEmail: 'john@example.com',
                  initials: 'JD',
                  status: VooUserStatus.online,
                  onSettingsTap: () {
                    setState(() {
                      _selectedId = 'settings';
                    });
                  },
                  onLogout: () {
                    debugPrint('Logout tapped');
                  },
                ),
                navigationTheme: const VooNavigationTheme(
                  borderRadius: 12,
                  elevation: 0,
                ),
              ),
              selectedId: _selectedId,
              onNavigationItemSelected: _onNavigationItemSelected,
            ),
          ),

          // Divider
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorScheme.outlineVariant,
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // App Bar - uses AppBar widget for proper alignment with drawer header
                AppBar(
                  title: Text(
                    'Dashboard',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  backgroundColor: colorScheme.surface,
                  elevation: 0,
                  toolbarHeight: kToolbarHeight,
                  titleSpacing: 24,
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(
                      height: 1,
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                ),

                // Page Content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            size: 64,
                            color: colorScheme.primary,
                          ),
                          child: _getIconForId(_selectedId),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getLabelForId(_selectedId),
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Selected: $_selectedId',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Organization: ${_selectedOrganization.name}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  VooNavigationDestination? _findItemById(String id) {
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

  Widget _getIconForId(String id) {
    final item = _findItemById(id) ?? _items.first;
    return item.selectedIcon ?? item.icon;
  }

  String _getLabelForId(String id) {
    final item = _findItemById(id) ?? _items.first;
    return item.label;
  }
}
