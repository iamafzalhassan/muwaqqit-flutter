import 'package:flutter/cupertino.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.radius = 10, this.color});

  final double radius;

  final Color? color;

  @override
  Widget build(BuildContext context) => CupertinoActivityIndicator(color: color, radius: radius);
}
