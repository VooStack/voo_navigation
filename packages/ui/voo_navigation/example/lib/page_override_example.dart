import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

/// Example demonstrating VooPage for page-level scaffold overrides
class PageOverrideExample extends StatefulWidget {
  const PageOverrideExample({super.key});

  @override
  State<PageOverrideExample> createState() => _PageOverrideExampleState();
}

class _PageOverrideExampleState extends State<PageOverrideExample> {
  String _selectedId = 'default';

  List<VooNavigationItem> get _navigationItems => [
        VooNavigationItem(
          id: 'default',
          label: 'Default',
          mobilePriority: true,
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          tooltip: 'Default scaffold behavior',
          onTap: () {},
        ),
        VooNavigationItem(
          id: 'custom_fab',
          label: 'Custom FAB',
          mobilePriority: true,
          icon: Icons.add_circle_outline,
          selectedIcon: Icons.add_circle,
          tooltip: 'Page with custom FAB position',
          onTap: () {},
        ),
        VooNavigationItem(
          id: 'custom_appbar',
          label: 'Custom AppBar',
          mobilePriority: true,
          icon: Icons.web_asset_outlined,
          selectedIcon: Icons.web_asset,
          tooltip: 'Page with custom app bar',
          onTap: () {},
        ),
        VooNavigationItem(
          id: 'fullscreen',
          label: 'Fullscreen',
          mobilePriority: true,
          icon: Icons.fullscreen_outlined,
          selectedIcon: Icons.fullscreen,
          tooltip: 'Fullscreen page without app bar',
          onTap: () {},
        ),
        VooNavigationItem(
          id: 'no_fab',
          label: 'No FAB',
          mobilePriority: true,
          icon: Icons.remove_circle_outline,
          selectedIcon: Icons.remove_circle,
          tooltip: 'Page without FAB',
          onTap: () {},
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final config = VooNavigationConfig(
      items: _navigationItems,
      selectedId: _selectedId,
      isAdaptive: true,
      enableAnimations: true,
      appBarAlongsideRail: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSnackBar('Default FAB pressed'),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      onNavigationItemSelected: (itemId) {
        setState(() => _selectedId = itemId);
      },
    );

    return VooAdaptiveScaffold(
      config: config,
      body: _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedId) {
      case 'custom_fab':
        return _buildCustomFabPage();
      case 'custom_appbar':
        return _buildCustomAppBarPage();
      case 'fullscreen':
        return _buildFullscreenPage();
      case 'no_fab':
        return _buildNoFabPage();
      default:
        return _buildDefaultPage();
    }
  }

  /// Default page - uses scaffold defaults
  Widget _buildDefaultPage() {
    return _PageContent(
      title: 'Default Page',
      description: 'This page uses all default scaffold settings.\n'
          'The FAB is in the default position (endFloat).',
      icon: Icons.home,
      color: Colors.blue,
    );
  }

  /// Page with custom FAB and custom position
  Widget _buildCustomFabPage() {
    return VooPage(
      config: VooPageConfig(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showSnackBar('Custom extended FAB pressed!'),
          icon: const Icon(Icons.create),
          label: const Text('Compose'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      child: const _PageContent(
        title: 'Custom FAB Page',
        description: 'This page has a custom extended FAB\n'
            'positioned at centerFloat instead of endFloat.',
        icon: Icons.add_circle,
        color: Colors.deepPurple,
      ),
    );
  }

  /// Page with custom app bar
  Widget _buildCustomAppBarPage() {
    return VooPage(
      config: VooPageConfig(
        appBar: AppBar(
          title: const Text('Custom App Bar'),
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSnackBar('Search pressed'),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showSnackBar('Filter pressed'),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _showSnackBar('Selected: $value'),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'sort', child: Text('Sort')),
                const PopupMenuItem(value: 'export', child: Text('Export')),
                const PopupMenuItem(value: 'settings', child: Text('Settings')),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showSnackBar('Teal FAB pressed'),
          backgroundColor: Colors.teal,
          child: const Icon(Icons.edit, color: Colors.white),
        ),
      ),
      child: const _PageContent(
        title: 'Custom App Bar Page',
        description: 'This page has a completely custom app bar\n'
            'with teal styling and extra actions.',
        icon: Icons.web_asset,
        color: Colors.teal,
      ),
    );
  }

  /// Fullscreen page without app bar
  Widget _buildFullscreenPage() {
    final theme = Theme.of(context);

    return VooPage.fullscreen(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo.shade900,
              Colors.purple.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.fullscreen,
                      size: 120,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Fullscreen Page',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This page has no app bar and extends\n'
                      'behind system UI for an immersive experience.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _selectedId = 'default'),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Default'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.indigo.shade900,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Custom positioned FAB
              Positioned(
                bottom: 32,
                right: 32,
                child: FloatingActionButton.large(
                  onPressed: () => _showSnackBar('Fullscreen FAB pressed'),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo.shade900,
                  child: const Icon(Icons.play_arrow),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Page with no FAB
  Widget _buildNoFabPage() {
    return VooPage(
      config: const VooPageConfig(
        showFloatingActionButton: false,
      ),
      child: const _PageContent(
        title: 'No FAB Page',
        description: 'This page explicitly hides the FAB\n'
            'using showFloatingActionButton: false.',
        icon: Icons.remove_circle,
        color: Colors.orange,
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

/// Reusable page content widget
class _PageContent extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _PageContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: color,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            _buildInfoCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'VooPage Usage',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCodeExample(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExample(BuildContext context) {
    final theme = Theme.of(context);

    final code = '''
VooPage(
  config: VooPageConfig(
    floatingActionButton: MyCustomFab(),
    floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
    showAppBar: false, // Hide app bar
    // ... more overrides
  ),
  child: MyPageContent(),
)''';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectableText(
        code,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
