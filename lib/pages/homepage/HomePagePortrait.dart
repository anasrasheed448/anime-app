import 'package:flutter/material.dart';

class HomePagePortrait extends StatelessWidget {
  final List<Widget> widgets;

  const HomePagePortrait({Key key, @required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => widgets.elementAt(index),
      itemCount: widgets.length,
    );
  }
}
