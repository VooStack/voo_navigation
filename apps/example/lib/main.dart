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
  VooContextItem? _selectedProject;

  // Sample projects for context switcher
  List<VooContextItem> get _projects => [
    VooContextItem(
      id: 'proj-1',
      name: 'Marketing Website',
      icon: Icons.web,
      color: const Color(0xFF6366F1),
      subtitle: '12 tasks',
    ),
    VooContextItem(
      id: 'proj-2',
      name: 'Mobile App',
      icon: Icons.phone_android,
      color: const Color(0xFF10B981),
      subtitle: '8 tasks',
    ),
    VooContextItem(
      id: 'proj-3',
      name: 'API Development',
      icon: Icons.api,
      color: const Color(0xFFF59E0B),
      subtitle: '23 tasks',
    ),
    VooContextItem(
      id: 'proj-4',
      name: 'Design System',
      icon: Icons.palette,
      color: const Color(0xFFEC4899),
      subtitle: '5 tasks',
    ),
  ];

  // Project-specific navigation items (changes based on selected project)
  List<VooNavigationItem> get _projectNavigationItems {
    if (_selectedProject == null) {
      // Return empty when no project selected - user should select from context switcher
      return [];
    }

    // Navigation items that change based on selected project
    return [
      VooNavigationItem(
        id: 'project-overview',
        label: 'Overview',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        mobilePriority: true,
        route: '/projects/${_selectedProject!.id}/overview',
      ),
      VooNavigationItem(
        id: 'project-tasks',
        label: 'Tasks',
        icon: Icons.check_circle_outline,
        selectedIcon: Icons.check_circle,
        mobilePriority: true,
        route: '/projects/${_selectedProject!.id}/tasks',
      ),
      VooNavigationItem(
        id: 'project-files',
        label: 'Files',
        icon: Icons.folder_outlined,
        selectedIcon: Icons.folder,
        route: '/projects/${_selectedProject!.id}/files',
      ),
      VooNavigationItem(
        id: 'project-team',
        label: 'Team',
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        route: '/projects/${_selectedProject!.id}/team',
      ),
      VooNavigationItem(
        id: 'project-timeline',
        label: 'Timeline',
        icon: Icons.timeline_outlined,
        selectedIcon: Icons.timeline,
        route: '/projects/${_selectedProject!.id}/timeline',
      ),
    ];
  }

  // Navigation items - use route for leaf items
  List<VooNavigationItem> get _navigationItems => [
    VooNavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      mobilePriority: true,
      route: '/dashboard',
    ),
    VooNavigationItem(
      id: 'teams',
      label: 'Teams',
      icon: Icons.language,
      route: '/teams',
    ),
    // Projects section - with embedded context switcher
    VooNavigationItem(
      id: 'projects-section',
      label: 'Projects',
      icon: Icons.folder_special_outlined,
      selectedIcon: Icons.folder_special,
      isExpanded: true,
      // Line color matches selected project
      sectionHeaderLineColor: _selectedProject?.color,
      // Embed project selector inside the section
      sectionHeaderWidget: VooContextSwitcher(
        config: VooContextSwitcherConfig(
          items: _projects,
          selectedItem: _selectedProject,
          onContextChanged: (project) {
            setState(() => _selectedProject = project);
          },
          showSearch: true,
          searchHint: 'Search projects...',
          placeholder: 'Select project',
          onCreateContext: () {
            // Handle create new project
          },
          createContextLabel: 'New Project',
        ),
      ),
      children: _projectNavigationItems.isNotEmpty
          ? _projectNavigationItems
          : [
              // Placeholder item when no project selected
              VooNavigationItem(
                id: 'select-project-hint',
                label: 'No project selected',
                icon: Icons.info_outline,
                route: '/projects',
                isEnabled: false,
              ),
            ],
    ),
    VooNavigationItem(
      id: 'employee-section',
      label: 'Employee',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      children: [
        VooNavigationItem(id: 'employee', label: 'Employee', icon: Icons.badge_outlined, mobilePriority: true, route: '/employee'),
        VooNavigationItem(id: 'attendance', label: 'Attendance', icon: Icons.access_time, mobilePriority: true, route: '/attendance'),
        VooNavigationItem(id: 'checklist', label: 'Checklist', icon: Icons.checklist, route: '/checklist'),
        VooNavigationItem(id: 'time-off', label: 'Time off', icon: Icons.event_busy_outlined, route: '/time-off'),
      ],
    ),
    VooNavigationItem(
      id: 'hire-section',
      label: 'Hire',
      icon: Icons.work_outline,
      selectedIcon: Icons.work,
      children: [
        VooNavigationItem(id: 'hiring', label: 'Hiring', icon: Icons.person_add_outlined, route: '/hiring'),
        VooNavigationItem(id: 'onboarding', label: 'Onboarding', icon: Icons.flight_takeoff, route: '/onboarding'),
        VooNavigationItem(id: 'hiring-handbook', label: 'Hiring handbook', icon: Icons.menu_book_outlined, route: '/hiring-handbook'),
      ],
    ),
    VooNavigationItem(
      id: 'finance-section',
      label: 'Finance',
      icon: Icons.attach_money,
      children: [
        VooNavigationItem(id: 'payroll', label: 'Payroll', icon: Icons.payments_outlined, route: '/payroll'),
        VooNavigationItem(id: 'expenses', label: 'Expenses', icon: Icons.receipt_long_outlined, route: '/expenses'),
        VooNavigationItem(id: 'incentives', label: 'Incentives', icon: Icons.card_giftcard_outlined, route: '/incentives'),
        VooNavigationItem(id: 'payment-info', label: 'Payment information', icon: Icons.credit_card_outlined, route: '/payment-info'),
      ],
    ),
  ];

  // Footer items
  List<VooNavigationItem> get _footerItems => [
    VooNavigationItem(id: 'settings', label: 'Settings', icon: Icons.settings_outlined, selectedIcon: Icons.settings, route: '/settings'),
    VooNavigationItem(id: 'integrations', label: 'Integrations', icon: Icons.extension_outlined, selectedIcon: Icons.extension, route: '/integrations'),
    VooNavigationItem(id: 'help', label: 'Help and support', icon: Icons.help_outline, selectedIcon: Icons.help, route: '/help'),
  ];

  void _onNavigationItemSelected(String itemId) {
    setState(() => _selectedId = itemId);
  }

  String _getPageTitle() {
    for (final item in _navigationItems) {
      if (item.id == _selectedId) return item.label;
      if (item.children != null) {
        for (final child in item.children!) {
          if (child.id == _selectedId) return child.label;
        }
      }
    }
    for (final item in _footerItems) {
      if (item.id == _selectedId) return item.label;
    }
    return 'Dashboard';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRISELINK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: _buildMainScaffold(context),
    );
  }

  Widget _buildMainScaffold(BuildContext context) {
    final theme = Theme.of(context);
    const scaffoldBgColor = Color(0xFFF9FAFB);

    final config = VooNavigationConfig(
      items: _navigationItems,
      footerItems: _footerItems,
      selectedId: _selectedId,
      onNavigationItemSelected: _onNavigationItemSelected,

      // Simple navigation theme
      navigationTheme: const VooNavigationTheme(borderRadius: 0),

      // Header configuration - simplified API for title and logo
      headerConfig: const VooHeaderConfig(
        title: 'HRISELINK',
        logoIcon: Icons.person_outline,
      ),

      // Layout
      drawerMargin: EdgeInsets.zero,
      navigationRailMargin: 0,
      contentAreaMargin: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
      contentAreaBorderRadius: BorderRadius.circular(12),
      navigationBackgroundColor: scaffoldBgColor,
      contentAreaBackgroundColor: Colors.white,

      // App bar
      appBarAlongsideRail: true,
      showAppBar: true,
      appBarTitleBuilder: (_) => Text(
        _getPageTitle(),
        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarActionsBuilder: (_) => [
        IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () {}, tooltip: 'Messages'),
        IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}, tooltip: 'Notifications'),
        const SizedBox(width: 12),
        OutlinedButton(onPressed: () {}, child: const Text('Export CSV')),
        const SizedBox(width: 8),
        FilledButton(onPressed: () {}, child: const Text('Add new')),
      ],

      // Sizing
      navigationDrawerWidth: 220,
      navigationRailWidth: 64,
      extendedNavigationRailWidth: 220,

      // Collapsible rail
      enableCollapsibleRail: true,

      // User profile - uses simplified config API
      showUserProfile: true,
      userProfileConfig: VooUserProfileConfig(
        userName: 'Wishbone',
        userEmail: '61 members',
        initials: 'WB',
        onTap: () {},
      ),

      // Search bar - uses built-in API (shortcut: Ctrl+K or ⌘K)
      searchBar: VooSearchBarConfig(
        hintText: 'Search...',
        enableKeyboardShortcut: true,
        keyboardShortcutHint: '⌘K',
      ),
      searchBarPosition: VooSearchBarPosition.header,

      // Context switcher disabled - we'll embed it in the Projects section instead
      // contextSwitcher: VooContextSwitcherConfig(...),

      // Mobile
      floatingBottomNav: true,

      // Animations
      enableAnimations: true,
      enableHapticFeedback: true,
    );

    return VooAdaptiveScaffold(
      config: config,
      backgroundColor: scaffoldBgColor,
      body: _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedId) {
      case 'employee':
        return const EmployeePage();
      case 'dashboard':
        return const DashboardPage();
      case 'project-overview':
      case 'project-tasks':
      case 'project-files':
      case 'project-team':
      case 'project-timeline':
        return ProjectPage(project: _selectedProject!, section: _selectedId);
      default:
        return PlaceholderPage(title: _getPageTitle());
    }
  }
}

