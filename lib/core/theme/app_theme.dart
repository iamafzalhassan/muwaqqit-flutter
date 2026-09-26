import 'package:flutter/material.dart';
import 'package:muwaqqit/core/theme/app_palette.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppPalette.prayerBarActive),
    scaffoldBackgroundColor: AppPalette.panelGrey,
    useMaterial3: true,
  );
}
