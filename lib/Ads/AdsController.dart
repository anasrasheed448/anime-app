import 'dart:io';

import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAd extends StatefulWidget {
  const MyBannerAd({Key key}) : super(key: key);

  @override
  _MyBannerAdState createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(
        init: AdsController(),
        // dispose: (_) => AdsController().myBannerAd.dispose(),
        builder: (_) {
          if (!_._loadingAnchoredBanner) {
            _._loadingAnchoredBanner = true;
            _._createAnchoredBanner(context);
            _.update();
          }
          return _.myBannerAd != null
              ? Container(
                  width: _.myBannerAd.size.width.toDouble(),
                  height: _.myBannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _.myBannerAd))
              : SizedBox();
        });
  }
}

class MyNativeAd extends StatelessWidget {
  const MyNativeAd({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdsController>(
      init: AdsController(),
      builder: (_) => AdWidget(ad: _.myNativeAd),
    );
  }
}

const int maxFailedLoadAttempts = 3;

class AdsController extends GetxController {
  BannerAd myBannerAd;
  NativeAd myNativeAd;
  RewardedAd rewardedAd;
  InterstitialAd interstitialAd;
  bool _loadingAnchoredBanner = false;

  @override
  void dispose() {
    myBannerAd.dispose();

    super.dispose();
  }

  @override
  void onInit() async {
    // loadNativeAd();
    await _createAnchoredBanner(Get.context);
    await loadRewardedAd();
    createInterstitialAd();
    update();
    super.onInit();
  }

  String get bannerAdId {
    if (Platform.isAndroid)
      return 'ca-app-pub-8969525429477335/1605635294';
    else
      return 'ca-app-pub-8969525429477335/1605635294';
  }

  Future<void> _createAnchoredBanner(BuildContext context) async {
    myBannerAd = BannerAd(
      size: AdSize.banner,
      request: AdRequest(),
      adUnitId: bannerAdId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          myBannerAd = ad as BannerAd;
          update();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    update();
    return myBannerAd.load();
  }

  Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: RewardedAd.testAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('.........................Rewarded Ad Loaded: $ad');
          // Keep a reference to the ad so you can show it later.
          rewardedAd = ad;
          update();
        },
        onAdFailedToLoad: (LoadAdError error) {
          Get.close(1);
          print('.........................RewardedAd failed to load: $error');
        },
      ),
    );
    update();
  }

  void showRewardedAd(Widget widget) {
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );

    rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      Transitions.slideTransition(
          context: Get.context, pageBuilder: () => widget);
    });
    rewardedAd = null;
    update();
  }

  int _numInterstitialLoadAttempts = 0;

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-8969525429477335/7787900263',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd(page) async {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      await Transitions.slideTransition(
        context: Get.context,
        pageBuilder: () => page,
      );
      return;
    }
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    await interstitialAd
        .show()
        .then((value) => Transitions.slideTransition(
              context: Get.context,
              pageBuilder: () => page,
            ))
        .catchError((error) {
      Transitions.slideTransition(
        context: Get.context,
        pageBuilder: () => page,
      );
    });
    // interstitialAd = null;
  }

  // ignore: missing_return
  Future<bool> showInterstitialAdOnHome() async {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return false;
    }
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    await interstitialAd.show().then((value) async {
      return true;
    });
    interstitialAd = null;
  }
}
