import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const VooNavigationShowcaseApp());
}

class VooNavigationShowcaseApp extends StatefulWidget {
  const VooNavigationShowcaseApp({super.key});

  @override
  State<VooNavigationShowcaseApp> createState() => _VooNavigationShowcaseAppState();
}

class _VooNavigationShowcaseAppState extends State<VooNavigationShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  VooNavigationPreset _currentPreset = VooNavigationPreset.material3Enhanced;
  bool _useInsetLayout = true;
  Color _seedColor = const Color(0xFF6366F1);

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = _createRouter();
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/dashboard',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainScaffold(
              navigationShell: navigationShell,
              currentPreset: _currentPreset,
              useInsetLayout: _useInsetLayout,
              seedColor: _seedColor,
              onPresetChanged: (preset) => setState(() => _currentPreset = preset),
              onInsetLayoutChanged: (value) => setState(() => _useInsetLayout = value),
              onSeedColorChanged: (color) => setState(() => _seedColor = color),
              onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
              themeMode: _themeMode,
            );
          },
          branches: [
            // Dashboard Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/dashboard',
                  builder: (context, state) => const DashboardPage(),
                  routes: [
                    GoRoute(
                      path: 'analytics',
                      builder: (context, state) => const AnalyticsDetailPage(),
                    ),
                  ],
                ),
              ],
            ),
            // Projects Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/projects',
                  builder: (context, state) => const ProjectsPage(),
                  routes: [
                    GoRoute(
                      path: ':projectId',
                      builder: (context, state) => ProjectDetailPage(
                        projectId: state.pathParameters['projectId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Team Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/team',
                  builder: (context, state) => const TeamPage(),
                ),
              ],
            ),
            // Messages Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/messages',
                  builder: (context, state) => const MessagesPage(),
                ),
              ],
            ),
            // Settings Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  builder: (context, state) => SettingsPage(
                    currentPreset: _currentPreset,
                    useInsetLayout: _useInsetLayout,
                    seedColor: _seedColor,
                    themeMode: _themeMode,
                    onPresetChanged: (preset) => setState(() => _currentPreset = preset),
                    onInsetLayoutChanged: (value) => setState(() => _useInsetLayout = value),
                    onSeedColorChanged: (color) => setState(() => _seedColor = color),
                    onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Voo Navigation Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

