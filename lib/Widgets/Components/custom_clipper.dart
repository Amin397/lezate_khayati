import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lezate_khayati/Utils/color_utils.dart';
import 'package:lezate_khayati/Utils/view_utils.dart';

class ClipPainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, height);
    path.lineTo(size.width, 0);

    /// [Top Left corner]
    var secondControlPoint = Offset(0, 0);
    var secondEndPoint = Offset(width * .2, height * .3);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    /// [Left Middle]
    var fifthControlPoint = Offset(width * .3, height * .5);
    var fiftEndPoint = Offset(width * .23, height * .6);
    path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy,
        fiftEndPoint.dx, fiftEndPoint.dy);

    /// [Bottom Left corner]
    var thirdControlPoint = Offset(0, height);
    var thirdEndPoint = Offset(width, height);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

class AnimatedThing extends StatefulWidget {
  final Stream<bool> stream;
  AnimatedThing({
    Key? key,
    required this.stream,
  }) : super(key: key);
  @override
  _AnimatedThingState createState() => _AnimatedThingState();
}

class _AnimatedThingState extends State<AnimatedThing>
    with TickerProviderStateMixin {
  bool isFinalState = false;
  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    this.widget.stream.listen((event) {
      if (event) {
        this._toggle();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggle() {
    setState(() {
      isFinalState = !isFinalState;
      if (!isFinalState)
        _controller.reverse(from: 1.0);
      else
        _controller.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 9.4,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, anim) {
            final double progress = _animation!.value;
            final double heightScaling = 0.405 + (0.337 - 0.405) * progress;
            final double height =
                MediaQuery.of(context).size.height * heightScaling;
            return ClipPath(
              clipper: BezierClipper(progress),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    height: height,
                  ),
                  ViewUtils.blurWidget(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorUtils.yellow.withOpacity(0.3),
                            ColorUtils.yellow.withOpacity(0.1),
                          ],
                        ),
                      ),
                      height: height,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class SecondAnimatedThing extends StatefulWidget {
  final Stream<bool>? stream;
  SecondAnimatedThing({
    Key? key,
    required this.stream,
  }) : super(key: key);
  @override
  _SecondAnimatedThingState createState() => _SecondAnimatedThingState();
}

class _SecondAnimatedThingState extends State<SecondAnimatedThing>
    with TickerProviderStateMixin {
  bool isFinalState = false;
  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    this.widget.stream?.listen((event) {
      if (this.mounted) {
        print(event);
        this._toggle();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggle() {
    if (this.mounted) {
      setState(() {
        isFinalState = !isFinalState;
        if (!isFinalState)
          _controller.reverse(from: 1.0);
        else
          _controller.forward(from: 0.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 9.4,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, anim) {
            final double progress = _animation!.value;
            final double heightScaling = 0.405 + (0.337 - 0.405) * progress;
            final double height =
                MediaQuery.of(context).size.height * heightScaling;
            return ClipPath(
              clipper: BezierClipper(progress),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    height: height,
                  ),
                  ViewUtils.blurWidget(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorUtils.yellow.withOpacity(0.3),
                            ColorUtils.yellow.withOpacity(0.1),
                          ],
                        ),
                      ),
                      height: height,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class BezierClipper extends CustomClipper<Path> {
  final double progress;
  BezierClipper(this.progress);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  @override
  Path getClip(Size size) {
    Path path = Path();
    final double artboardW = 414 + (0) * progress;
    double artboardH = 363.15 + (-61.45999999999998) * progress;
    // double artboardH = 350 / progress;
    final double _xScaling = size.width / artboardW;
    final double _yScaling = size.height / artboardH;
    path.lineTo((0 + (0) * progress) * _xScaling,
        (341.78499999999997 + (-123.94399999999996) * progress) * _yScaling);
    path.cubicTo(
      (0 + (0) * progress) * _xScaling,
      (341.78499999999997 + (-123.94399999999996) * progress) * _yScaling,
      (23.465 + (-4.3210000000000015) * progress) * _xScaling,
      (363.15099999999995 + (-97.231) * progress) * _yScaling,
      (71.55699999999999 + (-4.319999999999993) * progress) * _xScaling,
      (363.15099999999995 + (-97.231) * progress) * _yScaling,
    );
    path.cubicTo(
      (119.649 + (-4.319000000000017) * progress) * _xScaling,
      (363.15099999999995 + (-97.231) * progress) * _yScaling,
      (142.221 + (-29.465000000000003) * progress) * _xScaling,
      (300.186 + (-65.57499999999999) * progress) * _yScaling,
      (203.299 + (-29.462000000000018) * progress) * _xScaling,
      (307.21 + (-65.57499999999999) * progress) * _yScaling,
    );
    path.cubicTo(
      (264.377 + (-29.45900000000003) * progress) * _xScaling,
      (314.234 + (-65.57499999999999) * progress) * _yScaling,
      (282.66999999999996 + (-9.799999999999955) * progress) * _xScaling,
      (333.47299999999996 + (-31.781999999999982) * progress) * _yScaling,
      (338.412 + (-9.800000000000011) * progress) * _xScaling,
      (333.47299999999996 + (-31.781999999999982) * progress) * _yScaling,
    );
    path.cubicTo(
      (394.154 + (-9.800000000000068) * progress) * _xScaling,
      (333.47299999999996 + (-31.781999999999982) * progress) * _yScaling,
      (414 + (0) * progress) * _xScaling,
      (254.199 + (-52.22200000000001) * progress) * _yScaling,
      (414 + (0) * progress) * _xScaling,
      (254.199 + (-52.22200000000001) * progress) * _yScaling,
    );
    path.cubicTo(
      (414 + (0) * progress) * _xScaling,
      (254.199 + (-52.22200000000001) * progress) * _yScaling,
      (414 + (0) * progress) * _xScaling,
      (0 + (0) * progress) * _yScaling,
      (414 + (0) * progress) * _xScaling,
      (0 + (0) * progress) * _yScaling,
    );
    path.cubicTo(
      (414 + (0) * progress) * _xScaling,
      (0 + (0) * progress) * _yScaling,
      (2.1316282072803006e-14 + (0) * progress) * _xScaling,
      (0 + (0) * progress) * _yScaling,
      (2.1316282072803006e-14 + (0) * progress) * _xScaling,
      (0 + (0) * progress) * _yScaling,
    );
    path.cubicTo(
      (2.1316282072803006e-14 + (0) * progress) * _xScaling,
      (0 + (0) * progress) * _yScaling,
      (0 + (0) * progress) * _xScaling,
      (341.78499999999997 + (-123.94399999999996) * progress) * _yScaling,
      (0 + (0) * progress) * _xScaling,
      (341.78499999999997 + (-123.94399999999996) * progress) * _yScaling,
    );
    return path;
  }
}
