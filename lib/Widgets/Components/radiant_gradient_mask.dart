import 'package:flutter/material.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';

class RadiantGradientMask extends StatelessWidget {
  const RadiantGradientMask({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.bottomLeft,
          radius: 0.5,
          colors: <Color>[
            ColorUtils.yellow.shade50,
            ColorUtils.yellow.shade600,
          ],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
