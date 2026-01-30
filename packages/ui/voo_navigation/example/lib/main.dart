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
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
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

  // Organization switcher state
  late VooOrganization _selectedOrganization;
  final List<VooOrganization> _organizations = [
    const VooOrganization(id: 'acme', name: 'ACME Corp', subtitle: '12 members', avatarColor: Colors.blue),
    const VooOrganization(id: 'startup', name: 'Startup Inc', subtitle: '5 members', avatarColor: Colors.green),
    const VooOrganization(id: 'enterprise', name: 'Enterprise Ltd', subtitle: '50 members', avatarColor: Colors.purple),
  ];

  @override
  void initState() {
    super.initState();
    _selectedOrganization = _organizations.first;
  }

  final List<VooNavigationDestination> _items = [
    const VooNavigationDestination(id: 'dashboard', label: 'Dashboard', icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), mobilePriority: true, route: '/dashboard'),
    VooNavigationDestination.section(
      label: 'Teams',
      id: 'teams',
      isExpanded: false,
      children: const [
        VooNavigationDestination(id: 'team_overview', label: 'Overview', icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), route: '/teams/overview'),
        VooNavigationDestination(id: 'team_members', label: 'Members', icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), route: '/teams/members'),
      ],
    ),
    VooNavigationDestination.section(
      label: 'Employee',
      id: 'employee',
      isExpanded: true,
      children: const [
        VooNavigationDestination(id: 'attendance', label: 'Attendance', icon: Icon(Icons.access_time_outlined), selectedIcon: Icon(Icons.access_time), route: '/employee/attendance'),
        VooNavigationDestination(id: 'checklist', label: 'Checklist', icon: Icon(Icons.checklist_outlined), selectedIcon: Icon(Icons.checklist), route: '/employee/checklist'),
        VooNavigationDestination(id: 'time_off', label: 'Time off', icon: Icon(Icons.beach_access_outlined), selectedIcon: Icon(Icons.beach_access), route: '/employee/time-off'),
      ],
    ),
    const VooNavigationDestination(
      id: 'notifications',
      label: 'Notifications',
      icon: Icon(Icons.notifications_outlined),
      selectedIcon: Icon(Icons.notifications),
      mobilePriority: true,
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

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onOrganizationChanged(VooOrganization org) {
    setState(() {
      _selectedOrganization = org;
    });
  }

  void _onCreateOrganization() {
    // Handle create organization
    debugPrint('Create organization tapped');
  }

  void _onSettingsTap() {
    setState(() {
      _selectedId = 'settings';
    });
  }

  void _onLogout() {
    debugPrint('Logout tapped');
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
        navigationTheme: const VooNavigationTheme(borderRadius: 12, elevation: 0),

        // Header configuration with tagline
        headerConfig: const VooHeaderConfig(title: 'ACME', tagline: 'Corp', logoIcon: Icons.rocket_launch, showTitle: true),

        // Enable collapsible rail for desktop
        enableCollapsibleRail: true,

        // ========================================
        // MULTI-SWITCHER API (replaces org + user)
        // ========================================
        // The multi-switcher combines organization and user switching
        // into a unified, beautifully animated component.
        // When configured, it replaces the separate org switcher and user profile.
        multiSwitcher: VooMultiSwitcherConfig(
          // Organization data
          organizations: _organizations,
          selectedOrganization: _selectedOrganization,
          onOrganizationChanged: _onOrganizationChanged,
          onCreateOrganization: _onCreateOrganization,
          createOrganizationLabel: 'New Organization',

          // User data
          userName: 'John Doe',
          userEmail: 'john@example.com',
          initials: 'JD',
          status: VooUserStatus.online,

          // Actions
          onSettingsTap: _onSettingsTap,
          onLogout: _onLogout,

          // Display options
          showOrganizationSection: true,
          showUserSection: true,
          showSearch: true,
          organizationSectionTitle: 'Workspaces',
          userSectionTitle: 'Account',
        ),
        multiSwitcherPosition: VooMultiSwitcherPosition.footer,

        // Disable old switchers when using multi-switcher
        showUserProfile: false,
        organizationSwitcher: null,

        // Search bar configuration
        searchBar: VooSearchBarConfig(hintText: 'Search...', onSearch: _onSearch, enableKeyboardShortcut: true, keyboardShortcutHint: '⌘K'),
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
          IconTheme(
            data: IconThemeData(size: 64, color: Theme.of(context).colorScheme.primary),
            child: _getIconForId(_selectedId),
          ),
          const SizedBox(height: 16),
          Text(_getLabelForId(_selectedId), style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Selected: $_selectedId', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Text('Organization: ${_selectedOrganization.name}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Search: $_searchQuery', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
          ],
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
