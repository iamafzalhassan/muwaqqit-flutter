class PrayerTime {
  final bool isActive;

  final String name;

  final DateTime time;

  const PrayerTime({this.isActive = false, required this.name, required this.time});

  PrayerTime copyWith({bool? isActive, String? name, DateTime? time}) => PrayerTime(isActive: isActive ?? this.isActive, name: name ?? this.name, time: time ?? this.time);
}