/// Employee Page
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
      children: [
        _buildTabBar(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildStatsCards(context),
                const SizedBox(height: 24),
                _buildDataTable(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: 'Employee list'),
                Tab(text: 'Directory'),
                Tab(text: 'ORG Chart'),
              ],
            ),
          ),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.filter_list, size: 16), label: const Text('Filter')),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.swap_vert, size: 16), label: const Text('Sort')),
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
            _StatCard(value: '1,384', label: 'Total employee', change: '+47', color: const Color(0xFF6366F1), width: cardWidth),
            const SizedBox(width: 16),
            _StatCard(value: '839', label: 'Active employee', change: '+72', color: const Color(0xFF10B981), width: cardWidth),
            const SizedBox(width: 16),
            _StatCard(value: '531', label: 'Inactive employee', change: '-49', color: const Color(0xFFEF4444), width: cardWidth),
            const SizedBox(width: 16),
            _StatCard(value: '531', label: 'Onboarding', change: '+29', color: const Color(0xFFF59E0B), width: cardWidth),
          ],
        );
      },
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
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40, child: Checkbox(value: false, onChanged: null)),
                _HeaderCell('Name', flex: 3),
                _HeaderCell('ID', flex: 2),
                _HeaderCell('Job title', flex: 2),
                _HeaderCell('Department', flex: 2),
                _HeaderCell('Join date', flex: 2),
                _HeaderCell('Status', flex: 1),
                const SizedBox(width: 40),
              ],
            ),
          ),
          // Rows
          ...List.generate(_employees.length, (i) => _buildRow(_employees[i], i, theme)),
        ],
      ),
    );
  }

  Widget _buildRow(Employee e, int i, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: i.isEven ? Colors.white : const Color(0xFFF9FAFB),
      child: Row(
        children: [
          const SizedBox(width: 40, child: Checkbox(value: false, onChanged: null)),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(radius: 16, backgroundImage: NetworkImage(e.avatarUrl)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                      Text(e.email, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(e.employeeId, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500))),
          Expanded(flex: 2, child: Text(e.jobTitle)),
          Expanded(flex: 2, child: Text(e.department)),
          Expanded(flex: 2, child: Text(e.joinDate)),
          Expanded(flex: 1, child: _StatusBadge(status: e.status)),
          SizedBox(width: 40, child: IconButton(icon: const Icon(Icons.more_vert, size: 18), onPressed: () {})),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label, change;
  final Color color;
  final double width;
  const _StatCard({required this.value, required this.label, required this.change, required this.color, required this.width});

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.person, color: color, size: 26),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(change, style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final EmployeeStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, text) = switch (status) {
      EmployeeStatus.active => (Colors.green, 'Active'),
      EmployeeStatus.inactive => (Colors.red, 'Inactive'),
      EmployeeStatus.onboarding => (Colors.orange, 'Onboarding'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back!', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Here\'s what\'s happening with your team today.', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}

/// Project Page - demonstrates dynamic content based on selected context
class ProjectPage extends StatelessWidget {
  final VooContextItem project;
  final String section;

  const ProjectPage({super.key, required this.project, required this.section});

  String get _sectionTitle => switch (section) {
    'project-overview' => 'Overview',
    'project-tasks' => 'Tasks',
    'project-files' => 'Files',
    'project-team' => 'Team',
    'project-timeline' => 'Timeline',
    _ => 'Project',
  };

  IconData get _sectionIcon => switch (section) {
    'project-overview' => Icons.dashboard,
    'project-tasks' => Icons.check_circle,
    'project-files' => Icons.folder,
    'project-team' => Icons.people,
    'project-timeline' => Icons.timeline,
    _ => Icons.folder_special,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project header with color accent
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: project.color?.withValues(alpha: 0.15) ?? theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  project.icon ?? Icons.folder,
                  color: project.color ?? theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (project.subtitle != null)
                      Text(
                        project.subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                  ],
                ),
              ),
              // Color indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: project.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          // Section content
          Row(
            children: [
              Icon(_sectionIcon, color: project.color ?? theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                _sectionTitle,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Placeholder content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: (project.color ?? theme.colorScheme.primary).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (project.color ?? theme.colorScheme.primary).withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _sectionIcon,
                      size: 64,
                      color: (project.color ?? theme.colorScheme.primary).withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${project.name} - $_sectionTitle',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: project.color ?? theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Project content would appear here',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('This page is under construction', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

enum EmployeeStatus { active, inactive, onboarding }

class Employee {
  final String name, email, employeeId, jobTitle, department, joinDate, avatarUrl;
  final EmployeeStatus status;

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

  static List<Employee> get sampleData => const [
    Employee(name: 'Randy Rhiel Madsen', email: 'randyrhiel@email.com', employeeId: 'A01D05N93', jobTitle: 'UI Designer', department: 'Design Team', joinDate: '13 Aug 2022', status: EmployeeStatus.active, avatarUrl: 'https://i.pravatar.cc/150?img=1'),
    Employee(name: 'Maria Rosser', email: 'mariarosser@email.com', employeeId: 'A02D05N196', jobTitle: 'UX Researcher', department: 'Design Team', joinDate: '29 Jun 2021', status: EmployeeStatus.inactive, avatarUrl: 'https://i.pravatar.cc/150?img=5'),
    Employee(name: 'Cheyenne Bothman', email: 'bothmanvery@email.com', employeeId: 'A05DEV9B1', jobTitle: 'iOS Developer', department: 'Developer Team', joinDate: '20 Feb 2025', status: EmployeeStatus.onboarding, avatarUrl: 'https://i.pravatar.cc/150?img=3'),
    Employee(name: 'Alfredo Curtis', email: 'alfredocurtis@email.com', employeeId: 'A04DEV9312', jobTitle: 'Android Developer', department: 'Developer Team', joinDate: '14 May 2024', status: EmployeeStatus.active, avatarUrl: 'https://i.pravatar.cc/150?img=4'),
    Employee(name: 'Ryan Saris Lewis', email: 'ryansarislewis@email.com', employeeId: 'A03DEV9273', jobTitle: 'Back-End Developer', department: 'Developer Team', joinDate: '31 Jul 2024', status: EmployeeStatus.active, avatarUrl: 'https://i.pravatar.cc/150?img=7'),
  ];
}
