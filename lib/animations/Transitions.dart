// Flutter imports:
import 'package:flutter/material.dart';

class Transitions {
  static Future slideTransition({
    BuildContext context,
    Function pageBuilder,
  }) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, anim, anim2) => pageBuilder(),
        transitionsBuilder: (context, anim, secondAnim, child) {
          var tween = Tween(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          );
          var curvedAnimation = CurvedAnimation(
            parent: anim,
            curve: Curves.ease,
          );
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }

  static Future slideTransitionReplaced({
    BuildContext context,
    Function pageBuilder,
  }) async {
    await Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (context, anim, anim2) => pageBuilder(),
        transitionsBuilder: (context, anim, secondAnim, child) {
          var tween = Tween(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          );
          var curvedAnimation = CurvedAnimation(
            parent: anim,
            curve: Curves.ease,
          );
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
      ),
    );
  }
}
