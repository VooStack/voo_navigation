import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const HRISELinkApp());
}

/// HRISELINK-style HR Management Application
class HRISELinkApp extends StatefulWidget {
  const HRISELinkApp({super.key});

  @override
  State<HRISELinkApp> createState() => _HRISELinkAppState();
}

class _HRISELinkAppState extends State<HRISELinkApp> {
  String _selectedId = 'employee';
  final Set<String> _expandedSections = {'employee-section', 'hire-section', 'finance-section'};

  // Navigation items matching HRISELINK structure
  List<VooNavigationItem> get _navigationItems => [
    VooNavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      onTap: () => _onNavigationItemSelected('dashboard'),
    ),
    // Teams section
    VooNavigationItem(
      id: 'teams-section',
      label: 'Teams',
      icon: Icons.language,
      selectedIcon: Icons.language,
      isExpanded: _expandedSections.contains('teams-section'),
      children: [
        VooNavigationItem(id: 'teams', label: 'All Teams', icon: Icons.groups_outlined, onTap: () => _onNavigationItemSelected('teams')),
      ],
    ),
    // Employee section (expanded by default)
    VooNavigationItem(
      id: 'employee-section',
      label: 'Employee',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      isExpanded: _expandedSections.contains('employee-section'),
      children: [
        VooNavigationItem(id: 'employee', label: 'Employee', icon: Icons.badge_outlined, onTap: () => _onNavigationItemSelected('employee')),
        VooNavigationItem(id: 'attendance', label: 'Attendance', icon: Icons.access_time, onTap: () => _onNavigationItemSelected('attendance')),
        VooNavigationItem(id: 'checklist', label: 'Checklist', icon: Icons.checklist, onTap: () => _onNavigationItemSelected('checklist')),
        VooNavigationItem(id: 'time-off', label: 'Time off', icon: Icons.event_busy_outlined, onTap: () => _onNavigationItemSelected('time-off')),
      ],
    ),
    // Hire section
    VooNavigationItem(
      id: 'hire-section',
      label: 'Hire',
      icon: Icons.work_outline,
      selectedIcon: Icons.work,
      isExpanded: _expandedSections.contains('hire-section'),
      children: [
        VooNavigationItem(id: 'hiring', label: 'Hiring', icon: Icons.person_add_outlined, onTap: () => _onNavigationItemSelected('hiring')),
        VooNavigationItem(id: 'onboarding', label: 'Onboarding', icon: Icons.flight_takeoff, onTap: () => _onNavigationItemSelected('onboarding')),
        VooNavigationItem(id: 'hiring-handbook', label: 'Hiring handbook', icon: Icons.menu_book_outlined, onTap: () => _onNavigationItemSelected('hiring-handbook')),
      ],
    ),
    // Finance section
    VooNavigationItem(
      id: 'finance-section',
      label: 'Finance',
      icon: Icons.attach_money,
      selectedIcon: Icons.attach_money,
      isExpanded: _expandedSections.contains('finance-section'),
      children: [
        VooNavigationItem(id: 'payroll', label: 'Payroll', icon: Icons.payments_outlined, onTap: () => _onNavigationItemSelected('payroll')),
        VooNavigationItem(id: 'expenses', label: 'Expenses', icon: Icons.receipt_long_outlined, onTap: () => _onNavigationItemSelected('expenses')),
        VooNavigationItem(id: 'incentives', label: 'Incentives', icon: Icons.card_giftcard_outlined, onTap: () => _onNavigationItemSelected('incentives')),
        VooNavigationItem(id: 'payment-info', label: 'Payment information', icon: Icons.credit_card_outlined, onTap: () => _onNavigationItemSelected('payment-info')),
      ],
    ),
    VooNavigationItem.divider(id: 'divider1'),
    VooNavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      onTap: () => _onNavigationItemSelected('settings'),
    ),
    VooNavigationItem(
      id: 'integrations',
      label: 'Integrations',
      icon: Icons.extension_outlined,
      selectedIcon: Icons.extension,
      onTap: () => _onNavigationItemSelected('integrations'),
    ),
    VooNavigationItem(
      id: 'help',
      label: 'Help and support',
      icon: Icons.help_outline,
      selectedIcon: Icons.help,
      onTap: () => _onNavigationItemSelected('help'),
    ),
  ];

  void _onNavigationItemSelected(String itemId) {
    // Handle section expansion
    if (itemId.endsWith('-section')) {
      setState(() {
        if (_expandedSections.contains(itemId)) {
          _expandedSections.remove(itemId);
        } else {
          _expandedSections.add(itemId);
        }
      });
      return;
    }
    setState(() => _selectedId = itemId);
  }

  String _getPageTitle() {
    switch (_selectedId) {
      case 'dashboard': return 'Dashboard';
      case 'employee': return 'Employee';
      case 'attendance': return 'Attendance';
      case 'checklist': return 'Checklist';
      case 'time-off': return 'Time off';
      case 'hiring': return 'Hiring';
      case 'onboarding': return 'Onboarding';
      case 'hiring-handbook': return 'Hiring Handbook';
      case 'payroll': return 'Payroll';
      case 'expenses': return 'Expenses';
      case 'incentives': return 'Incentives';
      case 'payment-info': return 'Payment Information';
      case 'settings': return 'Settings';
      case 'integrations': return 'Integrations';
      case 'help': return 'Help and support';
      default: return 'Employee';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRISELINK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981), // Teal/Emerald like HRISELINK
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: _buildMainScaffold(context),
    );
  }

  Widget _buildMainScaffold(BuildContext context) {
    final theme = Theme.of(context);

    final navTheme = VooNavigationTheme.minimalModern().copyWith(
      containerBorderRadius: 0, // Flat design
    );

    final config = VooNavigationConfig(
      items: _navigationItems,
      selectedId: _selectedId,
      onNavigationItemSelected: _onNavigationItemSelected,
      navigationTheme: navTheme,
      groupItemsBySections: true,

      // Flat edge-to-edge layout
      drawerMargin: EdgeInsets.zero,
      navigationRailMargin: 0,
      contentAreaMargin: EdgeInsets.zero,
      contentAreaBorderRadius: BorderRadius.zero,

      // White sidebar
      navigationBackgroundColor: Colors.white,

      // App bar with custom builder
      appBarAlongsideRail: true,
      showAppBar: true,
      appBarTitleBuilder: (_) => Text(
        _getPageTitle(),
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      appBarActionsBuilder: (_) => [
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: () {},
          tooltip: 'Messages',
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1F2937),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text('Export CSV'),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1F2937),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: const Text('Add new'),
        ),
      ],

      // Sizing - compact like reference
      navigationDrawerWidth: 200,
      navigationRailWidth: 64,
      extendedNavigationRailWidth: 200,

      // Enable collapsible rail
      enableCollapsibleRail: true,

      // User profile at bottom
      showUserProfile: true,
      userProfileWidget: _buildUserProfile(context),

      // Custom header with logo and search
      drawerHeader: _buildDrawerHeader(context),

      // Bottom navigation for mobile
      floatingBottomNav: true,
      floatingBottomNavMargin: 16,
      floatingBottomNavBottomMargin: 24,

      // Animations
      enableAnimations: true,
      animationDuration: const Duration(milliseconds: 250),
      enableHapticFeedback: true,
    );

    return VooAdaptiveScaffold(
      config: config,
      backgroundColor: Colors.white,
      body: _buildPageContent(),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo and title (collapse toggle is handled by the scaffold)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 0, 8),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.hexagon_outlined,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'HRISELINK',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(
                  Icons.search,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Search...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.keyboard_command_key, size: 9, color: theme.colorScheme.onSurface.withValues(alpha: 0.35)),
                      const SizedBox(width: 1),
                      Text(
                        'F',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                'WB',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Wishbone',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    fontSize: 12,
                  ),
                ),
                Text(
                  '61 members',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedId) {
      case 'employee':
        return const EmployeePage();
      case 'dashboard':
        return const DashboardPage();
      default:
        return PlaceholderPage(title: _getPageTitle());
    }
  }
}

