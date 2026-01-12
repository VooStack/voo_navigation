import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  runApp(const SimplifiedApp());
}

class SimplifiedApp extends StatelessWidget {
  const SimplifiedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simplified Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A34A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SimplifiedHome(),
    );
  }
}

class SimplifiedHome extends StatefulWidget {
  const SimplifiedHome({super.key});

  @override
  State<SimplifiedHome> createState() => _SimplifiedHomeState();
}

class _SimplifiedHomeState extends State<SimplifiedHome> {
  String _selectedId = 'dashboard';

  // Navigation items with expandable sections
  final List<VooNavigationItem> _items = [
    const VooNavigationItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: '/dashboard',
    ),
    VooNavigationItem.section(
      id: 'teams',
      label: 'Teams',
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
      id: 'hire',
      label: 'Hire',
      children: const [
        VooNavigationItem(
          id: 'hiring',
          label: 'Hiring',
          icon: Icons.work_outline,
          route: '/hiring',
        ),
        VooNavigationItem(
          id: 'onboarding',
          label: 'Onboarding',
          icon: Icons.flight_land_outlined,
          route: '/onboarding',
        ),
        VooNavigationItem(
          id: 'handbook',
          label: 'Hiring handbook',
          icon: Icons.menu_book_outlined,
          route: '/handbook',
        ),
      ],
    ),
    VooNavigationItem.section(
      id: 'finance',
      label: 'Finance',
      children: const [
        VooNavigationItem(
          id: 'payroll',
          label: 'Payroll',
          icon: Icons.payments_outlined,
          route: '/payroll',
        ),
        VooNavigationItem(
          id: 'expenses',
          label: 'Expenses',
          icon: Icons.receipt_long_outlined,
          route: '/expenses',
        ),
        VooNavigationItem(
          id: 'incentives',
          label: 'Incentives',
          icon: Icons.card_giftcard_outlined,
          route: '/incentives',
        ),
        VooNavigationItem(
          id: 'payment_info',
          label: 'Payment information',
          icon: Icons.credit_card_outlined,
          route: '/payment-info',
        ),
      ],
    ),
  ];

  // Footer items
  final List<VooNavigationItem> _footerItems = [
    const VooNavigationItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
      route: '/settings',
    ),
    const VooNavigationItem(
      id: 'integrations',
      label: 'Integrations',
      icon: Icons.extension_outlined,
      route: '/integrations',
    ),
    const VooNavigationItem(
      id: 'help',
      label: 'Help and support',
      icon: Icons.help_outline,
      route: '/help',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Minimal configuration - all styling is handled by defaults
    final config = VooNavigationConfig(
      items: _items,
      selectedId: _selectedId,
      // Header with logo and title
      headerConfig: const VooHeaderConfig(
        title: 'HRISELINK',
        logoIcon: Icons.home_work_outlined,
      ),
      // Search bar
      searchBar: const VooSearchBarConfig(
        hintText: 'Search...',
      ),
      // Footer items
      footerItems: _footerItems,
      // User profile (enabled by default, just providing config)
      userProfileConfig: const VooUserProfileConfig(
        userName: 'Wishbone',
        userEmail: '61 members',
        status: VooUserStatus.online,
      ),
      // Navigation callback
      onNavigationItemSelected: (itemId) {
        setState(() => _selectedId = itemId);
      },
    );

    return VooAdaptiveScaffold(
      config: config,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Body content - the scaffold handles background colors
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Selected: $_selectedId',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),
        const Text('This example shows the DEFAULT look of VooAdaptiveScaffold.'),
        const SizedBox(height: 16),
        const Text('All these features work out of the box:'),
        const SizedBox(height: 8),
        const Text('- White drawer with no border'),
        const Text('- Light gray content area with margin'),
        const Text('- Rounded corners on content area'),
        const Text('- App bar inside content area (alongside rail)'),
        const Text('- Collapsible drawer (click the toggle icon)'),
        const Text('- Header with logo and title'),
        const Text('- Search bar with keyboard shortcut'),
        const Text('- Expandable navigation sections'),
        const Text('- Footer items (Settings, Integrations, Help)'),
        const Text('- User profile at bottom'),
      ],
    );
  }
}
