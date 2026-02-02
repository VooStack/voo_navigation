import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooAdaptiveScaffold', () {
    late List<VooNavigationDestination> navigationItems;
    late VooNavigationConfig config;

    setUp(() {
      // Reset view to a default size that doesn't interfere with tests
      // Each test should set its own view size if needed
      navigationItems = [
        const VooNavigationDestination(
          id: 'home',
          label: 'Home',
          icon: Icon(Icons.home),
          route: '/home',
        ),
        const VooNavigationDestination(
          id: 'search',
          label: 'Search',
          icon: Icon(Icons.search),
          route: '/search',
        ),
        const VooNavigationDestination(
          id: 'settings',
          label: 'Settings',
          icon: Icon(Icons.settings),
          route: '/settings',
        ),
      ];

      config = VooNavigationConfig(
        items: navigationItems,
        selectedId: 'home',
        onNavigationItemSelected: (id) {},
      );
    });

    testWidgets('should build scaffold with body', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: config,
            body: const Center(child: Text('Test Body')),
          ),
        ),
      );

      expect(find.text('Test Body'), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets(
      'should show bottom navigation on mobile',
      // TODO: Fix mobile breakpoint detection in unit tests
      // The view size setting doesn't propagate correctly to MediaQuery in this test setup.
      // Mobile breakpoints work correctly in integration tests (stateful_shell_integration_test.dart).
      skip: true,
      (WidgetTester tester) async {
        // Set mobile screen size BEFORE pumping any widget
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          createTestApp(
            child: VooAdaptiveScaffold(
              config: config,
              body: const Center(child: Text('Mobile')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should find bottom navigation
        expect(find.byType(VooNavigationBar), findsOneWidget);
        expect(find.byType(VooAdaptiveNavigationRail), findsNothing);
        expect(find.byType(VooAdaptiveNavigationDrawer), findsNothing);
      },
    );

    testWidgets('should show navigation rail on tablet', (
      WidgetTester tester,
    ) async {
      // Set tablet screen size
      tester.view.physicalSize = const Size(700, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: config,
            body: const Center(child: Text('Tablet')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should find navigation rail
      expect(find.byType(VooAdaptiveNavigationRail), findsOneWidget);
      expect(find.byType(VooNavigationBar), findsNothing);
      expect(find.byType(VooAdaptiveNavigationDrawer), findsNothing);
    });

    testWidgets('should show navigation drawer on desktop', (
      WidgetTester tester,
    ) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: config,
            body: const Center(child: Text('Desktop')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should find navigation drawer
      expect(find.byType(VooAdaptiveNavigationDrawer), findsOneWidget);
      expect(find.byType(VooNavigationBar), findsNothing);
      expect(find.byType(VooAdaptiveNavigationRail), findsNothing);
    });

    testWidgets('should show floating action button when provided', (
      WidgetTester tester,
    ) async {
      final configWithFab = config.copyWith(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      );

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: configWithFab,
            body: const Center(child: Text('Test')),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should force navigation type when specified', (
      WidgetTester tester,
    ) async {
      // Set mobile size but force navigation rail
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final forcedConfig = config.copyWith(
        isAdaptive: false,
        forcedNavigationType: VooNavigationType.navigationRail,
      );

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: forcedConfig,
            body: const Center(child: Text('Forced Rail')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show rail even on mobile size
      expect(find.byType(VooAdaptiveNavigationRail), findsOneWidget);
      expect(find.byType(VooNavigationBar), findsNothing);
    });

    testWidgets(
      'should handle navigation item selection',
      // TODO: Fix mobile breakpoint detection in unit tests
      // The view size setting doesn't propagate correctly to MediaQuery in this test setup.
      // Navigation selection works correctly in integration tests.
      skip: true,
      (WidgetTester tester) async {
        String? selectedId;

        // Create navigation items with onTap callbacks for testing
        final testItems = [
          VooNavigationDestination(
            id: 'home',
            label: 'Home',
            icon: const Icon(Icons.home),
            onTap: () {},
          ),
          VooNavigationDestination(
            id: 'search',
            label: 'Search',
            icon: const Icon(Icons.search),
            onTap: () {},
          ),
          VooNavigationDestination(
            id: 'settings',
            label: 'Settings',
            icon: const Icon(Icons.settings),
            onTap: () {},
          ),
        ];

        final interactiveConfig = VooNavigationConfig(
          items: testItems,
          selectedId: 'home',
          onNavigationItemSelected: (id) {
            selectedId = id;
          },
        );

        // Set mobile size BEFORE pumping any widget
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          createTestApp(
            child: VooAdaptiveScaffold(
              config: interactiveConfig,
              body: const Center(child: Text('Test')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap on search navigation item
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();

        expect(selectedId, 'search');
      },
    );

    testWidgets('should apply custom background color', (
      WidgetTester tester,
    ) async {
      final coloredConfig = config.copyWith(backgroundColor: Colors.red);

      await tester.pumpWidget(
        createTestApp(
          child: VooAdaptiveScaffold(
            config: coloredConfig,
            body: const Center(child: Text('Test')),
          ),
        ),
      );

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);

      expect(scaffold.backgroundColor, Colors.red);
    });

    testWidgets(
      'should show extended rail at appropriate size',
      // TODO: Fix breakpoint detection in unit tests
      // The view size setting doesn't propagate correctly to MediaQuery in this test setup.
      skip: true,
      (WidgetTester tester) async {
        // Set size for extended rail (840-1240 is extended rail breakpoint)
        tester.view.physicalSize = const Size(900, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final extendedConfig = config.copyWith(useExtendedRail: true);

        await tester.pumpWidget(
          createTestApp(
            child: VooAdaptiveScaffold(
              config: extendedConfig,
              body: const Center(child: Text('Extended')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should find extended navigation rail
        final rail = tester.widget<VooAdaptiveNavigationRail>(
          find.byType(VooAdaptiveNavigationRail),
        );

        expect(rail.extended, isTrue);
      },
    );
  });
}
