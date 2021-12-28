import 'package:anime_twist_flut/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension ZoomOnFocus on Widget {
  Widget zoomOnFocusWidget(
      {bool shouldZoom = true,
      bool shouldRotateX = true,
      bool shouldRotateY = false}) {
    return Consumer(
      builder: (context, watch, child) {
        var isTv = watch(tvInfoProvider).isTV ?? true;
        if (isTv) return child;
        return this;
      },
      child: __ZoomOnTrue(
        shouldZoom: shouldZoom,
        shouldRotateX: shouldRotateX,
        shouldRotateY: shouldRotateY,
        child: this,
      ),
    );
  }
}

class __ZoomOnTrue extends StatefulWidget {
  __ZoomOnTrue(
      {Key key,
      @required this.child,
      this.shouldZoom = true,
      this.shouldRotateX = true,
      this.shouldRotateY = false})
      : super(key: key);

  final Widget child;
  final bool shouldZoom;
  final bool shouldRotateX;
  final bool shouldRotateY;

  @override
  __ZoomOnTrueState createState() => __ZoomOnTrueState();
}

class __ZoomOnTrueState extends State<__ZoomOnTrue>
    with TickerProviderStateMixin {
  AnimationController _zoomController;
  Animation _zoomAnimation;
  bool _hasFocus = false;

  @override
  void initState() {
    _zoomController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _zoomAnimation = Tween(begin: 1.0, end: 1.2).animate(_zoomController);
    super.initState();
  }

  Future zoom() async {
    await _zoomController.forward();
  }

  Future unZoom() async {
    await _zoomController.reverse();
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_hasFocus) {
        zoom();
      } else {
        unZoom();
      }
    });
    return FocusableActionDetector(
      onFocusChange: (value) {
        setState(() {
          _hasFocus = value;
        });
      },
      child: AnimatedBuilder(
        animation: _zoomAnimation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(widget.shouldRotateY ? _zoomAnimation.value * 2 - 2 : 0)
              ..rotateX(
                  widget.shouldRotateX ? _zoomAnimation.value * 1 - 1 : 0),
            child: Transform.scale(
              scale: widget.shouldZoom ? _zoomAnimation.value : 1.0,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
