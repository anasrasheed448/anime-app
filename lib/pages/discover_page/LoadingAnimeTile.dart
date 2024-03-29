import 'package:anime_twist_flut/widgets/custom_shimmer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class LoadingAnimeTile extends StatelessWidget {
  const LoadingAnimeTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.portraitUp,
    //  DeviceOrientation.portraitDown,
    //]);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: EdgeInsets.zero,
        child: CustomShimmer(),
      ),
    );
  }
}
