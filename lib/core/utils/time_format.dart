import 'package:intl/intl.dart';

abstract final class TimeFormat {
  static String gregorian(DateTime date) => DateFormat('d MMMM yyyy').format(date).toUpperCase();

  static String hoursMinutes(DateTime time) => DateFormat('HH:mm').format(time);

  static String pad(int value) => value.toString().padLeft(2, '0');
}
