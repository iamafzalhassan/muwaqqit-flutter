# Muwaqqit

[![CI](https://github.com/iamafzalhassan/muwaqqit-flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/iamafzalhassan/muwaqqit-flutter/actions/workflows/ci.yml)
![Dart](https://img.shields.io/badge/Dart-3.9%2B-0175C2?logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-Cubit-13B9FD)
![Offline](https://img.shields.io/badge/data-fully_offline-1B6B4F)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20Web-3DDC84)

A prayer-times board for masjid displays, built with Flutter. Muwaqqit (Arabic for "timekeeper") turns a landscape tablet, TV or browser into a full-screen dashboard showing the current time, a live countdown to the next Azan or Iqamah, and the day's prayer schedule.

Prayer times are calculated on the device with the astronomical formulas of the [adhan](https://pub.dev/packages/adhan) package, so the board needs no internet connection and no external API. The display refreshes every second and is designed to be read from across a prayer hall.

## Features

- **Offline prayer times** for Fajr, Sunrise, Dhuhr, Asr, Maghrib and Isha, calculated from the device's location with the Karachi method and the Shafi madhab for Asr.
- **Jumu'ah on Fridays**: the Dhuhr slot is labelled Jumu'ah automatically.
- **Azan and Iqamah countdowns** to whichever comes next, with an Iqamah gap per prayer (for example Fajr +20 minutes, Maghrib +5 minutes).
- **"Fajr ends in"** countdown up to sunrise.
- **Overnight rollover**: after Isha the countdown moves to the next day's Fajr.
- **Live dashboard** with a large current-time panel ringed by 60 second dots, a countdown panel whose ring runs anti-clockwise, and a prayer bar that highlights the current prayer.
- **Header** with the Gregorian date, the masjid name and the Hijri date. The Hijri date is computed for the current day from the Umm al-Qura calendar, with a configurable day offset for masjids that follow local moon sighting.
- **Location with a fallback**: the device GPS is used when permission is granted, and Colombo's coordinates when location is off, denied or unavailable.
- **Display-first**: locked to landscape in immersive full-screen mode, with outlined large numerals and panels sized mostly from the screen height, clamped by the width.
- **Keeps the screen awake** on Android and web, so the display never dims or sleeps.

## Architecture

- **Feature-first folders.** The dashboard feature is split into `data` (location and prayer-time services, repository implementation), `domain` (the `PrayerTime` and `DashboardSnapshot` entities and the repository contract) and `presentation` (cubit, screen and widgets). The domain layer knows nothing about presentation: the repository returns a `DashboardSnapshot`, and the cubit emits that snapshot directly as its state, with `null` while loading.
- **One Cubit drives the board.** `DashboardCubit` loads the location once, then emits a fresh snapshot from a one-second periodic timer and cancels it when closed. If the first load fails, it retries after a short delay.
- **Services behind a repository.** `LocationService` and `PrayerTimeService` are injected into the repository with defaults, so either can be replaced without touching the UI.
- **Reusable widgets.** The seconds ring and time display panel are self-contained widgets; each prayer slot is a private `_slot` method of the prayer bar, which also draws its dotted dividers inline.
- **No code generation.** Entities and `copyWith` are written by hand.

## How the timing works

1. **Location is resolved once** at start-up, falling back to Colombo if GPS cannot be used.
2. **The timetable is cached per day.** Today's prayers and tomorrow's Fajr are calculated when the date changes and reused for every tick until midnight.
3. **Every tick builds a list of events.** Each prayer contributes an Azan event and an Iqamah event offset by its gap; Sunrise contributes the end of Fajr.
4. **The next event wins.** Events are sorted by time and the first one still in the future becomes the countdown; if none is left, the countdown targets tomorrow's Fajr.
5. **The active prayer** is the most recent one whose time has passed, and the prayer bar highlights it.

## Tech stack

| Area | Choice |
|---|---|
| Language | Dart 3.9 |
| UI | Flutter, Material |
| State | flutter_bloc (Cubit) |
| Prayer calculation | adhan |
| Hijri date | hijri |
| Location | geolocator |
| Formatting | intl |
| Keep awake | wakelock_plus |
| Platforms | Android, Web |

## Code conventions

- A strict member ordering convention for every class: fields sorted by type tier, then type, then name; methods ordered by call order.
- No comments in source. Names, types and ordering carry the meaning.
- `dart format` at a 240-column page width.

## Project structure

```
lib/
    main.dart               Landscape lock and immersive mode
    app.dart                BlocProvider and MaterialApp
    core/config/            Masjid name and Hijri day offset
    core/theme/             Fonts, palette, theme
    core/utils/             Gregorian, Hijri and countdown formatting
    core/widgets/           Loading indicator
    features/dashboard/
        data/               LocationService, PrayerTimeService, DashboardRepositoryImpl (Iqamah gaps)
        domain/             PrayerTime, DashboardSnapshot, DashboardRepository
        presentation/       DashboardCubit, DashboardScreen, widgets
```

## Building

**Requirements:** a Flutter SDK with Dart 3.9 or later (`sdk: ^3.9.0` in `pubspec.yaml`), with the Android SDK for Android builds. CI runs on Flutter 3.47.2.

- **Android:** `flutter run`, or `flutter build apk --release`. Release builds are currently signed with the debug key (see `android/app/build.gradle.kts`); add your own signing config before publishing.
- **Web:** `flutter run -d chrome`, or `flutter build web`.

## Testing

Unit tests live in `test/`, mirroring the `lib/` path of the code they cover:

- **`test/core/utils/time_format_test.dart`**: the Hijri date is rendered in the header style, ignores the time of day, and shifts by the configured day offset, including across a month boundary.
- **`test/features/dashboard/data/repositories/dashboard_repository_impl_test.dart`**: the countdown targets the next Azan, then the Iqamah after each prayer's gap, shows when Fajr ends, rolls over to tomorrow's Fajr after Isha, and only the most recent prayer is marked active.
- **`test/features/dashboard/data/services/prayer_time_service_test.dart`**: the six daily times come out in chronological order, Dhuhr is renamed Jumu'ah on Fridays only, and the next Fajr falls on the following day.
- **`test/features/dashboard/presentation/cubits/dashboard_cubit_test.dart`**: a failed load is retried until the snapshot is emitted, and retrying stops once the cubit is closed.

Run them with `flutter test`.

## Roadmap

- Configure the masjid name and Hijri day offset without rebuilding; they currently live in `lib/core/config/app_config.dart`
- Configure the calculation method and Iqamah gaps from a settings screen
