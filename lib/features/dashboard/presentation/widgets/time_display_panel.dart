import 'package:flutter/material.dart';
import 'package:muwaqqit/core/theme/app_font.dart';
import 'package:muwaqqit/core/theme/app_palette.dart';
import 'package:muwaqqit/core/theme/app_sizes.dart';
import 'package:muwaqqit/features/dashboard/presentation/widgets/seconds_ring.dart';

class TimeDisplayPanel extends StatelessWidget {
  const TimeDisplayPanel({super.key, required this.isClockwise, this.labelLetterSpacing, required this.secondsValue, required this.labelText, required this.primary, required this.secondary, required this.color, required this.dotColor});

  static const TextStyle _numberStyle = TextStyle(fontFamily: AppFont.googleSansRegular, fontSize: AppSizes.numberFontSize, fontWeight: FontWeight.w300, height: 1);

  final bool isClockwise;

  final double? labelLetterSpacing;

  final int secondsValue;

  final String labelText;
  final String primary;
  final String secondary;

  final Color color;
  final Color dotColor;

  Widget _number(String text, double height) => SizedBox(
    height: height,
    child: FittedBox(
      child: Stack(
        children: [
          Text(text, style: _numberStyle.copyWith(color: AppPalette.textDark)),
          ExcludeSemantics(
            child: Text(
              text,
              style: _numberStyle.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = AppSizes.numberStroke
                  ..color = AppPalette.textDark,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppSizes.panelGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.textPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              labelText,
              maxLines: 1,
              style: TextStyle(color: AppPalette.textDark, fontFamily: AppFont.productSansThin, fontSize: AppSizes.labelFontSize, fontWeight: FontWeight.w300, letterSpacing: labelLetterSpacing),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.panelGap),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final gap = constraints.maxHeight * 0.03;
              final diameter = ((constraints.maxHeight - gap) / 1.5).clamp(0.0, constraints.maxWidth * 0.78);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _number(primary, diameter / 2),
                  SizedBox(height: gap),
                  SecondsRing(activeColor: dotColor, activeSeconds: secondsValue, diameter: diameter, isClockwise: isClockwise, child: _number(secondary, diameter / 2)),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.panelGap),
      ],
    ),
  );
}
