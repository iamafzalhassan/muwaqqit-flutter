import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:muwaqqit/core/theme/app_palette.dart';
import 'package:muwaqqit/core/theme/app_sizes.dart';

class SecondsRing extends StatelessWidget {
  const SecondsRing({super.key, required this.isClockwise, required this.diameter, required this.activeSeconds, required this.activeColor, required this.child});

  static const double _dotRatio = 0.035;

  final bool isClockwise;

  final double diameter;

  final int activeSeconds;

  final Color activeColor;

  final Widget child;

  Widget _dot(int second, double radius, double size, bool reduceMotion) {
    final angle = (isClockwise ? second : -second) * math.pi / 30 - math.pi / 2;
    return Positioned(
      left: radius * (1 + math.cos(angle)),
      top: radius * (1 + math.sin(angle)),
      child: AnimatedContainer(
        curve: Curves.easeOut,
        decoration: BoxDecoration(color: second < activeSeconds ? activeColor : AppPalette.dotInactive, shape: BoxShape.circle),
        duration: reduceMotion ? Duration.zero : AppSizes.dotFade,
        height: size,
        width: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = diameter * _dotRatio;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return SizedBox.square(
      dimension: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ExcludeSemantics(
            child: SizedBox.square(
              dimension: diameter,
              child: Stack(children: [for (var second = 0; second < Duration.secondsPerMinute; second++) _dot(second, (diameter - size) / 2, size, reduceMotion)]),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
