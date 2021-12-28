// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:anime_twist_flut/pages/settings_page/DoubleTapDurationSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/PlaybackSpeedSetting.dart';
import 'package:anime_twist_flut/pages/settings_page/ZoomFactorSetting.dart';
import 'package:anime_twist_flut/pages/watch_page/DoubleTapLayer.dart';
import 'package:anime_twist_flut/animations/TwistLoadingWidget.dart';
import 'package:anime_twist_flut/pages/watch_page/LaunchExternalPlayerButton.dart';
import 'package:anime_twist_flut/pages/watch_page/shelf_proxy.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_android_pip/flutter_android_pip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supercharged/supercharged.dart';
import 'package:video_player_header/video_player_header.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

// Project imports:
import '../../models/EpisodeModel.dart';
import '../../models/kitsu/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../secrets.dart';
import '../../utils/TimeUtils.dart';
import '../../utils/watch_page/CryptoUtils.dart';
import 'package:wakelock/wakelock.dart';
import 'package:anime_twist_flut/providers.dart';

enum VideoMode {
  Normal,
  Stretched,
  Fill,
}

class WatchPage extends StatefulWidget {
  final EpisodeModel episodeModel;
  final List<EpisodeModel> episodes;
  final bool isFromPrevEpisode;
  final ChangeNotifierProvider<EpisodesWatchedProvider> episodesWatchedProvider;

  final TwistModel twistModel = Get.find<TwistModel>();
  final KitsuModel kitsuModel = Get.find<KitsuModel>();

  WatchPage({
    @required this.episodeModel,
    @required this.episodes,
    this.isFromPrevEpisode = false,
    @required this.episodesWatchedProvider,
  });

  @override
  _WatchPageState createState() => _WatchPageState();
}

class _WatchPageState extends State<WatchPage> with WidgetsBindingObserver {
  VideoPlayerController _controller;
  VideoMode videoMode = VideoMode.Normal;
  bool isUIvisible = false;
  bool isPictureInPicture = false;
  bool isTouchingSlider = false;
  bool shouldResetOrientation = true;
  String _duration;
  double currentPosition;
  String currentPositionStr;
  Future _init;
  Timer t;
  HttpServer req;

  String _vidUrl;
  Map<String, String> _headers;

