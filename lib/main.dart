// Flutter imports:
import 'dart:convert';

import 'package:anime_twist_flut/constants.dart';
import 'package:anime_twist_flut/exceptions/NoInternetException.dart';
import 'package:anime_twist_flut/exceptions/TwistDownException.dart';
import 'package:anime_twist_flut/pages/error_page/ErrorPage.dart';
import 'package:anime_twist_flut/pages/root_window/root_window.dart';
import 'package:anime_twist_flut/providers.dart';
import 'package:anime_twist_flut/providers/NetworkInfoProvider.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/theme.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:anime_twist_flut/widgets/InitialLoadingScreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;

void main() async {
  CustomImageCache();
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await loadinterstitialAd();
  runApp(ProviderScope(child: MainWidget()));
}

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    var imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 1024; // 1 GB
    imageCache.maximumSize = 1000; // 1000 Items
    return imageCache;
  }
}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget>
    with SingleTickerProviderStateMixin {
  final _initDataProvider = FutureProvider.autoDispose((ref) async {
    ref.maintainState = true;

    // android: MAKE the navbar transparent, the actual color will be set in
    // styles.xml
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ));

    // Incase we refresh on an error
    Get.delete<TwistApiService>();

    await ref.read(sharedPreferencesProvider).initialize();

    await ref.read(accentProvider).initalize();
    var twistApiService = Get.put(TwistApiService());
    await NetworkInfoProvider().throwIfNoNetwork();
    await twistApiService.setTwistModels();
    await ref.read(recentlyWatchedProvider).initialize();
    await ref.read(toWatchProvider).initialize();
    await ref.read(favouriteAnimeProvider).initialize();

    await ref.read(zoomFactorProvider).initalize();
    await ref.read(doubleTapDurationProvider).initalize();
    await ref.read(playbackSpeeedProvider).initalize();
    await ref.read(tvInfoProvider).initialize();
    showEpisodes = await getStatusValue();
  });
  static getStatusValue() async {
    try {
      final res = await http.get('https://api.npoint.io/30952587e8c8ecc58e93');
      var decodeData = jsonDecode(res.body) as Map<String, dynamic>;
      if (decodeData['Show'].toString().contains('true')) return true;
    } catch (e) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer(
      builder: (context, watch, child) {
        var accentColor = watch(accentProvider).value;
        return Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
          },
          child: MaterialApp(
            home: watch(_initDataProvider).when(
              data: (v) => Consumer(
                builder: (context, watch, child) => RootWindow(),
              ),
              loading: () => InitialLoadingScreen(),
              error: (e, s) {
                var message = 'Whoops! An error occured';
                if (e is NoInternetException) {
                  message =
                      'Looks like you are not connected to the internet. Please reconnect and try again';
                } else if (e is TwistDownException) {
                  message =
                      'Looks like twist.moe is down. Please try again later';
                }
                return ErrorPage(
                  message: message,
                  e: e,
                  stackTrace: s,
                  onRefresh: () => context.refresh(_initDataProvider),
                );
              },
            ),
            darkTheme: getDarkTheme(accentColor),
            themeMode: ThemeMode.dark,
          ),
        );
      },
    );
  }
}
