import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DeviceOrientationBuilder extends StatelessWidget {
  const DeviceOrientationBuilder({
    Key key,
    @required this.portrait,
    @required this.landscape,
  }) : super(key: key);

  final Widget portrait;
  final Widget landscape;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return portrait;
    }
    return landscape;
  }
}