// Main Scaffold with Navigation
class MainScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final VooNavigationPreset currentPreset;
  final bool useInsetLayout;
  final Color seedColor;
  final ThemeMode themeMode;
  final ValueChanged<VooNavigationPreset> onPresetChanged;
  final ValueChanged<bool> onInsetLayoutChanged;
  final ValueChanged<Color> onSeedColorChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const MainScaffold({
    super.key,
    required this.navigationShell,
    required this.currentPreset,
    required this.useInsetLayout,
    required this.seedColor,
    required this.themeMode,
    required this.onPresetChanged,
    required this.onInsetLayoutChanged,
    required this.onSeedColorChanged,
    required this.onThemeModeChanged,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool _isCollapsed = false;

  List<VooNavigationItem> get _navigationItems => [
    VooNavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: '/dashboard',
      mobilePriority: true,
    ),
    VooNavigationItem(
      id: 'projects',
      label: 'Projects',
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder,
      route: '/projects',
      badgeCount: 3,
      mobilePriority: true,
    ),
    VooNavigationItem(
      id: 'team',
      label: 'Team',
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      route: '/team',
      mobilePriority: true,
    ),
    VooNavigationItem(
      id: 'messages',
      label: 'Messages',
      icon: Icons.chat_bubble_outline,
      selectedIcon: Icons.chat_bubble,
      route: '/messages',
      badgeCount: 12,
      mobilePriority: true,
    ),
    VooNavigationItem.divider(id: 'divider1'),
    VooNavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      route: '/settings',
      mobilePriority: true,
    ),
  ];

  String get _selectedId {
    final index = widget.navigationShell.currentIndex;
    final items = _navigationItems.where((i) => !i.isDivider).toList();
    if (index < items.length) {
      return items[index].id;
    }
    return 'dashboard';
  }

  void _onNavigationItemSelected(String itemId) {
    final items = _navigationItems.where((i) => !i.isDivider).toList();
    final index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
    }
  }

  VooNavigationTheme _getThemeForPreset() {
    switch (widget.currentPreset) {
      case VooNavigationPreset.glassmorphism:
        return VooNavigationTheme.glassmorphism();
      case VooNavigationPreset.liquidGlass:
        return VooNavigationTheme.liquidGlass();
      case VooNavigationPreset.blurry:
        return VooNavigationTheme.blurry();
      case VooNavigationPreset.neomorphism:
        return VooNavigationTheme.neomorphism();
      case VooNavigationPreset.material3Enhanced:
        return VooNavigationTheme.material3Enhanced();
      case VooNavigationPreset.minimalModern:
        return VooNavigationTheme.minimalModern();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final navTheme = _getThemeForPreset();

    final config = VooNavigationConfig(
      items: _navigationItems,
      selectedId: _selectedId,
      onNavigationItemSelected: _onNavigationItemSelected,
      navigationTheme: navTheme,

      // Inset layout settings
      drawerMargin: widget.useInsetLayout ? EdgeInsets.zero : null,
      contentAreaMargin: widget.useInsetLayout
          ? const EdgeInsets.only(top: 12, bottom: 12, right: 12, left: 12)
          : null,
      contentAreaBorderRadius: widget.useInsetLayout
          ? BorderRadius.circular(24)
          : null,

      // Navigation settings
      navigationBackgroundColor: isDark
          ? const Color(0xFF1A1A2E)
          : theme.colorScheme.surfaceContainerLow,
      appBarAlongsideRail: true,
      showAppBar: false,
      navigationDrawerWidth: 260,
      navigationRailWidth: 80,
      extendedNavigationRailWidth: 260,

      // Collapsible rail
      enableCollapsibleRail: true,
      onCollapseChanged: (collapsed) => setState(() => _isCollapsed = collapsed),

      // User profile
      showUserProfile: true,
      userProfileWidget: VooUserProfileFooter(
        userName: 'Sarah Chen',
        userEmail: 'sarah@acme.com',
        avatarUrl: null,
        status: VooUserStatus.online,
        compact: _isCollapsed,
        onTap: () => _showUserMenu(context),
        menuItems: [
          VooProfileMenuItem(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: () {},
          ),
          VooProfileMenuItem(
            icon: Icons.logout,
            label: 'Sign Out',
            onTap: () {},
          ),
        ],
      ),

      // Custom header
      drawerHeader: _buildDrawerHeader(context),

      // Bottom navigation
      floatingBottomNav: true,
      floatingBottomNavMargin: 16,
      floatingBottomNavBottomMargin: 24,

      // Animations
      enableAnimations: true,
      animationDuration: const Duration(milliseconds: 300),
      enableHapticFeedback: true,
    );

    // Get background color based on theme preset
    Color scaffoldBg;
    if (widget.useInsetLayout) {
      scaffoldBg = isDark ? const Color(0xFF1A1A2E) : const Color(0xFF1E1E2D);
    } else {
      scaffoldBg = theme.colorScheme.surface;
    }

    return VooAdaptiveScaffold(
      config: config,
      backgroundColor: scaffoldBg,
      body: widget.navigationShell,
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.rocket_launch,
              color: Colors.white,
              size: 22,
            ),
          ),
          if (!_isCollapsed) ...[
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VooStack',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Navigation Demo',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showUserMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Account Settings'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// Dashboard Page
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildStatsRow(context),
                  const SizedBox(height: 24),
                  _buildRecentActivity(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome back, Sarah!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('New Project'),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final crossAxisCount = isWide ? 4 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isWide ? 1.5 : 1.3,
          children: [
            _buildStatCard(context, 'Total Projects', '24', Icons.folder, '+12%', true),
            _buildStatCard(context, 'Active Tasks', '156', Icons.task_alt, '+8%', true),
            _buildStatCard(context, 'Team Members', '12', Icons.people, '+2', true),
            _buildStatCard(context, 'Completed', '89%', Icons.check_circle, '+5%', true),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, String change, bool positive) {
    final theme = Theme.of(context);

    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: theme.colorScheme.primary, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (positive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: positive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
          Text(
            'Recent Activity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) => _buildActivityItem(context, index)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final activities = [
      ('New project created', 'Marketing Campaign', Icons.add_circle, Colors.green),
      ('Task completed', 'Design review', Icons.check_circle, Colors.blue),
      ('Comment added', 'Landing page mockup', Icons.comment, Colors.orange),
      ('File uploaded', 'Final presentation.pdf', Icons.upload_file, Colors.purple),
      ('Team member joined', 'Alex Thompson', Icons.person_add, Colors.teal),
    ];

    final (title, subtitle, icon, color) = activities[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${index + 1}h ago',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// Analytics Detail Page
class AnalyticsDetailPage extends StatelessWidget {
  const AnalyticsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Details')),
      body: Center(
        child: Text('Analytics Detail View', style: theme.textTheme.headlineSmall),
      ),
    );
  }
}

// Projects Page
class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Projects',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('New Project'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 180,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildProjectCard(context, index),
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final projects = [
      ('Marketing Website', 'In Progress', 0.65, Colors.blue),
      ('Mobile App v2', 'Review', 0.90, Colors.green),
      ('API Integration', 'In Progress', 0.45, Colors.orange),
      ('Dashboard Redesign', 'Planning', 0.15, Colors.purple),
      ('E-commerce Platform', 'In Progress', 0.78, Colors.teal),
      ('Analytics Module', 'On Hold', 0.30, Colors.grey),
    ];

    final (name, status, progress, color) = projects[index];

    return InkWell(
      onTap: () => context.go('/projects/project-$index'),
      borderRadius: BorderRadius.circular(16),
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
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.folder, color: color, size: 20),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              name,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation(color),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toInt()}% complete',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Project Detail Page
class ProjectDetailPage extends StatelessWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Project: $projectId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/projects'),
        ),
      ),
      body: Center(
        child: Text('Project Detail: $projectId', style: theme.textTheme.headlineSmall),
      ),
    );
  }
}

