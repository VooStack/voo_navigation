import 'package:flutter/material.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoO Navigation Core Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CoreComponentsExample(),
    );
  }
}

class CoreComponentsExample extends StatefulWidget {
  const CoreComponentsExample({super.key});

  @override
  State<CoreComponentsExample> createState() => _CoreComponentsExampleState();
}

class _CoreComponentsExampleState extends State<CoreComponentsExample> {
  // Context Switcher state
  late VooContextItem _selectedContext;
  final List<VooContextItem> _contexts = [
    const VooContextItem(
      id: 'project-1',
      name: 'Marketing Website',
      icon: Icons.web,
      color: Colors.blue,
      subtitle: '12 tasks',
    ),
    const VooContextItem(
      id: 'project-2',
      name: 'Mobile App',
      icon: Icons.phone_android,
      color: Colors.green,
      subtitle: '8 tasks',
    ),
    const VooContextItem(
      id: 'project-3',
      name: 'API Backend',
      icon: Icons.api,
      color: Colors.orange,
      subtitle: '5 tasks',
    ),
    const VooContextItem(
      id: 'project-4',
      name: 'Design System',
      icon: Icons.palette,
      color: Colors.purple,
      subtitle: '3 tasks',
    ),
  ];

  // Navigation items that change based on context
  List<VooNavigationItem> _navigationItems = [];

  @override
  void initState() {
    super.initState();
    _selectedContext = _contexts.first;
    _navigationItems = _getNavigationItemsForContext(_selectedContext);
  }

  List<VooNavigationItem> _getNavigationItemsForContext(VooContextItem context) {
    // Generate different navigation items based on the selected context
    return [
      VooNavigationItem(
        id: 'overview',
        label: 'Overview',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        route: '/projects/${context.id}/overview',
      ),
      VooNavigationItem(
        id: 'tasks',
        label: 'Tasks',
        icon: Icons.task_outlined,
        selectedIcon: Icons.task,
        route: '/projects/${context.id}/tasks',
        badgeCount: context.id == 'project-1' ? 5 : null,
      ),
      VooNavigationItem(
        id: 'files',
        label: 'Files',
        icon: Icons.folder_outlined,
        selectedIcon: Icons.folder,
        route: '/projects/${context.id}/files',
      ),
      VooNavigationItem(
        id: 'settings',
        label: 'Settings',
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        route: '/projects/${context.id}/settings',
      ),
    ];
  }

  void _onContextChanged(VooContextItem context) {
    setState(() {
      _selectedContext = context;
      _navigationItems = _getNavigationItemsForContext(context);
    });
  }

  void _onCreateContext() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new project tapped')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VoO Navigation Core'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Context Switcher
            _buildSectionHeader('Context Switcher', Icons.swap_horiz),
            const SizedBox(height: 16),
            Text(
              'The Context Switcher allows users to switch between contexts (projects, workspaces, environments) '
              'and dynamically changes the navigation items based on the selected context.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Context Switcher Demo
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Project',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  VooContextSwitcher(
                    config: VooContextSwitcherConfig(
                      items: _contexts,
                      selectedItem: _selectedContext,
                      onContextChanged: _onContextChanged,
                      onCreateContext: _onCreateContext,
                      createContextLabel: 'New Project',
                      sectionTitle: 'Projects',
                      showSearch: true,
                      searchHint: 'Search projects...',
                      placeholder: 'Select a project',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Dynamic Navigation Items
            _buildSectionHeader('Dynamic Navigation Items', Icons.navigation),
            const SizedBox(height: 16),
            Text(
              'Navigation items update automatically when the context changes:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _navigationItems.map((item) {
                  return ListTile(
                    leading: Icon(item.icon, color: colorScheme.primary),
                    title: Text(item.label),
                    subtitle: Text(item.route ?? ''),
                    trailing: item.badgeCount != null
                        ? VooBadge(count: item.badgeCount!)
                        : null,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 24),

            // Section: Atoms Showcase
            _buildSectionHeader('Atoms', Icons.widgets_outlined),
            const SizedBox(height: 16),
            Text(
              'Basic building blocks for navigation components:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Badges
            _buildSubsectionHeader('Badges'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildAtomCard('VooBadge', const VooBadge(count: 5)),
                _buildAtomCard('VooBadge.dot', VooBadge.dot()),
                _buildAtomCard('VooBadge.text', VooBadge.text(text: 'NEW')),
              ],
            ),

            const SizedBox(height: 32),

            // Avatars
            _buildSubsectionHeader('Avatars'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildAtomCard(
                  'Initials',
                  const VooAvatar(initials: 'JD', size: 40),
                ),
                _buildAtomCard(
                  'Green',
                  const VooAvatar(
                    initials: 'AB',
                    size: 40,
                    backgroundColor: Colors.green,
                  ),
                ),
                _buildAtomCard(
                  'Purple',
                  const VooAvatar(
                    initials: 'XY',
                    size: 40,
                    backgroundColor: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Icons
            _buildSubsectionHeader('Icons'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildAtomCard(
                  'Selected',
                  const VooNavigationIcon(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    isSelected: true,
                  ),
                ),
                _buildAtomCard(
                  'Unselected',
                  const VooNavigationIcon(
                    icon: Icons.settings_outlined,
                    selectedIcon: Icons.settings,
                    isSelected: false,
                  ),
                ),
                _buildAtomCard(
                  'Icon + Badge',
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications, size: 24),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: VooBadge.count(count: 7),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Indicators
            _buildSubsectionHeader('Selection Indicators'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildAtomCard(
                  'VooEdgeIndicator',
                  VooEdgeIndicator(
                    isActive: true,
                    color: colorScheme.primary,
                    height: 32,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 24),

            // Section: Molecules Showcase
            _buildSectionHeader('Molecules', Icons.view_module_outlined),
            const SizedBox(height: 16),
            Text(
              'Composite components built from atoms:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Search Bar
            _buildSubsectionHeader('Search Bar'),
            const SizedBox(height: 12),
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: VooSearchBar(
                hintText: 'Search...',
                onSearch: (query) {
                  debugPrint('Search: $query');
                },
                enableKeyboardShortcut: true,
                keyboardShortcutHint: 'Ctrl+K',
              ),
            ),

            const SizedBox(height: 32),

            // Breadcrumbs
            _buildSubsectionHeader('Breadcrumbs'),
            const SizedBox(height: 12),
            VooBreadcrumbs(
              items: const [
                VooBreadcrumbItem(id: 'home', label: 'Home', route: '/'),
                VooBreadcrumbItem(id: 'projects', label: 'Projects', route: '/projects'),
                VooBreadcrumbItem(id: 'marketing', label: 'Marketing Website'),
              ],
              onItemTap: (item) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate to: ${item.route ?? item.label}')),
                );
              },
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSubsectionHeader(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildAtomCard(String label, Widget child) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
