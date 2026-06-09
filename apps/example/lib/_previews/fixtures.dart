import 'package:flutter/material.dart';
import 'package:voo_navigation/voo_navigation.dart';

/// Shared test data for widget previews and the demo app.
///
/// Everything is static and const-friendly so it can be referenced from
/// `@Preview()`-annotated functions without per-call rebuilds.
class Fixtures {
  Fixtures._();

  // ---------------------------------------------------------------------------
  // Navigation destinations
  // ---------------------------------------------------------------------------

  static const dashboard = VooNavigationDestination(
    id: 'dashboard',
    label: 'Dashboard',
    icon: Icon(Icons.dashboard_outlined),
    selectedIcon: Icon(Icons.dashboard),
    mobilePriority: true,
    route: '/dashboard',
  );

  static const notifications = VooNavigationDestination(
    id: 'notifications',
    label: 'Notifications',
    icon: Icon(Icons.notifications_outlined),
    selectedIcon: Icon(Icons.notifications),
    mobilePriority: true,
    badgeCount: 3,
    route: '/notifications',
  );

  static const messages = VooNavigationDestination(
    id: 'messages',
    label: 'Messages',
    icon: Icon(Icons.chat_bubble_outline),
    selectedIcon: Icon(Icons.chat_bubble),
    badgeCount: 12,
    route: '/messages',
  );

