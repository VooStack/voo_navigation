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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
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

  final List<VooNavigationDestination> _items = [
    const VooNavigationDestination(
      id: 'home',
      label: 'Home',
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      route: '/home',
      mobilePriority: true,
    ),
    const VooNavigationDestination(
      id: 'search',
      label: 'Search',
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      route: '/search',
      mobilePriority: true,
    ),
    const VooNavigationDestination(
      id: 'notifications',
      label: 'Alerts',
      icon: Icon(Icons.notifications_outlined),
      selectedIcon: Icon(Icons.notifications),
      route: '/notifications',
      mobilePriority: true,
    ),
    const VooNavigationDestination(
      id: 'profile',
      label: 'Profile',
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      route: '/profile',
      mobilePriority: true,
    ),
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

  // Action item for the expandable nav
  VooActionNavigationItem get _actionItem => VooActionNavigationItem(
        id: 'quick-add',
        icon: const Icon(Icons.add, color: Colors.white),
        activeIcon: const Icon(Icons.close, color: Colors.white),
        backgroundColor: const Color(0xFF10B981),
        tooltip: 'Quick Actions',
        modalBuilder: (context, close) => _QuickActionsModal(
          onClose: close,
          onAction: (action) {
            close();
            _showSnackBar(context, '$action tapped');
          },
        ),
        modalMaxHeight: 280,
      );

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Expandable Bottom Navigation'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconTheme(
                data: const IconThemeData(
                  size: 40,
                  color: Color(0xFF10B981),
                ),
                child: _getIconForId(_selectedId),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getLabelForId(_selectedId),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
              'Tap the + button to see the action modal',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 100), // Bottom padding for nav bar
          ],
        ),
      ),
      bottomNavigationBar: VooNavigationBar(
        config: _config,
        selectedId: _selectedId,
        onNavigationItemSelected: _onItemSelected,
        actionItem: _actionItem,
        selectedColor: const Color(0xFF10B981),
        enableFeedback: true,
      ),
    );
  }

  VooNavigationDestination? _findItemById(String id) {
    for (final item in _items) {
      if (item.id == id) return item;
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

/// A beautifully styled quick actions modal
class _QuickActionsModal extends StatelessWidget {
  final VoidCallback onClose;
  final void Function(String action) onAction;

  const _QuickActionsModal({
    required this.onClose,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white54,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickActionButton(
                icon: Icons.note_add_rounded,
                label: 'Note',
                color: const Color(0xFF6366F1),
                onTap: () => onAction('New Note'),
              ),
              _QuickActionButton(
                icon: Icons.task_alt_rounded,
                label: 'Task',
                color: const Color(0xFF10B981),
                onTap: () => onAction('New Task'),
              ),
              _QuickActionButton(
                icon: Icons.photo_camera_rounded,
                label: 'Photo',
                color: const Color(0xFFF59E0B),
                onTap: () => onAction('Take Photo'),
              ),
              _QuickActionButton(
                icon: Icons.mic_rounded,
                label: 'Voice',
                color: const Color(0xFFEF4444),
                onTap: () => onAction('Voice Note'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual quick action button with icon and label
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
