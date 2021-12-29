import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class HomePagePortrait extends StatelessWidget {
  final List<Widget> widgets;

  const HomePagePortrait({Key key, @required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ListView.builder(
      itemBuilder: (context, index) => widgets.elementAt(index),
      itemCount: widgets.length,
    );
  }
}
