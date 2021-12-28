import 'dart:async';

import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:anime_twist_flut/pages/discover_page/DiscoverPage.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritesPage.dart';
import 'package:anime_twist_flut/pages/homepage/HomePage.dart';
import 'package:anime_twist_flut/pages/root_window/root_window_landscape.dart';
import 'package:anime_twist_flut/pages/root_window/root_window_portrait.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:anime_twist_flut/services/AppUpdateService.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_links/uni_links.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

class RootWindow extends StatefulWidget {
  RootWindow({Key key}) : super(key: key);

  @override
  _RootWindowState createState() => _RootWindowState();
}

class _RootWindowState extends State<RootWindow> with TickerProviderStateMixin {
  StreamSubscription _uriSub;
  PageController _pageController;

  var pages = [HomePage(), FavouritesPage(), DiscoverPage(), SettingsPage()];
  final indexProvider = StateProvider<int>((ref) => 0);
  final GlobalKey pageViewKey = GlobalKey(debugLabel: 'page_view');

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
    _uriSub.cancel();
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0, keepPage: true)
      ..addListener(() {
        FocusScope.of(context).unfocus();
      });

    // Check and launch an anime page on initial app launch, this is needed when
    // the app is not running in the background and the user clicks a relevant
    // link.
    _checkURIAndLaunchPage();
    // Check and launch a page every times a user clicks on a relevant link.
    _uriSub = getLinksStream().listen((String url) {
      _checkURIAndLaunchPage(url);
    });

    AppUpdateService().checkUpdate(context: context);
  }

  Future _checkURIAndLaunchPage([String url]) async {
    // Wait for initData() to finish fetching and making all the anime models
    while (TwistApiService.allTwistModel.isEmpty) {
      await Future.delayed(200.milliseconds);
    }

    try {
      var recievedUrl = (url ?? await getInitialLink()) ?? '';
      var regex = RegExp(r'https://twist.moe/a/(.*)/+(.*)');
      Iterable<Match> matches = regex.allMatches(recievedUrl);
      var slug = matches.isNotEmpty ? matches.elementAt(0).group(1) : '';
      var episodeNum =
          matches.isNotEmpty ? int.parse(matches.elementAt(0).group(2)) : null;

      if (slug.isNotEmpty) {
        for (var i = 0; i < TwistApiService.allTwistModel.length; i++) {
          var twistModel = TwistApiService.allTwistModel.elementAt(i);
          if (twistModel.slug == slug) {
            // If the current page is home page, then launch the anime page
            // normally, but if its any other page, then launch replaced as we
            // dont want to nest a lot of pages, if users spams the same link
            // again and again.
            if (ModalRoute.of(context).isCurrent) {
              await Transitions.slideTransition(
                context: context,
                pageBuilder: () => AnimeInfoPage(
                  twistModel: twistModel,
                  isFromRecentlyWatched: episodeNum > 1 ? true : false,
                  lastWatchedEpisodeNum: episodeNum,
                ),
              );
            } else {
              await Transitions.slideTransitionReplaced(
                context: context,
                pageBuilder: () => AnimeInfoPage(
                  twistModel: twistModel,
                  isFromRecentlyWatched: episodeNum > 1 ? true : false,
                  lastWatchedEpisodeNum: episodeNum,
                ),
              );
            }
          }
        }
      }
    } on PlatformException {
      // handle later
    }
  }

  @override
  Widget build(BuildContext context) {
    return DeviceOrientationBuilder(
      portrait: RootWindowPortrait(
        indexProvider: indexProvider,
        pageController: _pageController,
        pages: pages,
        pageViewKey: pageViewKey,
      ),
      landscape: RootWindowLandscape(
        indexProvider: indexProvider,
        pageController: _pageController,
        pages: pages,
        pageViewKey: pageViewKey,
      ),
    );
  }
}
