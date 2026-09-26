# Muwaqqit

![Flutter](https://img.shields.io/badge/Flutter-3.35%2B-02569B?logo=flutter&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-Cubit-13B9FD)
![Offline](https://img.shields.io/badge/data-fully_offline-1B6B4F)
![Platforms](https://img.shields.io/badge/platforms-Android%20%7C%20Web-3DDC84)

A prayer-times board for masjid displays, built with Flutter. Muwaqqit (Arabic for "timekeeper") turns a landscape tablet, TV or browser into a full-screen dashboard showing the current time, a live countdown to the next Azan or Iqamah, and the day's prayer schedule.

Prayer times are calculated on the device with astronomical formulas, so the board needs no internet connection and no external API. The display refreshes every second and is designed to be read from across a prayer hall.

## Features

- **Offline prayer times** for Fajr, Sunrise, Dhuhr, Asr, Maghrib and Isha, calculated from the device's location with the Karachi method and the Shafi madhab for Asr.
- **Jumu'ah on Fridays**: the Dhuhr slot is labelled Jumu'ah automatically.
- **Azan and Iqamah countdowns** to whichever comes next, with an Iqamah gap per prayer (for example Fajr +20 minutes, Maghrib +5 minutes).
- **"Fajr ends in"** countdown up to sunrise.
- **Overnight rollover**: after Isha the countdown moves to the next day's Fajr.
- **Live dashboard** with a large current-time panel ringed by 60 second dots, a countdown panel whose ring runs anti-clockwise, and a prayer bar that highlights the current prayer.
- **Header** with the Gregorian date and the masjid name.
- **Location with a fallback**: the device GPS is used when permission is granted, and Colombo's coordinates when location is off, denied or unavailable.
- **Display-first**: locked to landscape in immersive full-screen mode, with outlined large numerals and panels sized from the screen width.

## Architecture

- **Feature-first folders.** The dashboard feature is split into `data` (location and prayer-time services, repository implementation), `domain` (the `PrayerTime` and `DashboardSnapshot` entities and the repository contract) and `presentation` (cubit, state, screen and widgets). The domain layer knows nothing about presentation: the repository returns a `DashboardSnapshot`, and the cubit turns it into UI state.
- **One Cubit drives the board.** `DashboardCubit` loads the location once, then emits a fresh state from a one-second periodic timer and cancels it when closed.
- **Services behind a repository.** `LocationService` and `PrayerTimeService` are injected into the repository with defaults, so either can be replaced without touching the UI.
- **Reusable widgets.** The seconds ring, time display panel, prayer slot and dotted dividers are self-contained widgets.
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
| Location | geolocator |
| Formatting | intl |
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
    core/constants/         Asset paths, Iqamah gaps
    core/theme/             Fonts, palette, theme
    core/utils/             Date and countdown formatting
    features/dashboard/
        data/               LocationService, PrayerTimeService, DashboardRepositoryImpl
        domain/             PrayerTime, DashboardSnapshot, DashboardRepository
        presentation/       DashboardCubit, DashboardState, Dashboard screen, widgets
```

## Building

**Requirements:** Flutter 3.35 or later, with the Android SDK for Android builds.

- **Android:** `flutter run`, or `flutter build apk --release`.
- **Web:** `flutter run -d chrome`, or `flutter build web`.

## Testing

Unit tests live in `test/`, mirroring the `lib/` path of the code they cover:

- **`test/features/dashboard/data/repositories/dashboard_repository_impl_test.dart`**: the countdown targets the next Azan, then the Iqamah after each prayer's gap, shows when Fajr ends, rolls over to tomorrow's Fajr after Isha, and only the most recent prayer is marked active.

Run them with `flutter test`.

## Roadmap

- Calculate the Hijri date; the header currently shows a fixed value
- Configure the masjid name, calculation method and Iqamah gaps from a settings screen
