import 'package:flutter/material.dart';
import 'package:muwaqqit/core/theme/app_palette.dart';
import 'package:muwaqqit/core/utils/time_format.dart';
import 'package:muwaqqit/features/dashboard/presentation/widgets/time_display_panel.dart';

class MainPanelsRow extends StatelessWidget {
  const MainPanelsRow({super.key, required this.countdownLabel, required this.now, required this.countdown});

  final String countdownLabel;

  final DateTime now;

  final Duration countdown;

  @override
  Widget build(BuildContext context) {
    final remaining = countdown.isNegative ? Duration.zero : countdown;
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TimeDisplayPanel(
              color: AppPalette.panelGrey,
              dotColor: AppPalette.dotActiveGreen,
              isClockwise: true,
              labelLetterSpacing: 2,
              labelText: 'TIME',
              primary: TimeFormat.pad(now.hour),
              secondary: TimeFormat.pad(now.minute),
              secondsValue: now.second,
            ),
          ),
          Expanded(
            child: TimeDisplayPanel(
              color: AppPalette.panelYellow,
              dotColor: AppPalette.dotActiveRed,
              isClockwise: false,
              labelText: countdownLabel,
              primary: TimeFormat.pad(remaining.inHours),
              secondary: TimeFormat.pad(remaining.inMinutes.remainder(60)),
              secondsValue: remaining.inSeconds.remainder(60),
            ),
          ),
        ],
      ),
    );
  }
}
