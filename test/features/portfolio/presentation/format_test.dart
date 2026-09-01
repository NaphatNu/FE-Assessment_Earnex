import 'package:flutter_test/flutter_test.dart';

import 'package:fe_assessment_earnex/features/portfolio/presentation/format.dart';

void main() {
  group('badgeLabel', () {
    test('null count is unknown', () {
      expect(badgeLabel(null), isNull);
    });

    test('0 renders as 0', () {
      expect(badgeLabel(0), '0');
    });

    test('18 renders as-is', () {
      expect(badgeLabel(18), '18');
    });

    test('99 renders as-is', () {
      expect(badgeLabel(99), '99');
    });

    test('100 clamps to 99+', () {
      expect(badgeLabel(100), '99+');
    });

    test('1000 clamps to 99+', () {
      expect(badgeLabel(1000), '99+');
    });
  });

  group('formatMoney', () {
    test('adds thousands separators and 2 decimals', () {
      expect(formatMoney(15879.46), '15,879.46');
      expect(formatMoney(388038.47), '388,038.47');
    });

    test('zero', () {
      expect(formatMoney(0), '0.00');
    });

    test('negative value', () {
      expect(formatMoney(-1234.5), '-1,234.50');
    });
  });

  group('formatPercent', () {
    test('adds percent sign and 2 decimals', () {
      expect(formatPercent(17.07), '17.07%');
    });
  });
}
