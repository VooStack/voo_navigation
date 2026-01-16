import 'package:flutter/material.dart';
import 'package:voo_navigation_bar/voo_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoO Navigation Bar Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BottomNavigationExample(),
    );
  }
}

class BottomNavigationExample extends StatefulWidget {
  const BottomNavigationExample({super.key});

  @override
  State<BottomNavigationExample> createState() => _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  String _selectedId = 'home';
  int _selectedStyleIndex = 0;

  final List<VooNavigationItem> _items = const [
    VooNavigationItem(
      id: 'home',
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      route: '/home',
      mobilePriority: true,
    ),
    VooNavigationItem(
      id: 'search',
      label: 'Search',
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      route: '/search',
      mobilePriority: true,
    ),
    VooNavigationItem(
      id: 'notifications',
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
      route: '/notifications',
      badgeCount: 5,
      mobilePriority: true,
    ),
    VooNavigationItem(
      id: 'profile',
      label: 'Profile',
      icon: Icons.person_outlined,
      selectedIcon: Icons.person,
      route: '/profile',
      mobilePriority: true,
    ),
  ];

  final List<String> _styleNames = [
    'Adaptive',
    'Floating',
  ];

  void _onItemSelected(String itemId) {
    setState(() {
      _selectedId = itemId;
    });
  }

  VooNavigationConfig get _config => VooNavigationConfig(
        items: _items,
        selectedId: _selectedId,
        onNavigationItemSelected: _onItemSelected,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VoO Navigation Bar'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Style Selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bottom Navigation Styles',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_styleNames.length, (index) {
                      final isSelected = _selectedStyleIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_styleNames[index]),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedStyleIndex = index;
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Main Content
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
                  const SizedBox(height: 24),
                  Text(
                    'Style: ${_styleNames[_selectedStyleIndex]}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    switch (_selectedStyleIndex) {
      case 0:
        return VooAdaptiveBottomNavigation(
          config: _config,
          selectedId: _selectedId,
          onNavigationItemSelected: _onItemSelected,
        );
      case 1:
        return VooFloatingBottomNavigation(
          config: _config,
          selectedId: _selectedId,
          onNavigationItemSelected: _onItemSelected,
        );
      default:
        return VooAdaptiveBottomNavigation(
          config: _config,
          selectedId: _selectedId,
          onNavigationItemSelected: _onItemSelected,
        );
    }
  }

  VooNavigationItem? _findItemById(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
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
