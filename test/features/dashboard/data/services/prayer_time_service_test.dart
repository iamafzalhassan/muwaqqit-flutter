import 'package:flutter_test/flutter_test.dart';
import 'package:muwaqqit/features/dashboard/data/services/location_service.dart';
import 'package:muwaqqit/features/dashboard/data/services/prayer_time_service.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/prayer_time.dart';

void main() {
  const PrayerTimeService service = PrayerTimeService();
  const LatLng colombo = LocationService.fallback;

  final DateTime tuesday = DateTime(2026, 9, 15);
  final DateTime friday = DateTime(2026, 9, 18);

  group('PrayerTimeService.forDate', () {
    test('lists the six daily times in chronological order', () {
      final List<PrayerTime> prayers = service.forDate(tuesday, colombo);

      expect(prayers.map((PrayerTime prayer) => prayer.name), <String>['FAJR', 'SUNRISE', 'DHUHR', 'ASR', 'MAGHRIB', 'ISHA']);
      for (int i = 1; i < prayers.length; i++) {
        expect(prayers[i].time.isAfter(prayers[i - 1].time), isTrue, reason: '${prayers[i].name} should follow ${prayers[i - 1].name}');
      }
    });

    test('spans less than a day from Fajr to Isha', () {
      final List<PrayerTime> prayers = service.forDate(tuesday, colombo);

      expect(prayers.last.time.difference(prayers.first.time), lessThan(const Duration(days: 1)));
    });

    test("renames Dhuhr to Jumu'ah on Fridays", () {
      final List<String> names = service.forDate(friday, colombo).map((PrayerTime prayer) => prayer.name).toList();

      expect(names, contains("JUMU'AH"));
      expect(names, isNot(contains('DHUHR')));
    });

    test('keeps Dhuhr on other days', () {
      final List<String> names = service.forDate(tuesday, colombo).map((PrayerTime prayer) => prayer.name).toList();

      expect(names, contains('DHUHR'));
      expect(names, isNot(contains("JUMU'AH")));
    });
  });

  group('PrayerTimeService.nextFajr', () {
    test("returns tomorrow's Fajr, after today's Isha", () {
      final List<PrayerTime> today = service.forDate(tuesday, colombo);
      final DateTime nextFajr = service.nextFajr(tuesday, colombo);

      expect(nextFajr.isAfter(today.last.time), isTrue);
      expect(nextFajr, service.forDate(tuesday.add(const Duration(days: 1)), colombo).first.time);
    });
  });
}
