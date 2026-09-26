import 'package:muwaqqit/features/dashboard/domain/entities/prayer_time.dart';

class DashboardSnapshot {
  final String gregorianDate;
  final String hijriDate;
  final String masjidName;
  final String nextLabel;

  final List<PrayerTime> prayerTimes;

  final DateTime nextPrayerTime;
  final DateTime now;

  const DashboardSnapshot({required this.gregorianDate, required this.hijriDate, required this.masjidName, required this.nextLabel, required this.prayerTimes, required this.nextPrayerTime, required this.now});

  Duration get countdown => nextPrayerTime.difference(now);
}
