import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

void main() {
  group('VooNavigationConfig', () {
    test('should create config with required parameters', () {
      final items = [const VooNavigationDestination(id: 'home', label: 'Home', icon: Icon(Icons.home), route: '/test')];

      final config = VooNavigationConfig(items: items, onNavigationItemSelected: (id) {});

      expect(config.items, equals(items));
      expect(config.selectedId, isNull);
      expect(config.isAdaptive, isTrue);
      expect(config.animation.enabled, isTrue);
      expect(config.enableHapticFeedback, isTrue);
    });

    test('should create config with all parameters', () {
      final items = [
        const VooNavigationDestination(id: 'home', label: 'Home', icon: Icon(Icons.home), route: '/test'),
        const VooNavigationDestination(id: 'settings', label: 'Settings', icon: Icon(Icons.settings), route: '/test'),
      ];

      final config = VooNavigationConfig(
        items: items,
        selectedId: 'home',
        isAdaptive: false,
        forcedNavigationType: VooNavigationType.navigationRail,
        animation: const VooAnimationConfig(
          enabled: false,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear,
        ),
        enableHapticFeedback: false,
        railLabelType: NavigationRailLabelType.all,
        useExtendedRail: false,
        showNavigationRailDivider: false,
        showNotificationBadges: false,
        backgroundColor: Colors.white,
        navigationTheme: VooNavigationTheme(
          surfaceColor: Colors.grey,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          indicatorColor: Colors.blue.withAlpha(30),
          indicatorShape: const RoundedRectangleBorder(),
          elevation: 4.0,
        ),
        drawerSlots: const VooDrawerSlots(
          header: Text('Header'),
          footer: Text('Footer'),
        ),
        fab: VooFabConfig(
          widget: const FloatingActionButton(onPressed: null, child: Icon(Icons.add)),
          animator: FloatingActionButtonAnimator.scaling,
        ),
        breakpoints: [],
        onNavigationItemSelected: (id) {},
      );

      expect(config.items, equals(items));
      expect(config.selectedId, 'home');
      expect(config.isAdaptive, isFalse);
      expect(config.forcedNavigationType, VooNavigationType.navigationRail);
      expect(config.animation.enabled, isFalse);
      expect(config.enableHapticFeedback, isFalse);
      expect(config.animation.duration, const Duration(milliseconds: 500));
      expect(config.animation.curve, Curves.linear);
      expect(config.animation.badgeDuration, const Duration(milliseconds: 150));
      expect(config.railLabelType, NavigationRailLabelType.all);
      expect(config.useExtendedRail, isFalse);
      expect(config.showNavigationRailDivider, isFalse);
      expect(config.showNotificationBadges, isFalse);
      expect(config.groupItemsBySections, isFalse);
      expect(config.backgroundColor, Colors.white);
      expect(config.effectiveTheme.surfaceColor, Colors.grey);
      expect(config.effectiveTheme.selectedItemColor, Colors.blue);
      expect(config.effectiveTheme.unselectedItemColor, Colors.black);
      expect(config.effectiveTheme.indicatorColor, Colors.blue.withAlpha(30));
      expect(config.effectiveTheme.indicatorShape, isA<RoundedRectangleBorder>());
      expect(config.effectiveTheme.elevation, 4.0);
      expect(config.drawerSlots?.header, isNotNull);
      expect(config.drawerSlots?.footer, isNotNull);
      expect(config.fab?.widget, isNotNull);
      expect(config.fab?.animator, FloatingActionButtonAnimator.scaling);
      expect(config.breakpoints, isEmpty);
    });

    test('visibleItems should filter out invisible items', () {
      final items = [
        const VooNavigationDestination(id: 'home', label: 'Home', icon: Icon(Icons.home), route: '/test'),
        const VooNavigationDestination(id: 'hidden', label: 'Hidden', icon: Icon(Icons.visibility_off), route: '/test', isVisible: false),
        const VooNavigationDestination(id: 'settings', label: 'Settings', icon: Icon(Icons.settings), route: '/test'),
      ];

      final config = VooNavigationConfig(items: items, onNavigationItemSelected: (id) {});

      expect(config.visibleItems.length, 2);
      expect(config.visibleItems[0].id, 'home');
      expect(config.visibleItems[1].id, 'settings');
    });

    test('selectedId should work correctly', () {
      final items = [
        const VooNavigationDestination(id: 'home', label: 'Home', icon: Icon(Icons.home), route: '/test'),
        const VooNavigationDestination(id: 'settings', label: 'Settings', icon: Icon(Icons.settings), route: '/test'),
      ];

      final configWithSelected = VooNavigationConfig(items: items, selectedId: 'home', onNavigationItemSelected: (id) {});

      final configWithoutSelected = VooNavigationConfig(items: items, onNavigationItemSelected: (id) {});

      final configWithInvalidSelected = VooNavigationConfig(items: items, selectedId: 'invalid', onNavigationItemSelected: (id) {});

      expect(configWithSelected.selectedId, 'home');
      expect(configWithoutSelected.selectedId, isNull);
      expect(configWithInvalidSelected.selectedId, 'invalid');
    });

    test('selectedItem should return correct item or null', () {
      const homeItem = VooNavigationDestination(id: 'home', label: 'Home', icon: Icon(Icons.home), route: '/test');
      const settingsItem = VooNavigationDestination(id: 'settings', label: 'Settings', icon: Icon(Icons.settings), route: '/test');

      final items = [homeItem, settingsItem];

      final config = VooNavigationConfig(items: items, selectedId: 'home', onNavigationItemSelected: (id) {});

      expect(config.selectedItem, equals(homeItem));

      final configNoSelection = VooNavigationConfig(items: items, onNavigationItemSelected: (id) {});

      expect(configNoSelection.selectedItem, isNull);
    });

    test('copyWith should create new instance with updated values', () {
      final items = [const VooNavigationDestination(id: 'home', label: 'Home', icon: Icon(Icons.home), route: '/test')];

      final config = VooNavigationConfig(items: items, selectedId: 'home', onNavigationItemSelected: (id) {});

      final newItems = [const VooNavigationDestination(id: 'settings', label: 'Settings', icon: Icon(Icons.settings), route: '/test')];

      final updatedConfig = config.copyWith(
        items: newItems,
        selectedId: 'settings',
        animation: const VooAnimationConfig(enabled: false),
      );

      expect(updatedConfig.items, equals(newItems));
      expect(updatedConfig.selectedId, 'settings');
      expect(updatedConfig.animation.enabled, isFalse);
      expect(updatedConfig.enableHapticFeedback, isTrue); // unchanged
    });

    test('configuration callback should be called', () {
      final items = [
        const VooNavigationDestination(id: 'home', label: 'Home', icon: Icon(Icons.home), route: '/test'),
        const VooNavigationDestination(id: 'settings', label: 'Settings', icon: Icon(Icons.settings), route: '/test'),
      ];

      String? selectedItemId;

      final config = VooNavigationConfig(
        items: items,
        selectedId: 'home',
        onNavigationItemSelected: (id) {
          selectedItemId = id;
        },
      );

      // Simulate navigation item selection
      config.onNavigationItemSelected?.call('settings');

      expect(selectedItemId, 'settings');
    });
  });
}