  static const settings = VooNavigationDestination(
    id: 'settings',
    label: 'Settings',
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings),
    route: '/settings',
  );

  /// Minimal flat list — five mobile-friendly items, no sections.
  static List<VooNavigationDestination> get simpleItems => const [
        dashboard,
        VooNavigationDestination(
          id: 'projects',
          label: 'Projects',
          icon: Icon(Icons.folder_outlined),
          selectedIcon: Icon(Icons.folder),
          mobilePriority: true,
          route: '/projects',
        ),
        messages,
        notifications,
        settings,
      ];

  /// Rich list with expandable sections — matches the existing
  /// `packages/ui/voo_navigation/example` demo so previews look familiar.
  static List<VooNavigationDestination> get sectionedItems => [
        dashboard,
        VooNavigationDestination.section(
          label: 'Teams',
          id: 'teams',
          isExpanded: false,
          children: const [
            VooNavigationDestination(
              id: 'team_overview',
              label: 'Overview',
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              route: '/teams/overview',
            ),
            VooNavigationDestination(
              id: 'team_members',
              label: 'Members',
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              route: '/teams/members',
            ),
          ],
        ),
        VooNavigationDestination.section(
          label: 'Employee',
          id: 'employee',
          isExpanded: true,
          children: const [
            VooNavigationDestination(
              id: 'attendance',
              label: 'Attendance',
              icon: Icon(Icons.access_time_outlined),
              selectedIcon: Icon(Icons.access_time),
              route: '/employee/attendance',
            ),
            VooNavigationDestination(
              id: 'checklist',
              label: 'Checklist',
              icon: Icon(Icons.checklist_outlined),
              selectedIcon: Icon(Icons.checklist),
              route: '/employee/checklist',
            ),
            VooNavigationDestination(
              id: 'time_off',
              label: 'Time off',
              icon: Icon(Icons.beach_access_outlined),
              selectedIcon: Icon(Icons.beach_access),
              route: '/employee/time-off',
            ),
          ],
        ),
        notifications,
      ];

  // ---------------------------------------------------------------------------
  // Organizations & users
  // ---------------------------------------------------------------------------

  static const acme = VooOrganization(
    id: 'acme',
    name: 'ACME Corp',
    subtitle: '12 members',
    avatarColor: Colors.blue,
  );

  static const startup = VooOrganization(
    id: 'startup',
    name: 'Startup Inc',
    subtitle: '5 members',
    avatarColor: Colors.green,
  );

  static const enterprise = VooOrganization(
    id: 'enterprise',
    name: 'Enterprise Ltd',
    subtitle: '50 members',
    avatarColor: Colors.purple,
  );

  static const oneOrganization = <VooOrganization>[acme];

  static const manyOrganizations = <VooOrganization>[
    acme,
    startup,
    enterprise,
    VooOrganization(
      id: 'consultancy',
      name: 'Consultancy Co',
      subtitle: '8 members',
      avatarColor: Colors.orange,
    ),
    VooOrganization(
      id: 'studio',
      name: 'Design Studio',
      subtitle: '3 members',
      avatarColor: Colors.pink,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Multi-switcher config
  // ---------------------------------------------------------------------------

  /// Demonstrates the new `VooMultiSwitcherConfig.fromUser(...)` factory —
  /// 7 individual user fields collapse to one [VooMultiSwitcherUser] struct.
  static VooMultiSwitcherConfig multiSwitcher({
    List<VooOrganization> organizations = manyOrganizations,
    VooOrganization? selected,
    VooUserStatus status = VooUserStatus.online,
  }) {
    return VooMultiSwitcherConfig.fromUser(
      user: VooMultiSwitcherUser(
        id: 'john',
        name: 'John Doe',
        email: 'john@example.com',
        status: status,
      ),
      organizations: organizations,
      selectedOrganization: selected ?? organizations.first,
      createOrganizationLabel: 'New Organization',
      showSearch: true,
      organizationSectionTitle: 'Workspaces',
      userSectionTitle: 'Account',
    );
  }

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  /// Note: timestamps use fixed past offsets so previews are deterministic.
  static List<VooNotificationItem> notifications3() => [
        VooNotificationItem(
          id: 'n1',
          title: 'New comment on "Q3 roadmap"',
          subtitle: 'Sarah mentioned you',
          icon: Icons.comment_outlined,
          iconColor: Colors.blue,
          timestamp: DateTime(2026, 6, 9, 9, 30),
        ),
        VooNotificationItem(
          id: 'n2',
          title: 'Build #1453 passed',
          subtitle: 'main · 4m 12s',
          icon: Icons.check_circle_outline,
          iconColor: Colors.green,
          isRead: true,
          timestamp: DateTime(2026, 6, 9, 8, 15),
        ),
        VooNotificationItem(
          id: 'n3',
          title: 'Server downtime alert',
          subtitle: 'api-prod-2 is unreachable',
          icon: Icons.error_outline,
          iconColor: Colors.red,
          isUrgent: true,
          timestamp: DateTime(2026, 6, 9, 7, 0),
        ),
      ];

  // ---------------------------------------------------------------------------
  // Quick actions
  // ---------------------------------------------------------------------------

  static List<VooQuickAction> quickActions() => const [
        VooQuickAction(
          id: 'new_doc',
          label: 'New document',
          icon: Icons.description_outlined,
          shortcut: '⌘N',
        ),
        VooQuickAction(
          id: 'new_task',
          label: 'New task',
          icon: Icons.task_alt_outlined,
          shortcut: '⌘T',
        ),
        VooQuickAction(
          id: 'invite',
          label: 'Invite teammate',
          icon: Icons.person_add_outlined,
        ),
        VooQuickAction(
          id: 'archive',
          label: 'Archive project',
          icon: Icons.archive_outlined,
          isDangerous: true,
        ),
      ];

  // ---------------------------------------------------------------------------
  // Breadcrumbs
  // ---------------------------------------------------------------------------

  static List<VooBreadcrumbItem> breadcrumbs() => const [
        VooBreadcrumbItem(id: 'home', label: 'Home', icon: Icons.home_outlined),
        VooBreadcrumbItem(id: 'projects', label: 'Projects'),
        VooBreadcrumbItem(id: 'roadmap', label: 'Q3 Roadmap'),
        VooBreadcrumbItem(id: 'current', label: 'Editing', isCurrentPage: true),
      ];

  static List<VooBreadcrumbItem> breadcrumbsLong() => const [
        VooBreadcrumbItem(id: 'home', label: 'Home', icon: Icons.home_outlined),
        VooBreadcrumbItem(id: 'org', label: 'ACME Corp'),
        VooBreadcrumbItem(id: 'team', label: 'Platform'),
        VooBreadcrumbItem(id: 'projects', label: 'Projects'),
        VooBreadcrumbItem(id: 'roadmap', label: 'Q3 Roadmap'),
        VooBreadcrumbItem(id: 'tasks', label: 'Tasks'),
        VooBreadcrumbItem(id: 'current', label: 'Migration', isCurrentPage: true),
      ];

  // ---------------------------------------------------------------------------
  // Context switcher
  // ---------------------------------------------------------------------------

  static const project1 = VooContextItem(
    id: 'p1',
    name: 'Marketing Site',
    icon: Icons.web,
    color: Colors.indigo,
    subtitle: '12 tasks',
  );

  static const project2 = VooContextItem(
    id: 'p2',
    name: 'iOS App',
    icon: Icons.phone_iphone,
    color: Colors.teal,
    subtitle: '8 tasks',
  );

  static const project3 = VooContextItem(
    id: 'p3',
    name: 'Internal Tools',
    icon: Icons.build_outlined,
    color: Colors.orange,
    subtitle: '24 tasks',
  );

  static VooContextSwitcherConfig contextSwitcher() => VooContextSwitcherConfig(
        items: const [project1, project2, project3],
        selectedItem: project1,
        sectionTitle: 'Projects',
        showSearch: true,
        createContextLabel: 'New Project',
      );

  // ---------------------------------------------------------------------------
  // Action item (compose button) for bottom nav
  // ---------------------------------------------------------------------------

  static VooActionNavigationItem composeActionItem() => VooActionNavigationItem(
        id: 'compose',
        icon: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Compose',
        modalBuilder: (context, close) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('New document'),
                onTap: close,
              ),
              ListTile(
                leading: const Icon(Icons.task_alt_outlined),
                title: const Text('New task'),
                onTap: close,
              ),
            ],
          ),
        ),
      );

  // ---------------------------------------------------------------------------
  // Search bar config
  // ---------------------------------------------------------------------------

  static VooSearchBarConfig searchBar({String hint = 'Search...'}) =>
      VooSearchBarConfig(
        hintText: hint,
        enableKeyboardShortcut: true,
        keyboardShortcutHint: '⌘K',
      );

  // ---------------------------------------------------------------------------
  // Composed navigation configs
  // ---------------------------------------------------------------------------

  /// Minimal flat config — built with the new `.simple(...)` factory.
  /// What used to be 4+ lines is now 3.
  static VooNavigationConfig simpleNavConfig({
    String selectedId = 'dashboard',
    ValueChanged<String>? onSelected,
  }) {
    return VooNavigationConfig.simple(
      items: simpleItems,
      selectedId: selectedId,
      onItemSelected: onSelected ?? (_) {},
    );
  }

  /// "App shell" config — sections + multi-switcher + search bar.
  /// Built with the new `.appShell(...)` factory which bakes in the
  /// switcher position, search bar position, and collapsible-rail defaults.
  static VooNavigationConfig fullNavConfig({
    String selectedId = 'dashboard',
    ValueChanged<String>? onSelected,
  }) {
    return VooNavigationConfig.appShell(
      items: sectionedItems,
      selectedId: selectedId,
      onItemSelected: onSelected ?? (_) {},
      header: const VooHeaderConfig(
        title: 'ACME',
        tagline: 'Corp',
        logoIcon: Icons.rocket_launch,
        showTitle: true,
      ),
      multiSwitcher: multiSwitcher(),
      searchBar: searchBar(),
      navigationTheme: const VooNavigationTheme(borderRadius: 12, elevation: 0),
    );
  }
}
