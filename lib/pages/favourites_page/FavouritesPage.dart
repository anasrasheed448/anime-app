import 'package:anime_twist_flut/animations/SlideInAnimation.dart';
import 'package:anime_twist_flut/providers.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritedAnimeTile.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter/material.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../constants.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>
    with AutomaticKeepAliveClientMixin {
  TwistApiService twistApiService = Get.find();
  ScrollController _scrollController;

  static var myBanner;
  static var myBanner2;

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
 myBanner2 = BannerAd(
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
    myBanner2.load();

  }

  @override
  void initState() {
    super.initState();
    initBanner();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    myBanner.dispose();
    myBanner2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var width = MediaQuery.of(context).size.width;

    super.build(context);
    return Consumer(
      builder: (context, watch, child) {
        var prov = watch(favouriteAnimeProvider);
        var favouritedAnimes = prov.favouritedAnimes.reversed.toList();

        if (favouritedAnimes.isEmpty) {
          return SlideInAnimation(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () async {
                      await toggleAd();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_isAdloaded)
                  Container(
                    width: myBanner.size.width.toDouble(),
                    height: myBanner.size.height.toDouble(),
                    child: AdWidget(
                      ad: myBanner2,
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.33),
                Center(
                  child: Icon(
                    FontAwesomeIcons.heartBroken,
                    size: 75,
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () async {
                await toggleAd();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            title: AppbarText(
              custom: 'Favourate',
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 5.0,
                      ),
                      child: Builder(
                        builder: (context) {
                          return Scrollbar(
                            controller: _scrollController,
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: [
                                 // SizedBox(height: 20),
                if (_isAdloaded)
                  SliverToBoxAdapter(
                    child: Container(
                      width: myBanner.size.width.toDouble(),
                      height: myBanner.size.height.toDouble(),
                      child: AdWidget(
                        ad: myBanner,
                      ),
                    ),
                  ),
                                SliverPadding(
                                  padding: EdgeInsets.all(15.0),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          isPortrait ? 2 : (width / 400).ceil(),
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: isPortrait ? 0.65 : 1.4,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        var model = twistApiService
                                            .getTwistModelFromSlug(
                                                favouritedAnimes[index].slug);

                                        return FavouritedAnimeTile(
                                          favouritedModel:
                                              favouritedAnimes.elementAt(index),
                                          twistModel: model,
                                        );
                                      },
                                      childCount: favouritedAnimes.length,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        /*   Scrollbar(
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(15.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isPortrait ? 2 : (width / 400).ceil(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: isPortrait ? 0.65 : 1.4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var model = twistApiService
                          .getTwistModelFromSlug(favouritedAnimes[index].slug);

                      return FavouritedAnimeTile(
                        favouritedModel: favouritedAnimes.elementAt(index),
                        twistModel: model,
                      );
                    },
                    childCount: favouritedAnimes.length,
                  ),
                ),
              ),
            ],
          ),
        );*/
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
