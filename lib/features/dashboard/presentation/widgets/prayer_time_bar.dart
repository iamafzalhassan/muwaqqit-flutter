import 'package:flutter/material.dart';
import 'package:muwaqqit/core/theme/app_font.dart';
import 'package:muwaqqit/core/theme/app_palette.dart';
import 'package:muwaqqit/core/theme/app_sizes.dart';
import 'package:muwaqqit/core/utils/time_format.dart';
import 'package:muwaqqit/features/dashboard/domain/entities/prayer_time.dart';

class PrayerTimeBar extends StatelessWidget {
  const PrayerTimeBar({super.key, required this.prayers});

  final List<PrayerTime> prayers;

  Widget _slot(PrayerTime prayer, double width) => MergeSemantics(
    child: Semantics(
      selected: prayer.isActive,
      child: Container(
        color: prayer.isActive ? AppPalette.prayerBarActive : AppPalette.prayerBarInactive,
        height: AppSizes.prayerBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.textPadding),
        width: width,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Text(
                prayer.name,
                maxLines: 1,
                style: const TextStyle(
                  color: AppPalette.textDark,
                  fontFamily: AppFont.productSansThin,
                  fontSize: AppSizes.prayerFontSize,
                  fontWeight: FontWeight.w300,
                  height: AppSizes.lineHeight,
                  letterSpacing: AppSizes.prayerLetterSpacing,
                ),
              ),
              Text(
                TimeFormat.hoursMinutes(prayer.time),
                maxLines: 1,
                style: const TextStyle(color: AppPalette.textDark, fontFamily: AppFont.googleSansRegular, fontSize: AppSizes.prayerFontSize, fontWeight: FontWeight.w300, height: AppSizes.lineHeight),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width / prayers.length;
    return Stack(
      children: [
        Row(children: [for (final prayer in prayers) _slot(prayer, width)]),
        for (var i = 1; i < prayers.length; i++)
          Positioned(
            bottom: 0,
            left: i * width - AppSizes.dividerWidth / 2,
            top: 0,
            child: ExcludeSemantics(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.filled(
                  AppSizes.dividerDashes,
                  const SizedBox(
                    height: AppSizes.dividerDashHeight,
                    width: AppSizes.dividerWidth,
                    child: ColoredBox(color: AppPalette.textWhite),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
