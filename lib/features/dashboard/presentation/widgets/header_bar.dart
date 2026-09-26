import 'package:flutter/material.dart';
import 'package:muwaqqit/core/theme/app_font.dart';
import 'package:muwaqqit/core/theme/app_palette.dart';
import 'package:muwaqqit/core/theme/app_sizes.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key, required this.gregorianDate, required this.hijriDate, required this.masjidName});

  final String gregorianDate;
  final String hijriDate;
  final String masjidName;

  Widget _cell(String text, Color color) => Expanded(
    child: Container(
      alignment: Alignment.center,
      color: color,
      height: AppSizes.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.textPadding),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          maxLines: 1,
          style: const TextStyle(color: AppPalette.textWhite, fontFamily: AppFont.productSansThin, fontSize: AppSizes.headerFontSize, fontWeight: FontWeight.w300, letterSpacing: AppSizes.headerLetterSpacing),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Row(children: [_cell(gregorianDate, AppPalette.headerDark), _cell(masjidName, AppPalette.headerDarker), _cell(hijriDate, AppPalette.headerDark)]);
}
