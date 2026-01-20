import 'package:flutter/material.dart';
import 'package:voo_navigation_rail/voo_navigation_rail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoO Navigation Rail Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NavigationRailExample(),
    );
  }
}

class NavigationRailExample extends StatefulWidget {
  const NavigationRailExample({super.key});

  @override
  State<NavigationRailExample> createState() => _NavigationRailExampleState();
}

class _NavigationRailExampleState extends State<NavigationRailExample> {
  String _selectedId = 'dashboard';
  bool _isExtended = true;

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

  final List<VooNavigationItem> _items = [
    const VooNavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: '/dashboard',
    ),
    VooNavigationItem.section(
      label: 'Teams',
      id: 'teams',
      isExpanded: true,
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
    const VooNavigationItem(
      id: 'analytics',
      label: 'Analytics',
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      route: '/analytics',
    ),
    const VooNavigationItem(
      id: 'notifications',
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
      badgeCount: 5,
      route: '/notifications',
    ),
  ];

  final List<VooNavigationItem> _footerItems = [];

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

  void _toggleExtended() {
    setState(() {
      _isExtended = !_isExtended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail
          VooAdaptiveNavigationRail(
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
              enableCollapsibleRail: true,
              navigationTheme: const VooNavigationTheme(
                borderRadius: 12,
                elevation: 0,
              ),
            ),
            selectedId: _selectedId,
            onNavigationItemSelected: _onNavigationItemSelected,
            extended: _isExtended,
            onToggleCollapse: _toggleExtended,
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
                // App Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isExtended
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                        ),
                        onPressed: _toggleExtended,
                        tooltip: _isExtended
                            ? 'Collapse rail'
                            : 'Expand rail',
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'VoO Navigation Rail',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),

                // Page Content
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconForId(_selectedId),
                          size: 64,
                          color: colorScheme.primary,
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
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isExtended ? 'Extended Mode' : 'Collapsed Mode',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                            ),
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
