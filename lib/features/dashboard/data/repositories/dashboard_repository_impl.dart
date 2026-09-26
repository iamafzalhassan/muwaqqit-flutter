import 'package:flutter/foundation.dart';
import 'package:muwaqqit/core/utils/time_format.dart';
import 'package:muwaqqit/features/dashboard/data/services/location_service.dart';
import 'package:muwaqqit/features/dashboard/data/services/prayer_time_service.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/prayer_time.dart';
import 'package:muwaqqit/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  static const Map<String, int> _iqamahMinutes = {'FAJR': 20, 'DHUHR': 10, "JUMU'AH": 10, 'ASR': 10, 'MAGHRIB': 5, 'ISHA': 10};

  final LocationService _locationService;

  final PrayerTimeService _prayerTimeService;

  LatLng _location = LocationService.fallback;

  List<PrayerTime>? _cachedPrayers;

  DateTime? _cachedDay;
  DateTime? _cachedNextFajr;

  DashboardRepositoryImpl({LocationService locationService = const LocationService(), PrayerTimeService prayerTimeService = const PrayerTimeService()}) : _locationService = locationService, _prayerTimeService = prayerTimeService;

  @visibleForTesting
  List<PrayerTime> withActive(List<PrayerTime> prayers, DateTime now) {
    final activeName = prayers.where((prayer) => !now.isBefore(prayer.time)).lastOrNull?.name;
    return [for (final prayer in prayers) prayer.copyWith(isActive: prayer.name == activeName)];
  }

  @visibleForTesting
  ({String label, DateTime time}) nextEvent(List<PrayerTime> prayers, DateTime now, DateTime nextFajr) {
    final events = [
      for (final prayer in prayers)
        if (prayer.name == 'SUNRISE')
          (label: 'FAJR ENDS IN', time: prayer.time)
        else ...[
          (label: '${prayer.name} AZAN IN', time: prayer.time),
          (label: '${prayer.name} IQAMAH IN', time: prayer.time.add(Duration(minutes: _iqamahMinutes[prayer.name] ?? 10))),
        ],
    ]..sort((a, b) => a.time.compareTo(b.time));
    return events.firstWhere((event) => event.time.isAfter(now), orElse: () => (label: 'FAJR AZAN IN', time: nextFajr));
  }

  DashboardSnapshot _snapshotAt(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    if (_cachedDay != today) {
      _cachedDay = today;
      _cachedPrayers = _prayerTimeService.forDate(today, _location);
      _cachedNextFajr = _prayerTimeService.nextFajr(today, _location);
    }
    final prayers = withActive(_cachedPrayers!, now);
    final next = nextEvent(prayers, now, _cachedNextFajr!);
    return DashboardSnapshot(gregorianDate: TimeFormat.gregorian(now), hijriDate: '05 RABI AL AKHIR 1447', masjidName: 'MUHIYYADDEEN MASJID', nextLabel: next.label, prayerTimes: prayers, nextPrayerTime: next.time, now: now);
  }

  @override
  Future<DashboardSnapshot> load() async {
    _location = await _locationService.current();
    return refresh();
  }

  @override
  DashboardSnapshot refresh() => _snapshotAt(DateTime.now());
}
