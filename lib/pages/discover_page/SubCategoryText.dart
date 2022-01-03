import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class SubCategoryText extends StatelessWidget {
  const SubCategoryText({
    Key key,
    this.text,
    this.padding,
  }) : super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.portraitUp,
    //  DeviceOrientation.portraitDown,
    //]);
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