// Team Page
class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 120,
              ),
              itemCount: 8,
              itemBuilder: (context, index) => _buildTeamMemberCard(context, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final members = [
      ('Sarah Chen', 'Product Manager', Colors.purple),
      ('Alex Thompson', 'Developer', Colors.blue),
      ('Maria Garcia', 'Designer', Colors.pink),
      ('James Wilson', 'Developer', Colors.green),
      ('Emily Brown', 'QA Engineer', Colors.orange),
      ('Michael Lee', 'DevOps', Colors.teal),
      ('Lisa Anderson', 'Developer', Colors.indigo),
      ('David Martinez', 'Designer', Colors.red),
    ];

    final (name, role, color) = members[index];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Text(
              name[0],
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  role,
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
}

// Messages Page
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Messages',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Compose'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: ListView.separated(
                itemCount: 10,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                itemBuilder: (context, index) => _buildMessageItem(context, index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final messages = [
      ('Alex Thompson', 'Hey, can you review the PR?', '2m ago', true),
      ('Maria Garcia', 'Design files are ready', '15m ago', true),
      ('James Wilson', 'Meeting at 3pm', '1h ago', false),
      ('Emily Brown', 'Tests are passing now', '2h ago', false),
      ('Michael Lee', 'Deployed to staging', '3h ago', false),
    ];

    final (name, message, time, unread) = messages[index % 5];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        child: Text(
          name[0],
          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
        ),
      ),
      title: Row(
        children: [
          Text(
            name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: unread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (unread) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        time,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

// Settings Page
class SettingsPage extends StatelessWidget {
  final VooNavigationPreset currentPreset;
  final bool useInsetLayout;
  final Color seedColor;
  final ThemeMode themeMode;
  final ValueChanged<VooNavigationPreset> onPresetChanged;
  final ValueChanged<bool> onInsetLayoutChanged;
  final ValueChanged<Color> onSeedColorChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const SettingsPage({
    super.key,
    required this.currentPreset,
    required this.useInsetLayout,
    required this.seedColor,
    required this.themeMode,
    required this.onPresetChanged,
    required this.onInsetLayoutChanged,
    required this.onSeedColorChanged,
    required this.onThemeModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Customize the navigation appearance',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Theme Mode Section
            _buildSection(
              context,
              'Theme Mode',
              'Choose between light and dark mode',
              [
                _buildOptionTile(
                  context,
                  'Light',
                  Icons.light_mode,
                  themeMode == ThemeMode.light,
                  () => onThemeModeChanged(ThemeMode.light),
                ),
                _buildOptionTile(
                  context,
                  'Dark',
                  Icons.dark_mode,
                  themeMode == ThemeMode.dark,
                  () => onThemeModeChanged(ThemeMode.dark),
                ),
                _buildOptionTile(
                  context,
                  'System',
                  Icons.settings_suggest,
                  themeMode == ThemeMode.system,
                  () => onThemeModeChanged(ThemeMode.system),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Layout Section
            _buildSection(
              context,
              'Layout Style',
              'Choose between inset or edge-to-edge layout',
              [
                _buildOptionTile(
                  context,
                  'Inset Content',
                  Icons.crop_square,
                  useInsetLayout,
                  () => onInsetLayoutChanged(true),
                ),
                _buildOptionTile(
                  context,
                  'Edge to Edge',
                  Icons.fullscreen,
                  !useInsetLayout,
                  () => onInsetLayoutChanged(false),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Theme Preset Section
            _buildSection(
              context,
              'Navigation Theme',
              'Select a visual style for the navigation',
              VooNavigationPreset.values.map((preset) {
                final name = preset.name.replaceAllMapped(
                  RegExp(r'([A-Z])'),
                  (match) => ' ${match.group(1)}',
                ).trim();
                final capitalizedName = name[0].toUpperCase() + name.substring(1);

                return _buildOptionTile(
                  context,
                  capitalizedName,
                  _getPresetIcon(preset),
                  currentPreset == preset,
                  () => onPresetChanged(preset),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Accent Color Section
            _buildSection(
              context,
              'Accent Color',
              'Choose a primary color for the app',
              [
                _buildColorRow(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String subtitle, List<Widget> children) {
    final theme = Theme.of(context);

    return Container(
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
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, String label, IconData icon, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorRow(BuildContext context) {
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Emerald
      const Color(0xFFF59E0B), // Amber
      const Color(0xFFEF4444), // Red
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFFEC4899), // Pink
      const Color(0xFF06B6D4), // Cyan
    ];

    return Row(
      children: colors.map((color) {
        final isSelected = color == seedColor;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => onSeedColorChanged(color),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 3,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 2)]
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getPresetIcon(VooNavigationPreset preset) {
    switch (preset) {
      case VooNavigationPreset.glassmorphism:
        return Icons.blur_on;
      case VooNavigationPreset.liquidGlass:
        return Icons.water_drop;
      case VooNavigationPreset.blurry:
        return Icons.blur_circular;
      case VooNavigationPreset.neomorphism:
        return Icons.layers;
      case VooNavigationPreset.material3Enhanced:
        return Icons.auto_awesome;
      case VooNavigationPreset.minimalModern:
        return Icons.remove;
    }
  }
}
