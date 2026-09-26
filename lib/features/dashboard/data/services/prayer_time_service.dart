import 'package:adhan/adhan.dart';
import 'package:muwaqqit/features/dashboard/data/services/location_service.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/prayer_time.dart';

class PrayerTimeService {
  const PrayerTimeService();

  List<PrayerTime> forDate(DateTime date, LatLng location) {
    final times = _compute(date, location);
    final noon = date.weekday == DateTime.friday ? "JUMU'AH" : 'DHUHR';
    return [
      for (final (name, time) in [('FAJR', times.fajr), ('SUNRISE', times.sunrise), (noon, times.dhuhr), ('ASR', times.asr), ('MAGHRIB', times.maghrib), ('ISHA', times.isha)]) PrayerTime(name: name, time: time.toLocal()),
    ];
  }

  DateTime nextFajr(DateTime date, LatLng location) => _compute(date.add(const Duration(days: 1)), location).fajr.toLocal();

  PrayerTimes _compute(DateTime date, LatLng location) => PrayerTimes(Coordinates(location.lat, location.lng), DateComponents(date.year, date.month, date.day), CalculationMethod.karachi.getParameters()..madhab = Madhab.shafi);
}
