import 'package:flutter/material.dart';

class FadeThroughIndexedStack extends StatefulWidget {
  FadeThroughIndexedStack({Key key, this.index, this.children})
      : super(key: key);

  final int index;
  final List<Widget> children;

  @override
  _FadeThroughIndexedStackState createState() =>
      _FadeThroughIndexedStackState();
}

class _FadeThroughIndexedStackState extends State<FadeThroughIndexedStack>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _scaleAnimation = Tween(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FadeThroughIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      setState(() {
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Opacity(
        opacity: _scaleAnimation.value,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: IndexedStack(
            index: widget.index,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
