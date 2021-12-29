import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuAnimeListModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/pages/discover_page/KitsuAnimeRow.dart';
import 'package:anime_twist_flut/pages/discover_page/SubCategoryText.dart';
import 'package:anime_twist_flut/pages/homepage/HomePageLandscape.dart';
import 'package:anime_twist_flut/pages/homepage/HomePagePortrait.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuApiService.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tuple/tuple.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ViewAllAnimeCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  //final BannerAd _bottomBannerAd;

  static var myBanner;
  static bool _isAdloaded = false;

  void initBanner() {
    print('initad');
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (v) {
          setState(() {
            _isAdloaded = true;
          });
          print('loaded');
        },
        onAdFailedToLoad: (ad, error) => print('failde'),
      ),
    );

    myBanner.load();
  }

  @override
  void initState() {
    super.initState();
    initBanner();
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose();
  }

  final List<Widget> widgets = [
    // RecentlyWatchedSlider(),

    SubCategoryText(
      text: 'Top Airing',
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
    ),
    KitsuAnimeRow(
      futureProvider: FutureProvider<
          Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
        (ref) async => await KitsuApiService.getFanFavourites(),
      ),
    ),
    SubCategoryText(
      text: 'Top Anime Movies',
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ),
    ),
    KitsuAnimeRow(
      futureProvider: FutureProvider<
          Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
        (ref) async => await KitsuApiService.getTopMovies(),
      ),
    ),
    if (_isAdloaded)
      Container(
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
        child: AdWidget(
          ad: myBanner,
        ),
      ),
    SubCategoryText(
      text: 'Popular Anime',
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ),
    ),
    KitsuAnimeRow(
      futureProvider: FutureProvider<
          Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
        (ref) async => await KitsuApiService.getAllTimePopularAnimes(),
      ),
    ),
    Padding(
      padding: EdgeInsets.only(
        top: 12.0,
        left: 15.0,
        right: 15.0,
        bottom: 8.0,
      ),
    ),
    // View all anime card
    Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 8.0,
      ),
      child: ViewAllAnimeCard(),
    ),
    Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 8.0,
      ), /*
      child: Container(
        height: 80,
        width: double.infinity,
        color: Colors.red,

      ),*/
    ),

    Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 8.0,
      ),
    ),
    // Message Of The Day Card
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.build(context);
    return DeviceOrientationBuilder(
      portrait: HomePagePortrait(widgets: [
        SubCategoryText(
          text: 'Top Airing',
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        KitsuAnimeRow(
          futureProvider: FutureProvider<
              Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
            (ref) async => await KitsuApiService.getFanFavourites(),
          ),
        ),
        SubCategoryText(
          text: 'Top Anime Movies',
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
        ),
        KitsuAnimeRow(
          futureProvider: FutureProvider<
              Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
            (ref) async => await KitsuApiService.getTopMovies(),
          ),
        ),
        if (_isAdloaded)
          Container(
            width: myBanner.size.width.toDouble(),
            height: myBanner.size.height.toDouble(),
            child: AdWidget(
              ad: myBanner,
            ),
          ),
        SubCategoryText(
          text: 'Popular Anime',
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
        ),
        KitsuAnimeRow(
          futureProvider: FutureProvider<
              Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
            (ref) async => await KitsuApiService.getAllTimePopularAnimes(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 12.0,
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ),
        ),
        // View all anime card
        Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ),
          child: ViewAllAnimeCard(),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ), /*
      child: Container(
        height: 80,
        width: double.infinity,
        color: Colors.red,

      ),*/
        ),

        Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ),
        ),
        // Message Of The Day Card
      ]),
      landscape: HomePageLandscape(widgets: [
        SubCategoryText(
          text: 'Top Airing',
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        KitsuAnimeRow(
          futureProvider: FutureProvider<
              Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
            (ref) async => await KitsuApiService.getFanFavourites(),
          ),
        ),
        SubCategoryText(
          text: 'Top Anime Movies',
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
        ),
        KitsuAnimeRow(
          futureProvider: FutureProvider<
              Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
            (ref) async => await KitsuApiService.getTopMovies(),
          ),
        ),
        if (_isAdloaded)
          Container(
            width: myBanner.size.width.toDouble(),
            height: myBanner.size.height.toDouble(),
            child: AdWidget(
              ad: myBanner,
            ),
          ),
        SubCategoryText(
          text: 'Popular Anime',
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
        ),
        KitsuAnimeRow(
          futureProvider: FutureProvider<
              Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>(
            (ref) async => await KitsuApiService.getAllTimePopularAnimes(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 12.0,
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ),
        ),
        // View all anime card
        Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ),
          child: ViewAllAnimeCard(),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ), /*
      child: Container(
        height: 80,
        width: double.infinity,
        color: Colors.red,

      ),*/
        ),

        Padding(
          padding: EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8.0,
          ),
        ),
        // Message Of The Day Card
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
