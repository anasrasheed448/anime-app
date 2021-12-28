// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:supercharged/supercharged.dart';

class SlideInAnimation extends StatefulWidget {
  SlideInAnimation({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _SlideInAnimationState createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> axisAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: 500.milliseconds);
    axisAnimation = (10.0).tweenTo(0.0).animate(
          CurvedAnimation(curve: Curves.ease, parent: _animationController),
        );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant SlideInAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: axisAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, axisAnimation.value),
        child: widget.child,
      ),
    );
  }
}
