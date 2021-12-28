import 'package:anime_twist_flut/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player_header/video_player_header.dart';
import 'package:supercharged/supercharged.dart';

class DoubleTapLayer extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  final Function toggleUI;
  final bool isUiVisible;

  const DoubleTapLayer(
      {Key key,
      @required this.videoPlayerController,
      @required this.toggleUI,
      @required this.isUiVisible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Consumer(
        builder: (context, watch, child) {
          var prov = watch(doubleTapDurationProvider);
          var skipDuration = prov.value;
          return Row(
            children: [
              Container(
                color: Colors.transparent,
                height: double.infinity,
                width: width * 0.5,
                child: GestureDetector(
                  onDoubleTap: () async {
                    await videoPlayerController.seekTo(
                        await (videoPlayerController.position) -
                            skipDuration.seconds);
                    toggleUI();
                  },
                  onTap: toggleUI,
                ),
              ),
              Container(
                color: Colors.transparent,
                height: double.infinity,
                width: width * 0.5,
                child: GestureDetector(
                  onDoubleTap: () async {
                    await videoPlayerController.seekTo(
                        await (videoPlayerController.position) +
                            skipDuration.seconds);
                    toggleUI();
                  },
                  onTap: toggleUI,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
