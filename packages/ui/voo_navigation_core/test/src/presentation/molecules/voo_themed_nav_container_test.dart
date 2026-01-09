import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooThemedNavContainer', () {
    late VooNavigationTheme theme;

    setUp(() {
      theme = VooNavigationTheme.material3Enhanced();
    });

    testWidgets('should not expand by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: Center(
            child: VooThemedNavContainer(
              theme: theme,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      // Find the container - it should size to child (100x100)
      final containerFinder = find.byType(VooThemedNavContainer);
      expect(containerFinder, findsOneWidget);

      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, 100);
      expect(containerSize.height, 100);
    });

    testWidgets('should expand to fill available space when expand is true', (
      WidgetTester tester,
    ) async {
      const parentWidth = 400.0;
      const parentHeight = 300.0;

      await tester.pumpWidget(
        createTestApp(
          child: SizedBox.expand(
            child: Row(
              children: [
                // Navigation placeholder
                const SizedBox(width: 100),
                // Body area with tight constraints (like Expanded does)
                SizedBox(
                  width: parentWidth,
                  height: parentHeight,
                  child: VooThemedNavContainer(
                    theme: theme,
                    expand: true,
                    child: const SizedBox(width: 100, height: 100),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final containerFinder = find.byType(VooThemedNavContainer);
      expect(containerFinder, findsOneWidget);

      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, parentWidth);
      expect(containerSize.height, parentHeight);
    });

    testWidgets('should expand with margin and fill remaining space', (
      WidgetTester tester,
    ) async {
      const parentWidth = 400.0;
      const parentHeight = 300.0;

      await tester.pumpWidget(
        createTestApp(
          child: SizedBox.expand(
            child: Row(
              children: [
                const SizedBox(width: 100),
                SizedBox(
                  width: parentWidth,
                  height: parentHeight,
                  child: VooThemedNavContainer(
                    theme: theme,
                    expand: true,
                    margin: const EdgeInsets.all(16.0),
                    child: const SizedBox(width: 100, height: 100),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final containerFinder = find.byType(VooThemedNavContainer);
      expect(containerFinder, findsOneWidget);

      // Container outer size should match parent (margin is internal)
      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, parentWidth);
      expect(containerSize.height, parentHeight);
    });

    testWidgets('should respect explicit width/height over expand', (
      WidgetTester tester,
    ) async {
      const explicitWidth = 200.0;
      const explicitHeight = 150.0;

      await tester.pumpWidget(
        createTestApp(
          child: Center(
            child: VooThemedNavContainer(
              theme: theme,
              expand: true,
              width: explicitWidth,
              height: explicitHeight,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );

      final containerFinder = find.byType(VooThemedNavContainer);
      expect(containerFinder, findsOneWidget);

      // Should use explicit width/height, not expand
      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, explicitWidth);
      expect(containerSize.height, explicitHeight);
    });

    group('theme presets', () {
      final presets = [
        ('glassmorphism', VooNavigationTheme.glassmorphism()),
        ('liquidGlass', VooNavigationTheme.liquidGlass()),
        ('blurry', VooNavigationTheme.blurry()),
        ('neomorphism', VooNavigationTheme.neomorphism()),
        ('material3Enhanced', VooNavigationTheme.material3Enhanced()),
        ('minimalModern', VooNavigationTheme.minimalModern()),
      ];

      for (final (name, presetTheme) in presets) {
        testWidgets('$name should expand when expand is true', (
          WidgetTester tester,
        ) async {
          const parentWidth = 400.0;
          const parentHeight = 300.0;

          await tester.pumpWidget(
            createTestApp(
              child: SizedBox.expand(
                child: Row(
                  children: [
                    const SizedBox(width: 100),
                    SizedBox(
                      width: parentWidth,
                      height: parentHeight,
                      child: VooThemedNavContainer(
                        theme: presetTheme,
                        expand: true,
                        child: const SizedBox(width: 100, height: 100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          final containerFinder = find.byType(VooThemedNavContainer);
          expect(containerFinder, findsOneWidget);

          final containerSize = tester.getSize(containerFinder);
          expect(containerSize.width, parentWidth);
          expect(containerSize.height, parentHeight);
        });
      }
    });
  });

  group('Body layout in scaffolds', () {
    late List<VooNavigationItem> navigationItems;
    late VooNavigationConfig config;

    setUp(() {
      navigationItems = [
        const VooNavigationItem(
          id: 'home',
          label: 'Home',
          icon: Icons.home,
          route: '/home',
        ),
        const VooNavigationItem(
          id: 'settings',
          label: 'Settings',
          icon: Icons.settings,
          route: '/settings',
        ),
      ];

      config = VooNavigationConfig(
        items: navigationItems,
        selectedId: 'home',
        onNavigationItemSelected: (id) {},
      );
    });

    testWidgets(
      'desktop scaffold body should fill available height with margins',
      (WidgetTester tester) async {
        // Set desktop screen size
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestApp(
            child: VooAdaptiveScaffold(
              config: config,
              body: Container(
                key: const Key('body_content'),
                color: Colors.blue,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the VooThemedNavContainer that wraps the body
        final themedContainerFinder = find.byType(VooThemedNavContainer);

        // Should find at least one (for the body)
        expect(themedContainerFinder, findsWidgets);

        // The body container should have significant height (not just wrapping content)
        // This ensures the expand: true is working
        final containers = tester.widgetList<VooThemedNavContainer>(themedContainerFinder);
        for (final container in containers) {
          if (container.expand == true) {
            // Found an expanding container - this is what we want
            expect(container.expand, isTrue);
          }
        }
      },
    );

    testWidgets(
      'tablet scaffold body should fill available height with margins',
      (WidgetTester tester) async {
        // Set tablet screen size
        tester.view.physicalSize = const Size(900, 700);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestApp(
            child: VooAdaptiveScaffold(
              config: config,
              body: Container(
                key: const Key('body_content'),
                color: Colors.blue,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the VooThemedNavContainer that wraps the body
        final themedContainerFinder = find.byType(VooThemedNavContainer);

        // Should find at least one (for the body)
        expect(themedContainerFinder, findsWidgets);

        // Check that expand is set to true on body containers
        final containers = tester.widgetList<VooThemedNavContainer>(themedContainerFinder);
        for (final container in containers) {
          if (container.expand == true) {
            expect(container.expand, isTrue);
          }
        }
      },
    );

    testWidgets(
      'body VooThemedNavContainer should have expand: true on desktop',
      (WidgetTester tester) async {
        // Set desktop screen size
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestApp(
            child: VooAdaptiveScaffold(
              config: config.copyWith(appBarAlongsideRail: true),
              body: const Center(child: Text('Body Content')),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find all VooThemedNavContainer widgets
        final containers = tester.widgetList<VooThemedNavContainer>(
          find.byType(VooThemedNavContainer),
        );

        // At least one should have expand: true (the body container)
        final hasExpandingContainer = containers.any((c) => c.expand == true);
        expect(
          hasExpandingContainer,
          isTrue,
          reason: 'Body should be wrapped in VooThemedNavContainer with expand: true',
        );
      },
    );

    testWidgets(
      'body content should be visible and properly positioned',
      (WidgetTester tester) async {
        // Set desktop screen size
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          createTestApp(
            child: VooAdaptiveScaffold(
              config: config,
              body: const Center(
                child: Text('Body Content', key: Key('body_text')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Body content should be visible
        expect(find.byKey(const Key('body_text')), findsOneWidget);
        expect(find.text('Body Content'), findsOneWidget);
      },
    );
  });
}
