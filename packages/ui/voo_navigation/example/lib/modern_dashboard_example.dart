import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const ModernDashboardApp());
}

class ModernDashboardApp extends StatelessWidget {
  const ModernDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A34A), // Green accent like screenshot
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A34A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ModernDashboard(),
    );
  }
}

class ModernDashboard extends StatefulWidget {
  const ModernDashboard({super.key});

  @override
  State<ModernDashboard> createState() => _ModernDashboardState();
}

class _ModernDashboardState extends State<ModernDashboard> {
  String _selectedId = 'employee';

  // Main navigation items - like HRISELINK example
  final List<VooNavigationItem> _navigationItems = [
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
      isExpanded: false,
      children: const [
        VooNavigationItem(
          id: 'team_overview',
          label: 'Overview',
          icon: Icons.visibility_outlined,
          route: '/teams/overview',
        ),
        VooNavigationItem(
          id: 'team_members',
          label: 'Members',
          icon: Icons.person_outline,
          route: '/teams/members',
        ),
      ],
    ),
    VooNavigationItem.section(
      label: 'Employee',
      id: 'employee_section',
      isExpanded: true,
      children: const [
        VooNavigationItem(
          id: 'employee',
          label: 'Employee',
          icon: Icons.badge_outlined,
          selectedIcon: Icons.badge,
          route: '/employee',
        ),
        VooNavigationItem(
          id: 'attendance',
          label: 'Attendance',
          icon: Icons.calendar_today_outlined,
          route: '/attendance',
        ),
        VooNavigationItem(
          id: 'checklist',
          label: 'Checklist',
          icon: Icons.checklist_outlined,
          route: '/checklist',
        ),
        VooNavigationItem(
          id: 'timeoff',
          label: 'Time off',
          icon: Icons.beach_access_outlined,
          route: '/timeoff',
        ),
      ],
    ),
    VooNavigationItem.section(
      label: 'Hire',
      id: 'hire',
      isExpanded: false,
      children: const [
        VooNavigationItem(
          id: 'hiring',
          label: 'Hiring',
          icon: Icons.work_outline,
          route: '/hire/hiring',
        ),
        VooNavigationItem(
          id: 'onboarding',
          label: 'Onboarding',
          icon: Icons.flight_land_outlined,
          route: '/hire/onboarding',
        ),
        VooNavigationItem(
          id: 'handbook',
          label: 'Hiring handbook',
          icon: Icons.menu_book_outlined,
          route: '/hire/handbook',
        ),
      ],
    ),
    VooNavigationItem.section(
      label: 'Finance',
      id: 'finance',
      isExpanded: false,
      children: const [
        VooNavigationItem(
          id: 'payroll',
          label: 'Payroll',
          icon: Icons.payments_outlined,
          route: '/finance/payroll',
        ),
        VooNavigationItem(
          id: 'expenses',
          label: 'Expenses',
          icon: Icons.receipt_long_outlined,
          route: '/finance/expenses',
        ),
        VooNavigationItem(
          id: 'incentives',
          label: 'Incentives',
          icon: Icons.card_giftcard_outlined,
          route: '/finance/incentives',
        ),
        VooNavigationItem(
          id: 'payment_info',
          label: 'Payment Information',
          icon: Icons.credit_card_outlined,
          route: '/finance/payment-info',
        ),
      ],
    ),
  ];

  // Footer items - Settings, Integrations, Help
  final List<VooNavigationItem> _footerItems = [
    const VooNavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      route: '/settings',
    ),
    const VooNavigationItem(
      id: 'integrations',
      label: 'Integrations',
      icon: Icons.extension_outlined,
      selectedIcon: Icons.extension,
      route: '/integrations',
    ),
    const VooNavigationItem(
      id: 'help',
      label: 'Help and support',
      icon: Icons.help_outline,
      selectedIcon: Icons.help,
      route: '/help',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final config = VooNavigationConfig(
      items: _navigationItems,
      selectedId: _selectedId,
      selectedItemColor: const Color(0xFF16A34A), // Green accent
      bottomNavigationType: VooNavigationBarType.custom,
      enableAnimations: true,
      enableHapticFeedback: true,
      showNotificationBadges: true,
      groupItemsBySections: true,
      railLabelType: NavigationRailLabelType.selected,
      useExtendedRail: true,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOutCubic,
      // Header with logo and title
      headerConfig: const VooHeaderConfig(
        title: 'HRISELINK',
        logoIcon: Icons.grid_view_rounded,
      ),
      // Search bar below header
      searchBar: VooSearchBarConfig(
        hintText: 'Search...',
        onSearch: (query) {
          // Handle search
        },
      ),
      searchBarPosition: VooSearchBarPosition.header,
      // Footer items
      footerItems: _footerItems,
      // User profile at bottom
      showUserProfile: true,
      userProfileConfig: const VooUserProfileConfig(
        userName: 'Washbone',
        userEmail: '11 members',
        status: VooUserStatus.online,
      ),
      // Content area styling
      contentAreaMargin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
      contentAreaBorderRadius: BorderRadius.circular(12),
      onNavigationItemSelected: (itemId) {
        setState(() {
          _selectedId = itemId;
        });
      },
    );

    return VooAdaptiveScaffold(
      config: config,
      body: _buildDashboardContent(context),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF1A1B1E) : const Color(0xFFF8F9FB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar like in screenshot
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                _buildTab(context, 'Employee list', true),
                const SizedBox(width: 24),
                _buildTab(context, 'Directory', false),
                const SizedBox(width: 24),
                _buildTab(context, 'ORG Chart', false),
                const Spacer(),
                // Search and actions
                SizedBox(
                  width: 200,
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                  tooltip: 'Filter',
                ),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {},
                  tooltip: 'Sort',
                ),
              ],
            ),
          ),

          // Stats cards
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildStatCard(context, '1,384', '+47', 'Total employee', Icons.people_outline),
                const SizedBox(width: 16),
                _buildStatCard(context, '839', '+72', 'Active employee', Icons.person_outline),
                const SizedBox(width: 16),
                _buildStatCard(context, '531', '-49', 'Inactive employee', Icons.person_off_outlined),
                const SizedBox(width: 16),
                _buildStatCard(context, '531', '+29', 'Onboarding employee', Icons.flight_land_outlined),
              ],
            ),
          ),

          // Employee table
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  // Table header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        SizedBox(width: 24, child: Checkbox(value: false, onChanged: (_) {})),
                        const SizedBox(width: 16),
                        _buildTableHeader(context, 'Name of employee', flex: 2),
                        _buildTableHeader(context, 'Employee ID'),
                        _buildTableHeader(context, 'Job title'),
                        _buildTableHeader(context, 'Department'),
                        _buildTableHeader(context, 'Join date'),
                        _buildTableHeader(context, 'Status'),
                      ],
                    ),
                  ),
                  // Table rows
                  Expanded(
                    child: ListView(
                      children: [
                        _buildEmployeeRow(context, 'Randy Rhiel Madsen', 'randy@email.com', 'A0D1D9N593', 'UI Designer', 'Design Team', '11 August 2022', 'Active'),
                        _buildEmployeeRow(context, 'Maria Rosser', 'maria@email.com', 'A0D2D0N196', 'UX Researcher', 'Design Team', '25 June 2021', 'Inactive'),
                        _buildEmployeeRow(context, 'Cheyenne Bothman', 'cheyenne@email.com', 'A0S0EY9381', 'iOS Developer', 'Design Team', '20 February 2025', 'Onboarding'),
                        _buildEmployeeRow(context, 'Alfredo Curtis', 'alfredo@email.com', 'A0HDEY5912', 'Android Developer', 'Developer Team', '14 May 2024', 'Active'),
                        _buildEmployeeRow(context, 'Ryan Saris Lewis', 'ryan@email.com', 'A0D3EY573', 'Back-End Developer', 'Developer Team', '31 July 2024', 'Active'),
                        _buildEmployeeRow(context, 'Giana Botosh', 'giana@email.com', 'A02MRY7028', 'Digital Marketing', 'Marketing Team', '04 December 2022', 'Inactive'),
                        _buildEmployeeRow(context, 'Rayna Baptista', 'rayna@email.com', 'A0LMVGR019', 'Project Manager', 'Management Team', '09 January 2022', 'Active'),
                      ],
                    ),
                  ),
                  // Table footer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text('10 records', style: theme.textTheme.bodySmall),
                        const Spacer(),
                        IconButton(icon: const Icon(Icons.chevron_left, size: 20), onPressed: () {}),
                        Text('1', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Text('2', style: theme.textTheme.bodySmall),
                        const SizedBox(width: 8),
                        Text('20', style: theme.textTheme.bodySmall),
                        IconButton(icon: const Icon(Icons.chevron_right, size: 20), onPressed: () {}),
                        const SizedBox(width: 16),
                        Text('10 / 234', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, bool isSelected) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String change, String label, IconData icon) {
    final theme = Theme.of(context);
    final isPositive = change.startsWith('+');

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text(
                        change,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context, String label, {int flex = 1}) {
    final theme = Theme.of(context);
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(width: 4),
          Icon(Icons.unfold_more, size: 14, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildEmployeeRow(BuildContext context, String name, String email, String id, String jobTitle, String department, String joinDate, String status) {
    final theme = Theme.of(context);

    Color statusColor;
    Color statusBgColor;
    switch (status) {
      case 'Active':
        statusColor = const Color(0xFF16A34A);
        statusBgColor = const Color(0xFF16A34A).withValues(alpha: 0.1);
        break;
      case 'Inactive':
        statusColor = const Color(0xFFEF4444);
        statusBgColor = const Color(0xFFEF4444).withValues(alpha: 0.1);
        break;
      case 'Onboarding':
        statusColor = const Color(0xFFF59E0B);
        statusBgColor = const Color(0xFFF59E0B).withValues(alpha: 0.1);
        break;
      default:
        statusColor = theme.colorScheme.onSurface;
        statusBgColor = theme.colorScheme.surfaceContainerHighest;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          SizedBox(width: 24, child: Checkbox(value: false, onChanged: (_) {})),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(name.split(' ').map((e) => e[0]).take(2).join(), style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      Text(email, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Text(id, style: theme.textTheme.bodySmall)),
          Expanded(child: Text(jobTitle, style: theme.textTheme.bodySmall)),
          Expanded(child: Text(department, style: theme.textTheme.bodySmall)),
          Expanded(child: Text(joinDate, style: theme.textTheme.bodySmall)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status,
                style: theme.textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
