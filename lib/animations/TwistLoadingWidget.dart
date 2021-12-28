import 'package:flutter/material.dart';
import 'dart:math' show pi;

class RotatingPinLoadingAnimation extends StatefulWidget {
  RotatingPinLoadingAnimation({Key key}) : super(key: key);

  @override
  _RotatingPinLoadingAnimationState createState() =>
      _RotatingPinLoadingAnimationState();
}

class _RotatingPinLoadingAnimationState
    extends State<RotatingPinLoadingAnimation> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> angleAnimation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    angleAnimation = Tween(begin: 0.0, end: (2 * pi)).animate(
      CurvedAnimation(curve: Curves.linear, parent: animationController),
    );
    animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: angleAnimation,
      builder: (context, child) => Transform.rotate(
        angle: angleAnimation.value,
        alignment: Alignment.topCenter,
        child: CustomPaint(
          painter: PinPainter(),
          willChange: false,
        ),
      ),
    );
  }
}

class PinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var circleRadius = 10.0;

    var pinHeadPainter = Paint()..color = Colors.white;

    var pinTrianglePainter = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    var bgCirclePainter = Paint()..color = Colors.black.withOpacity(0.7);

    canvas.drawCircle(
        Offset(centerX, centerY), circleRadius * 5, bgCirclePainter);
    canvas.drawPath(getTrianglePath(circleRadius), pinTrianglePainter);
    canvas.drawCircle(Offset(centerX, centerY), circleRadius, pinHeadPainter);
  }

  Path getTrianglePath(double r) {
    return Path()
      ..moveTo(0, r * -3)
      ..lineTo(r / 1.5, 0)
      ..lineTo(-r / 1.5, 0)
      ..lineTo(0, r * -3)
      ..close();
  }

  @override
  bool shouldRepaint(PinPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(PinPainter oldDelegate) => false;
}
