import 'package:flutter/material.dart';

class InitialLoadingScreen extends StatelessWidget {
  const InitialLoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 125,
              height: 125,
            ),
            SizedBox(
              width: 150,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