  String getCdn() {
    if (widget.twistModel.ongoing) {
      if (widget.episodes.length - widget.episodeModel.number < 10) {
        return 'https://air-cdn.twist.moe';
      }
    }
    return 'https://cdn.twist.moe';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.inactive:
          break;
        case AppLifecycleState.resumed:
          isPictureInPicture = false;
          break;
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    WidgetsBinding.instance.addObserver(this);
    Wakelock.toggle(enable: true);

    _headers = {
      'Referer':
          'https://twist.moe/a/${widget.twistModel.slug}/${widget.episodeModel.number}'
    };

    if (key.isNotEmpty) {
      var sourceSuffix =
          CryptoUtils.decryptAESCryptoJS(widget.episodeModel.source, key);

      if (sourceSuffix.startsWith('https')) {
        _vidUrl = Uri.parse(sourceSuffix).toString();
      } else {
        _vidUrl = Uri.parse(getCdn() + sourceSuffix).toString();
        // dont ask me why, twist servers are wack
        _vidUrl = _vidUrl.replaceAll('\%5B', '[').replaceAll('\%5D', ']');
      }

      _controller = VideoPlayerController.network(_vidUrl, headers: _headers)
        ..initialize().then((_) {
          setState(() {
            play();
            _duration = TimeUtils.secondsToHumanReadable(
                _controller.value.duration.inSeconds);
          });
          showUI();
        });

      _controller.addListener(() {
        setState(() {
          currentPosition = _controller.value.position.inSeconds.toDouble();
          currentPositionStr = TimeUtils.secondsToHumanReadable(
              _controller.value.position.inSeconds);
        });
      });

      t = Timer(5.seconds, () {
        if (!isTouchingSlider) {
          setState(() {
            isUIvisible = false;
          });
        }
      });

      _init = init();
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    if (shouldResetOrientation) SystemChrome.setPreferredOrientations([]);
    WidgetsBinding.instance.removeObserver(this);
    Wakelock.toggle(enable: false);
    _controller.dispose();
    req.close();
    super.dispose();
  }

  void play() {
    _controller.play();
  }

  void pause() {
    _controller.pause();
  }

  void togglePlay() {
    setState(() {
      _controller.value.isPlaying ? pause() : play();
    });
  }

  void hideUIAfterWait() async {
    if (isUIvisible) {
      t.cancel();
      t = Timer(5.seconds, () {
        if (!isTouchingSlider) {
          setState(() {
            isUIvisible = false;
          });
        }
      });
    }
  }

  void showUI() async {
    setState(() {
      SystemChrome.setEnabledSystemUIOverlays([]);
      isUIvisible = true;
    });
    hideUIAfterWait();
  }

  void addEpisodeToRecentlyWatched(BuildContext context) {
    context.read(recentlyWatchedProvider).addToLastWatched(
          episodeModel: widget.episodes
              .elementAt(widget.episodes.indexOf(widget.episodeModel) + 1),
          twistModel: widget.twistModel,
          kitsuModel: widget.kitsuModel,
        );
  }

  void goToNextEpisode(BuildContext context) {
    shouldResetOrientation = false;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: 0.seconds,
        pageBuilder: (context, anim, anime2) => WatchPage(
          episodeModel: widget.episodes
              .elementAt(widget.episodes.indexOf(widget.episodeModel) + 1),
          episodes: widget.episodes,
          isFromPrevEpisode: true,
          episodesWatchedProvider: widget.episodesWatchedProvider,
        ),
      ),
    );
  }

  void setEpisodeAsCompleted(BuildContext context, bool isFromCheckBox) {
    final provider = context.read(widget.episodesWatchedProvider);

    if (isFromCheckBox) {
      provider.toggleWatched(
        widget.episodeModel.number,
      );
    } else {
      if (!provider.isWatched(widget.episodeModel.number)) {
        provider.toggleWatched(
          widget.episodeModel.number,
        );
      }
    }
    setState(() {});
  }

  // Most intros/outros are 85 seconds so skip that much time.
  Future skipIntro() async {
    await _controller
        .seekTo(Duration(seconds: (await _controller.position).inSeconds + 85));
  }

  double getScreenAspectRatio(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return size.aspectRatio;
  }

  void setNextVideoMode() {
    setState(() {
      switch (videoMode) {
        case VideoMode.Normal:
          videoMode = VideoMode.Stretched;
          break;
        case VideoMode.Stretched:
          videoMode = VideoMode.Fill;
          break;
        case VideoMode.Fill:
          videoMode = VideoMode.Normal;
          break;
      }
    });
  }

  IconData getVideoModeIcon() {
    switch (videoMode) {
      case VideoMode.Stretched:
        return FontAwesomeIcons.expandAlt;
        break;
      case VideoMode.Fill:
        return FontAwesomeIcons.compress;
        break;
      case VideoMode.Normal:
      default:
        return FontAwesomeIcons.expand;
        break;
    }
  }

  double getAspectRatio(BuildContext context) {
    switch (videoMode) {
      case VideoMode.Stretched:
        return getScreenAspectRatio(context);
        break;
      case VideoMode.Fill:
      case VideoMode.Normal:
      default:
        return _controller.value.aspectRatio;
        break;
    }
  }

  Future setSpeed(double speed) async {
    await _controller.setPlaybackSpeed(speed);
  }

  Future init() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await Wakelock.toggle(enable: true);
    req = await shelf_io.serve(
      proxyHandler(_vidUrl, headers: _headers),
      'localhost',
      8080,
    );
    while (!(_controller?.value?.initialized ?? false)) {
      await Future.delayed(100.milliseconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    var containerHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.05
            : MediaQuery.of(context).size.height * 0.1;

    if (key.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "A decryption key was not provided while building. Episode can't be played",
                    textAlign: TextAlign.center),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Go back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          shouldResetOrientation = true;
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: _init,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 24.0,
                    ),
                    widget.isFromPrevEpisode
                        ? Text('Loading Next Episode')
                        : Text('Loading Episode'),
                  ],
                ),
              );
            }
            return Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Consumer(
                    builder: (context, watch, child) {
                      var playbackSpeed = watch(playbackSpeeedProvider).value;
                      setSpeed(playbackSpeed);
                      return Consumer(
                        builder: (context, watch, child) {
                          var zoom = watch(zoomFactorProvider);
                          return Center(
                            child: Transform.scale(
                              scale:
                                  videoMode == VideoMode.Fill ? zoom.value : 1,
                              child: AspectRatio(
                                aspectRatio: getAspectRatio(context),
                                child: VideoPlayer(
                                  _controller,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Positioned.fill(
                    child: DoubleTapLayer(
                      videoPlayerController: _controller,
                      isUiVisible: isUIvisible,
                      toggleUI: showUI,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: 300.milliseconds,
                    opacity: _controller.value.isBuffering ? 1.0 : 0.0,
                    child: Transform.scale(
                      scale: 0.5,
                      child: Center(
                        child: RotatingPinLoadingAnimation(),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: 300.milliseconds,
                    opacity: isUIvisible ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: !isUIvisible,
                      child: Visibility(
                        visible: !isPictureInPicture,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: containerHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.transparent,
                                    Colors.black38,
                                    Colors.black87,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.navigate_before,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              right: 20.0,
                                            ),
                                            child: AutoSizeText(
                                              widget.twistModel.title,
                                              maxLines: 2,
                                              minFontSize: 5.0,
                                              maxFontSize: 25.0,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.settings,
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          24, 24, 24, 16),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        child:
                                                            PlaybackSpeedSetting(),
                                                      ),
                                                      Container(
                                                        child:
                                                            ZoomFactorSetting(),
                                                      ),
                                                      Container(
                                                        child:
                                                            DoubleTapDurationSetting(),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.picture_in_picture_rounded,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              isPictureInPicture = true;
                                              FlutterAndroidPip
                                                  .enterPictureInPictureMode;
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        child: Consumer(
                                          builder: (context, watch, child) {
                                            final prov = watch(
                                                widget.episodesWatchedProvider);
                                            return Checkbox(
                                              value: prov.isWatched(
                                                widget.episodeModel.number,
                                              ),
                                              checkColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              onChanged: (val) {
                                                setEpisodeAsCompleted(
                                                    context, true);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 15.0,
                                        ),
                                        child: AutoSizeText(
                                          'S' +
                                              widget.twistModel.season
                                                  .toString() +
                                              ' | E' +
                                              widget.episodeModel.number
                                                  .toString(),
                                          maxLines: 1,
                                          minFontSize: 5.0,
                                          maxFontSize: 25.0,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: containerHeight,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.transparent,
                                    Colors.black38,
                                    Colors.black87,
                                  ],
                                  end: Alignment.bottomCenter,
                                  begin: Alignment.topCenter,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Container(
                                          width: 35.0,
                                          child: IconButton(
                                            icon: Icon(
                                              _controller.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            ),
                                            onPressed: () {
                                              togglePlay();
                                            },
                                            iconSize: 22.5,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 35,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.skip_next_outlined,
                                          ),
                                          iconSize: 22.5,
                                          onPressed: widget.episodes.last ==
                                                  widget.episodeModel
                                              ? null
                                              : () {
                                                  setEpisodeAsCompleted(
                                                      context, false);
                                                  addEpisodeToRecentlyWatched(
                                                      context);
                                                  goToNextEpisode(context);
                                                },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          width: 35,
                                          child: IconButton(
                                            icon: Icon(
                                                Icons.fast_forward_outlined),
                                            onPressed: () => skipIntro(),
                                            iconSize: 22.5,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        currentPositionStr,
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: _controller
                                          .value.position.inSeconds
                                          .toDouble(),
                                      activeColor:
                                          Theme.of(context).accentColor,
                                      inactiveColor: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.5),
                                      min: 0,
                                      max: _controller.value.duration.inSeconds
                                          .toDouble(),
                                      label: TimeUtils.secondsToHumanReadable(
                                          _controller.value.position.inSeconds),
                                      divisions:
                                          _controller.value.duration.inSeconds,
                                      onChanged: (pos) {
                                        setState(
                                          () {
                                            _controller.seekTo(pos.seconds);
                                          },
                                        );
                                      },
                                      onChangeStart: (val) => setState(
                                          () => isTouchingSlider = true),
                                      onChangeEnd: (val) => setState(() {
                                        isTouchingSlider = false;
                                        hideUIAfterWait();
                                      }),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Text(_duration),
                                      ),
                                      Container(
                                        width: 35,
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: IconButton(
                                          icon: Icon(getVideoModeIcon()),
                                          iconSize: 18,
                                          onPressed: () {
                                            setNextVideoMode();
                                          },
                                        ),
                                      ),
                                      LaunchExternalPlayerButton(
                                        url:
                                            'http://${req.address.host}:${req.port}',
                                        referer: _headers.values.first,
                                        pause: pause,
                                      ),
                                      SizedBox(width: 8.0),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
