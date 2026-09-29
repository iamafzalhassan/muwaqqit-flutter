import 'package:flutter_test/flutter_test.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/prayer_time.dart';
import 'package:muwaqqit/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:muwaqqit/features/dashboard/presentation/cubits/dashboard_cubit.dart';

class _FlakyDashboardRepository implements DashboardRepository {
  final DashboardSnapshot snapshot;

  int failuresLeft;

  _FlakyDashboardRepository({required this.failuresLeft, required this.snapshot});

  @override
  Future<DashboardSnapshot> load() async {
    if (failuresLeft > 0) {
      failuresLeft--;
      throw StateError('load failed');
    }
    return snapshot;
  }

  @override
  DashboardSnapshot refresh() => snapshot;
}

void main() {
  final DateTime now = DateTime(2026, 9, 15, 11);

  final DashboardSnapshot snapshot = DashboardSnapshot(
    gregorianDate: '15 SEPTEMBER 2026',
    hijriDate: '04 RABI AL AKHIR 1448',
    masjidName: 'MASJID',
    nextLabel: 'DHUHR AZAN IN',
    nextPrayerTime: DateTime(2026, 9, 15, 12, 5),
    now: now,
    prayerTimes: <PrayerTime>[PrayerTime(name: 'DHUHR', time: DateTime(2026, 9, 15, 12, 5))],
  );

  group('DashboardCubit', () {
    test('retries a failed load and then emits the snapshot', () async {
      final _FlakyDashboardRepository repository = _FlakyDashboardRepository(failuresLeft: 2, snapshot: snapshot);
      final DashboardCubit cubit = DashboardCubit(repository: repository, retryDelay: Duration.zero);

      final DashboardSnapshot? emitted = await cubit.stream.first;

      expect(emitted, same(snapshot));
      expect(repository.failuresLeft, 0);
      await cubit.close();
    });

    test('stops retrying once closed', () async {
      final _FlakyDashboardRepository repository = _FlakyDashboardRepository(failuresLeft: 5, snapshot: snapshot);
      final DashboardCubit cubit = DashboardCubit(repository: repository, retryDelay: const Duration(milliseconds: 10));

      await cubit.close();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(cubit.state, isNull);
      expect(repository.failuresLeft, 4);
    });
  });
}
