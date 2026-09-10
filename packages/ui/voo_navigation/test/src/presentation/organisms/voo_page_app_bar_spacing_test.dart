import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation/voo_navigation.dart';

void main() {
  Future<AppBar> pumpPage(WidgetTester tester, {double? titleSpacing, double? leadingWidth}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: VooPage(
          config: VooPageConfig(
            appBarConfig: VooAppBarConfig(
              title: const Text('Notifications'),
              leading: const Icon(Icons.chevron_left),
              titleSpacing: titleSpacing,
              leadingWidth: leadingWidth,
            ),
          ),
          child: const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.widget<AppBar>(find.byType(AppBar));
  }

  testWidgets('falls back to Material defaults when unset', (tester) async {
    final appBar = await pumpPage(tester);

    expect(appBar.titleSpacing, isNull);
    expect(appBar.leadingWidth, isNull);
  });

  testWidgets('forwards titleSpacing and leadingWidth to the AppBar', (tester) async {
    final appBar = await pumpPage(tester, titleSpacing: 10, leadingWidth: 54);

    expect(appBar.titleSpacing, 10);
    expect(appBar.leadingWidth, 54);
  });

  testWidgets('leadingWidth positions the leading edge at the requested gutter', (tester) async {
    await pumpPage(tester, titleSpacing: 10, leadingWidth: 54);

    final titleLeft = tester.getTopLeft(find.text('Notifications')).dx;
    expect(titleLeft, 64, reason: 'leadingWidth 54 + titleSpacing 10');
  });
}
