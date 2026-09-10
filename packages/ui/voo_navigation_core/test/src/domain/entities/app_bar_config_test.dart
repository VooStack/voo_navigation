import 'package:flutter_test/flutter_test.dart';
import 'package:voo_navigation_core/voo_navigation_core.dart';

void main() {
  group('VooAppBarConfig spacing overrides', () {
    test('default to null so Material defaults still apply', () {
      const config = VooAppBarConfig();
      expect(config.titleSpacing, isNull);
      expect(config.leadingWidth, isNull);
      expect(config.hasOverrides, isFalse);
    });

    test('are carried through copyWith', () {
      const config = VooAppBarConfig();
      final updated = config.copyWith(titleSpacing: 10, leadingWidth: 54);
      expect(updated.titleSpacing, 10);
      expect(updated.leadingWidth, 54);
    });

    test('copyWith preserves existing values when omitted', () {
      const config = VooAppBarConfig(titleSpacing: 10, leadingWidth: 54);
      final updated = config.copyWith(centerTitle: true);
      expect(updated.titleSpacing, 10);
      expect(updated.leadingWidth, 54);
    });

    test('count towards hasOverrides', () {
      expect(const VooAppBarConfig(titleSpacing: 10).hasOverrides, isTrue);
      expect(const VooAppBarConfig(leadingWidth: 54).hasOverrides, isTrue);
    });

    test('hidden() leaves them unset', () {
      const config = VooAppBarConfig.hidden();
      expect(config.titleSpacing, isNull);
      expect(config.leadingWidth, isNull);
    });
  });
}
