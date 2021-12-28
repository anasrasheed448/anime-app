import 'package:flutter/material.dart';
import 'package:android_intent/android_intent.dart';

class LaunchExternalPlayerButton extends StatelessWidget {
  const LaunchExternalPlayerButton({
    Key key,
    @required this.url,
    @required this.referer,
    @required this.pause,
  }) : super(key: key);

  final String url;
  final String referer;
  final VoidCallback pause;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      margin: EdgeInsets.only(bottom: 3),
      child: IconButton(
        icon: Icon(
          Icons.launch_outlined,
        ),
        iconSize: 18,
        onPressed: () async {
          pause();
          var intent =
              AndroidIntent(action: 'action_view', data: url, type: 'video/*');
          await intent.launch();
        },
      ),
    );
  }
}
