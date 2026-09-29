import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

abstract final class TimeFormat {
  static const List<String> _hijriMonths = ['MUHARRAM', 'SAFAR', 'RABI AL AWWAL', 'RABI AL AKHIR', 'JUMADA AL ULA', 'JUMADA AL AKHIRAH', 'RAJAB', 'SHABAN', 'RAMADAN', 'SHAWWAL', 'DHUL QADAH', 'DHUL HIJJAH'];

  static String gregorian(DateTime date) => DateFormat('d MMMM yyyy').format(date).toUpperCase();

  static String hijri(DateTime date, {int dayOffset = 0}) {
    final hijriDate = HijriCalendar.fromDate(DateTime(date.year, date.month, date.day + dayOffset));
    return '${pad(hijriDate.hDay)} ${_hijriMonths[hijriDate.hMonth - 1]} ${hijriDate.hYear}';
  }

  static String hoursMinutes(DateTime time) => DateFormat('HH:mm').format(time);

  static String pad(int value) => value.toString().padLeft(2, '0');
}
