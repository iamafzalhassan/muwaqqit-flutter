import 'package:flutter_test/flutter_test.dart';
import 'package:muwaqqit/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/prayer_time.dart';

void main() {
  final DashboardRepositoryImpl repository = DashboardRepositoryImpl();

  DateTime at(int hour, int minute) => DateTime(2026, 9, 15, hour, minute);

  final List<PrayerTime> prayers = <PrayerTime>[
    PrayerTime(name: 'FAJR', time: at(4, 40)),
    PrayerTime(name: 'SUNRISE', time: at(5, 55)),
    PrayerTime(name: 'DHUHR', time: at(12, 5)),
    PrayerTime(name: 'ASR', time: at(15, 20)),
    PrayerTime(name: 'MAGHRIB', time: at(18, 10)),
    PrayerTime(name: 'ISHA', time: at(19, 20)),
  ];

  final DateTime nextFajr = DateTime(2026, 9, 16, 4, 40);

  group('DashboardRepositoryImpl.nextEvent', () {
    test('counts down to the Azan before a prayer starts', () {
      final ({String label, DateTime time}) event = repository.nextEvent(prayers, at(11, 0), nextFajr);

      expect(event.label, 'DHUHR AZAN IN');
      expect(event.time, at(12, 5));
    });

    test('counts down to the Iqamah using the prayer gap after the Azan', () {
      final ({String label, DateTime time}) fajr = repository.nextEvent(prayers, at(4, 50), nextFajr);
      final ({String label, DateTime time}) maghrib = repository.nextEvent(prayers, at(18, 12), nextFajr);

      expect(fajr.label, 'FAJR IQAMAH IN');
      expect(fajr.time, at(5, 0));
      expect(maghrib.label, 'MAGHRIB IQAMAH IN');
      expect(maghrib.time, at(18, 15));
    });

    test('shows when Fajr ends once its Iqamah has passed', () {
      final ({String label, DateTime time}) event = repository.nextEvent(prayers, at(5, 30), nextFajr);

      expect(event.label, 'FAJR ENDS IN');
      expect(event.time, at(5, 55));
    });

    test("rolls over to tomorrow's Fajr after the last Iqamah", () {
      final ({String label, DateTime time}) event = repository.nextEvent(prayers, at(21, 0), nextFajr);

      expect(event.label, 'FAJR AZAN IN');
      expect(event.time, nextFajr);
    });
  });

  group('DashboardRepositoryImpl.withActive', () {
    test('marks only the most recent prayer as active', () {
      final List<PrayerTime> marked = repository.withActive(prayers, at(12, 30));

      expect(marked.where((PrayerTime prayer) => prayer.isActive).map((PrayerTime prayer) => prayer.name), <String>['DHUHR']);
    });

    test('marks nothing before Fajr', () {
      final List<PrayerTime> marked = repository.withActive(prayers, at(3, 0));

      expect(marked.any((PrayerTime prayer) => prayer.isActive), isFalse);
    });
  });
}
