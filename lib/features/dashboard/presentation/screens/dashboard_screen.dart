import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muwaqqit/core/theme/app_palette.dart';
import 'package:muwaqqit/core/widgets/app_loader.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:muwaqqit/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:muwaqqit/features/dashboard/presentation/widgets/header_bar.dart';
import 'package:muwaqqit/features/dashboard/presentation/widgets/main_panels_row.dart';
import 'package:muwaqqit/features/dashboard/presentation/widgets/prayer_time_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppPalette.textWhite,
    body: BlocBuilder<DashboardCubit, DashboardSnapshot?>(
      builder: (context, snapshot) => snapshot == null
          ? const Center(child: AppLoader())
          : Column(
              children: [
                HeaderBar(gregorianDate: snapshot.gregorianDate, hijriDate: snapshot.hijriDate, masjidName: snapshot.masjidName),
                MainPanelsRow(countdown: snapshot.countdown, countdownLabel: snapshot.nextLabel, now: snapshot.now),
                PrayerTimeBar(prayers: snapshot.prayerTimes),
              ],
            ),
    ),
  );
}
