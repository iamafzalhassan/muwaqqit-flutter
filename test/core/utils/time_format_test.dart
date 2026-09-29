import 'package:flutter_test/flutter_test.dart';
import 'package:muwaqqit/core/utils/time_format.dart';

void main() {
  group('TimeFormat.hijri', () {
    test('formats the Umm al-Qura date in the header style', () {
      expect(TimeFormat.hijri(DateTime(2025, 9, 27)), '05 RABI AL AKHIR 1447');
      expect(TimeFormat.hijri(DateTime(2026, 2, 18)), '01 RAMADAN 1447');
    });

    test('ignores the time of day', () {
      expect(TimeFormat.hijri(DateTime(2025, 9, 27, 23, 59)), '05 RABI AL AKHIR 1447');
    });

    test('shifts the date by the configured day offset', () {
      expect(TimeFormat.hijri(DateTime(2025, 9, 27), dayOffset: -1), '04 RABI AL AKHIR 1447');
      expect(TimeFormat.hijri(DateTime(2025, 9, 27), dayOffset: 1), '06 RABI AL AKHIR 1447');
    });

    test('moves across a month boundary when offset', () {
      expect(TimeFormat.hijri(DateTime(2026, 2, 18), dayOffset: -1), '29 SHABAN 1447');
      expect(TimeFormat.hijri(DateTime(2026, 3, 19), dayOffset: 1), '01 SHAWWAL 1447');
    });
  });
}
