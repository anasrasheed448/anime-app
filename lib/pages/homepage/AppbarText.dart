import 'package:flutter/material.dart';

class AppbarText extends StatelessWidget {
  const AppbarText({Key key, this.custom = 'Anime'}) : super(key: key);

  final String custom;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: '$custom.',
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
          TextSpan(
            text: 'now',
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
