import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lezate_khayati/Widgets/Components/custom_clipper.dart';

class BezierContainer extends StatelessWidget {
  final Color color;

  BezierContainer({
    Key? key,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 3.5,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height * .5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.opacity == 1.0 ? color.withOpacity(0.2) : color,
                color.opacity == 1.0
                    ? color.withOpacity(0.5)
                    : color.withOpacity(color.opacity * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SinglePageAppBarBackGround extends StatelessWidget {
  Color? color = Colors.grey.shade200.withOpacity(0.2);

  SinglePageAppBarBackGround({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -pi / 3.5,
        child: ClipPath(
          clipper: ClipPainter(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
