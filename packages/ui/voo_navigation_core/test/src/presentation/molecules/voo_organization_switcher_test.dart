import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('VooOrganizationSwitcher', () {
    const acme = VooOrganization(id: 'acme', name: 'Acme');
    const globex = VooOrganization(id: 'globex', name: 'Globex');

    Widget switcher() => createTestApp(
          child: const Scaffold(
            body: Center(
              child: VooOrganizationSwitcher(
                organizations: [acme, globex],
                selectedOrganization: acme,
              ),
            ),
          ),
        );

    testWidgets('can be disposed while closed', (WidgetTester tester) async {
      await tester.pumpWidget(switcher());

      await tester.pumpWidget(const SizedBox.shrink());

      expect(tester.takeException(), isNull);
    });

    testWidgets('removes its dropdown when disposed while open', (WidgetTester tester) async {
      await tester.pumpWidget(switcher());
      await tester.tap(find.text('Acme'));
      await tester.pumpAndSettle();
      expect(find.text('Globex'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());

      expect(tester.takeException(), isNull);
      expect(find.text('Globex'), findsNothing);
    });
  });
}
