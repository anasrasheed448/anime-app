import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as s;

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.portraitUp,
    //  DeviceOrientation.portraitDown,
    //]);
    return s.Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Colors.black,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