/// Employee Page - Main content matching HRISELINK design
class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Employee> _employees = Employee.sampleData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab bar and search/filters in same row
        _buildTabBarAndFilters(context),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats cards
                _buildStatsCards(context),
                const SizedBox(height: 24),
                // Data table
                _buildDataTable(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarAndFilters(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          // Tabs on left
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: const Color(0xFF1F2937),
              unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: const Color(0xFF1F2937),
              indicatorWeight: 2,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: theme.textTheme.bodyMedium,
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: const [
                Tab(text: 'Employee list'),
                Tab(text: 'Directory'),
                Tab(text: 'ORG Chart'),
              ],
            ),
          ),
          // Search and filters on right
          Container(
            width: 180,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Icon(
                  Icons.search,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 8),
                Text(
                  'Search...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Filter button
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.filter_list, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            label: const Text('Filter'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
            ),
          ),
          const SizedBox(width: 8),
          // Sort button
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.swap_vert, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            label: const Text('Sort'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 48) / 4;
        return Row(
          children: [
            _buildStatCard(context, '1,384', 'Total employee', '+47', const Color(0xFFE0E7FF), const Color(0xFF6366F1), cardWidth),
            const SizedBox(width: 16),
            _buildStatCard(context, '839', 'Active employee', '+72', const Color(0xFFD1FAE5), const Color(0xFF10B981), cardWidth),
            const SizedBox(width: 16),
            _buildStatCard(context, '531', 'Inactive employee', '-49', const Color(0xFFFEE2E2), const Color(0xFFEF4444), cardWidth),
            const SizedBox(width: 16),
            _buildStatCard(context, '531', 'Onboarding employee', '+29', const Color(0xFFFEF3C7), const Color(0xFFF59E0B), cardWidth),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, String change, Color bgColor, Color accentColor, double width) {
    final theme = Theme.of(context);
    final isPositive = change.startsWith('+');

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Person icon in colored circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person, color: accentColor, size: 26),
          ),
          const SizedBox(height: 16),
          // Value with change indicator
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                change,
                style: TextStyle(
                  color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
    );
  }

  Widget _buildDataTable(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Checkbox(
                    value: false,
                    onChanged: (_) {},
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                _buildHeaderCell('Name of employee', flex: 3),
                _buildHeaderCell('Employee ID', flex: 2),
                _buildHeaderCell('Job title', flex: 2),
                _buildHeaderCell('Department', flex: 2),
                _buildHeaderCell('Join date', flex: 2),
                _buildHeaderCell('Status', flex: 1),
                const SizedBox(width: 40), // Space for more button
              ],
            ),
          ),
          // Table rows
          ...List.generate(_employees.length, (index) {
            final employee = _employees[index];
            return _buildTableRow(context, employee, index);
          }),
          // Pagination
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: const Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '10 records',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 18),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '20',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(width: 8),
                ...[1, 2, 3].map((page) => Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: page == 1 ? theme.colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '$page',
                      style: TextStyle(
                        color: page == 1 ? Colors.white : theme.colorScheme.onSurface,
                        fontWeight: page == 1 ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )),
                const SizedBox(width: 8),
                Text(
                  '10 - 1/94',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.unfold_more, size: 14, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _buildTableRow(BuildContext context, Employee employee, int index) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: index.isEven ? Colors.white : const Color(0xFFF9FAFB),
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Checkbox(
              value: false,
              onChanged: (_) {},
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          // Name with avatar
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(employee.avatarUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        employee.email,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Employee ID
          Expanded(
            flex: 2,
            child: Text(
              employee.employeeId,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Job title
          Expanded(
            flex: 2,
            child: Text(
              employee.jobTitle,
              style: theme.textTheme.bodySmall,
            ),
          ),
          // Department
          Expanded(
            flex: 2,
            child: Text(
              employee.department,
              style: theme.textTheme.bodySmall,
            ),
          ),
          // Join date
          Expanded(
            flex: 2,
            child: Text(
              employee.joinDate,
              style: theme.textTheme.bodySmall,
            ),
          ),
          // Status
          Expanded(
            flex: 1,
            child: _buildStatusBadge(employee.status),
          ),
          // More button
          SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.more_vert, size: 18),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(EmployeeStatus status) {
    final (color, bgColor, text) = switch (status) {
      EmployeeStatus.active => (const Color(0xFF10B981), const Color(0xFFD1FAE5), 'Active'),
      EmployeeStatus.inactive => (const Color(0xFFEF4444), const Color(0xFFFEE2E2), 'Inactive'),
      EmployeeStatus.onboarding => (const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Onboarding'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Simple Dashboard Page
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Here\'s what\'s happening with your team today.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder page for other sections
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This page is under construction',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// Data models
enum EmployeeStatus { active, inactive, onboarding }

class Employee {
  final String name;
  final String email;
  final String employeeId;
  final String jobTitle;
  final String department;
  final String joinDate;
  final EmployeeStatus status;
  final String avatarUrl;

  const Employee({
    required this.name,
    required this.email,
    required this.employeeId,
    required this.jobTitle,
    required this.department,
    required this.joinDate,
    required this.status,
    required this.avatarUrl,
  });

  static List<Employee> get sampleData => [
    Employee(
      name: 'Randy Rhiel Madsen',
      email: 'randyrhiel@email.com',
      employeeId: 'A01D05N93',
      jobTitle: 'UI Designer',
      department: 'Design Team',
      joinDate: '13 August 2022',
      status: EmployeeStatus.active,
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    ),
    Employee(
      name: 'Maria Rosser',
      email: 'mariarosser@email.com',
      employeeId: 'A02D05N196',
      jobTitle: 'UX Researcher',
      department: 'Design Team',
      joinDate: '29 June 2021',
      status: EmployeeStatus.inactive,
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    Employee(
      name: 'Cheyenne Bothman',
      email: 'bothmanvery@email.com',
      employeeId: 'A05DEV9B1',
      jobTitle: 'iOS Developer',
      department: 'Developer Team',
      joinDate: '20 February 2025',
      status: EmployeeStatus.onboarding,
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    Employee(
      name: 'Alfredo Curtis',
      email: 'alfredocurtis@email.com',
      employeeId: 'A04DEV9312',
      jobTitle: 'Android Developer',
      department: 'Developer Team',
      joinDate: '14 May 2024',
      status: EmployeeStatus.active,
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
    ),
    Employee(
      name: 'Ryan Saris Lewis',
      email: 'ryansarislewis@email.com',
      employeeId: 'A03DEV9273',
      jobTitle: 'Back-End Developer',
      department: 'Developer Team',
      joinDate: '31 July 2024',
      status: EmployeeStatus.active,
      avatarUrl: 'https://i.pravatar.cc/150?img=7',
    ),
    Employee(
      name: 'Giana Botosh',
      email: 'gianabotosh@email.com',
      employeeId: 'A02MRKT008',
      jobTitle: 'Digital Marketing',
      department: 'Marketing Team',
      joinDate: '04 December 2022',
      status: EmployeeStatus.inactive,
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
    ),
    Employee(
      name: 'Rayna Baptista',
      email: 'raynabaptista@email.com',
      employeeId: 'A01MNGR019',
      jobTitle: 'Project Manager',
      department: 'Management Team',
      joinDate: '09 January 2022',
      status: EmployeeStatus.inactive,
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
    ),
    Employee(
      name: 'Kaiya Wilson',
      email: 'kaiyawilson@email.com',
      employeeId: 'A03D05N083',
      jobTitle: 'Graphic Designer',
      department: 'Team Design',
      joinDate: '18 October 2024',
      status: EmployeeStatus.active,
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
    ),
    Employee(
      name: 'Ahmad Workman',
      email: 'workman.ahmad@email.com',
      employeeId: 'A04MRKT012',
      jobTitle: 'Sales Marketing',
      department: 'Marketing Team',
      joinDate: '09 January 2025',
      status: EmployeeStatus.onboarding,
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    Employee(
      name: 'Marilyn Franci',
      email: 'marilynfranci@email.com',
      employeeId: 'A05D05N126',
      jobTitle: 'UI Designer',
      department: 'Team Design',
      joinDate: '28 September 2022',
      status: EmployeeStatus.active,
      avatarUrl: 'https://i.pravatar.cc/150?img=13',
    ),
  ];
}
