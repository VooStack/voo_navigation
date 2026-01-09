import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const VooNavigationShowcaseApp());
}

class VooNavigationShowcaseApp extends StatelessWidget {
  const VooNavigationShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voo Navigation Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const SaasDashboardExample(),
    );
  }
}

class SaasDashboardExample extends StatefulWidget {
  const SaasDashboardExample({super.key});

  @override
  State<SaasDashboardExample> createState() => _SaasDashboardExampleState();
}

class _SaasDashboardExampleState extends State<SaasDashboardExample> {
  String _selectedId = 'employees';

  List<VooNavigationItem> get _navigationItems => [
        VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          mobilePriority: true,
          route: '/home',
        ),
        VooNavigationItem(
          id: 'dashboard',
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
          mobilePriority: true,
          route: '/dashboard',
        ),
        VooNavigationItem.divider(id: 'divider1'),
        VooNavigationItem.section(
          id: 'hr_section',
          label: 'HR Management',
          children: [
            VooNavigationItem(
              id: 'employees',
              label: 'Employees',
              icon: Icons.people_outline,
              selectedIcon: Icons.people,
              mobilePriority: true,
              badgeCount: 12,
              route: '/employees',
            ),
            VooNavigationItem(
              id: 'recruitment',
              label: 'Recruitment',
              icon: Icons.person_add_outlined,
              selectedIcon: Icons.person_add,
              route: '/recruitment',
            ),
            VooNavigationItem(
              id: 'attendance',
              label: 'Attendance',
              icon: Icons.access_time_outlined,
              selectedIcon: Icons.access_time_filled,
              route: '/attendance',
            ),
            VooNavigationItem(
              id: 'payroll',
              label: 'Payroll',
              icon: Icons.attach_money_outlined,
              selectedIcon: Icons.attach_money,
              route: '/payroll',
            ),
          ],
        ),
        VooNavigationItem.divider(id: 'divider2'),
        VooNavigationItem.section(
          id: 'settings_section',
          label: 'Settings',
          children: [
            VooNavigationItem(
              id: 'settings',
              label: 'Settings',
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              mobilePriority: true,
              route: '/settings',
            ),
            VooNavigationItem(
              id: 'help',
              label: 'Help & Support',
              icon: Icons.help_outline,
              selectedIcon: Icons.help,
              route: '/help',
            ),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Create the navigation config with full-height drawer and inset content
    final config = VooNavigationConfig.material3Enhanced(
      items: _navigationItems,
      selectedId: _selectedId,
      onNavigationItemSelected: (id) {
        setState(() => _selectedId = id);
      },
      // Full-height drawer (no margins)
      drawerMargin: EdgeInsets.zero,
      // Content area with padding from all sides except left (drawer side)
      contentAreaMargin: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        right: 12,
        left: 12,
      ),
      contentAreaBorderRadius: BorderRadius.circular(24),
      // Dark drawer background
      navigationBackgroundColor: isDark
          ? const Color(0xFF1A1A2E)
          : const Color(0xFF1E1E2D),
      // App bar inside content area
      appBarAlongsideRail: true,
      showAppBar: false, // We'll use custom content header
      navigationDrawerWidth: 260,
      showUserProfile: true,
      userProfileWidget: _buildUserProfile(context),
      drawerHeader: _buildDrawerHeader(context),
    );

    return VooAdaptiveScaffold(
      config: config,
      // Dark background for the scaffold (visible around content)
      backgroundColor: isDark
          ? const Color(0xFF1A1A2E)
          : const Color(0xFF1E1E2D),
      body: _buildContent(context),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.hexagon_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'HRSELINK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
            child: const Icon(
              Icons.person,
              color: Color(0xFF6366F1),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Workforce',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Content header (like the "Employee" header in the screenshot)
          _buildContentHeader(context),
          // Main content
          Expanded(
            child: _buildMainContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContentHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _getPageTitle(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Export button
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_outlined, size: 18),
                label: const Text('Export CSV'),
              ),
              const SizedBox(width: 12),
              // Add new button
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add new'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tabs
          _buildTabs(context),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _buildTab(context, 'Employee list', true),
        _buildTab(context, 'Directory', false),
        _buildTab(context, 'Org Chart', false),
        const Spacer(),
        // Search
        SizedBox(
          width: 200,
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(Icons.filter_list),
        ),
        const SizedBox(width: 8),
        IconButton.outlined(
          onPressed: () {},
          icon: const Icon(Icons.sort),
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, String label, bool isSelected) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: label.length * 8.0,
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          Row(
            children: [
              _buildStatCard(
                context,
                icon: Icons.people,
                label: 'Total employee',
                value: '1,384',
                change: '+12',
                isPositive: true,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                icon: Icons.person_add,
                label: 'New employee',
                value: '830',
                change: '-4%',
                isPositive: false,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                icon: Icons.person_off,
                label: 'Inactive employee',
                value: '5.31',
                change: '-6%',
                isPositive: true,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                context,
                icon: Icons.trending_up,
                label: 'Onboarding employee',
                value: '5.31',
                change: null,
                isPositive: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Employee table
          _buildEmployeeTable(context),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    String? change,
    required bool isPositive,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const Spacer(),
                if (change != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeTable(BuildContext context) {
    final theme = Theme.of(context);

    final employees = [
      {
        'name': 'David Paul Madison',
        'id': '#000000001',
        'title': 'UI Designer',
        'department': 'Design Team',
        'date': '12 August 2022',
        'status': 'Active',
      },
      {
        'name': 'Maria Yunami',
        'id': '#000000002',
        'title': 'HR Researcher',
        'department': 'Design Team',
        'date': '26 June 2020',
        'status': 'Active',
      },
      {
        'name': 'Cheyenne Ekstrom',
        'id': '#000000003',
        'title': 'IOS Developer',
        'department': 'Developer Team',
        'date': '01 February 2020',
        'status': 'Onboarding',
      },
      {
        'name': 'Alfredo Cardin',
        'id': '#000000004',
        'title': 'Android Developer',
        'department': 'Developer Team',
        'date': '03 May 2009',
        'status': 'Active',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                _buildTableHeader(context, 'Name of employee', flex: 2),
                _buildTableHeader(context, 'Employee ID'),
                _buildTableHeader(context, 'Job Title'),
                _buildTableHeader(context, 'Department'),
                _buildTableHeader(context, 'Join date'),
                _buildTableHeader(context, 'Status'),
              ],
            ),
          ),
          // Table rows
          ...employees.map((emp) => _buildTableRow(context, emp)),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, String label, {int flex = 1}) {
    final theme = Theme.of(context);

    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, Map<String, String> employee) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    employee['name']![0],
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  employee['name']!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              employee['id']!,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              employee['title']!,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              employee['department']!,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              employee['date']!,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: employee['status'] == 'Active'
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                employee['status']!,
                style: TextStyle(
                  color: employee['status'] == 'Active'
                      ? Colors.green
                      : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (_selectedId) {
      case 'home':
        return 'Home';
      case 'dashboard':
        return 'Dashboard';
      case 'employees':
        return 'Employee';
      case 'recruitment':
        return 'Recruitment';
      case 'attendance':
        return 'Attendance';
      case 'payroll':
        return 'Payroll';
      case 'settings':
        return 'Settings';
      case 'help':
        return 'Help & Support';
      default:
        return 'Employee';
    }
  }
}
