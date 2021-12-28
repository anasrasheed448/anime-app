import 'package:flutter/material.dart';

class RecentlyWatchedText extends StatelessWidget {
  const RecentlyWatchedText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: Text(
        'Recently Watched'.toUpperCase(),
        style: TextStyle(
          letterSpacing: 1.25,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
