import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class DescriptionWidget extends StatefulWidget {
  final TwistModel twistModel;
  final KitsuModel kitsuModel;

  DescriptionWidget({
    Key key,
    this.twistModel,
    this.kitsuModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DescriptionWidgetState();
  }
}

class _DescriptionWidgetState extends State<DescriptionWidget>
    with TickerProviderStateMixin {
  Animation<double> height;
  bool isNotExpanded = true;
  AnimationController _controller;
  Animation<double> _sizeAnimation;
  GlobalKey _keyFoldChild;
  RenderBox _renderBox;

  void _afterLayout(_) async {
    if (widget.kitsuModel == null) return;
    _renderBox = _keyFoldChild.currentContext.findRenderObject();
    _sizeAnimation = Tween<double>(
      end: _renderBox.size.height,
      begin: _renderBox.size.height > 150 ? 150.0 : _renderBox.size.height,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    setState(() {});
  }

  void toggleExpand() {
    setState(() {
      isNotExpanded = !isNotExpanded;
    });
    playAnim();
  }

  void playAnim() {
    if (isNotExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void initState() {
    _keyFoldChild = GlobalKey();
    _controller = AnimationController(
      vsync: this,
      duration: 300.milliseconds,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterLayout(_);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.portraitUp,
    //  DeviceOrientation.portraitDown,
    //]);
    if (widget.kitsuModel == null) return Container();
    return Container(
      margin: EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return DeviceOrientationBuilder(
                portrait: ClipRect(
                  child: SizedOverflowBox(
                    size: Size(double.infinity, _sizeAnimation?.value ?? 150.0),
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                ),
                landscape: child,
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              alignment: Alignment.centerLeft,
              key: _keyFoldChild,
              child: Text(
                widget.kitsuModel.description,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white30,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Visibility(
            visible: ((_renderBox?.size?.height ?? 151) > 150) &&
                MediaQuery.of(context).orientation == Orientation.portrait,
            child: Container(
              margin: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 12.0,
                bottom: 0.0,
              ),
              child: GestureDetector(
                onTap: () {
                  toggleExpand();
                },
                child: Text(
                  isNotExpanded
                      ? 'Show More'.toUpperCase()
                      : 'Show Less'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
