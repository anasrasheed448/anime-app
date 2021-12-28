import 'package:anime_twist_flut/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const String DEFAULT_IMAGE_URL =
    'https://wallpaperset.com/w/full/9/1/1/470069.jpg';
var showEpisodes = false;
InterstitialAd interstitialAd;
bool interstitialAdReady = false;

Future loadinterstitialAd() async {
  await InterstitialAd.load(
    adUnitId: AdHelper().getInterstitialAdUnitId(),
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        interstitialAd = ad;
        interstitialAdReady = true;
      },
      onAdFailedToLoad: (LoadAdError error) {
        print("failed to Load Interstitial Ad");
      },
    ),
  );
}

void showInterstitialAd() {
  if (interstitialAd == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
  }
  interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) =>
        print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      loadinterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      loadinterstitialAd();
    },
  );
  interstitialAd.show();
  interstitialAd = null;
}

Future toggleAd() async {
  if (interstitialAdReady) {
    showInterstitialAd();
    // interstitialAd.show();
  } else {
    await loadinterstitialAd().whenComplete(() => showInterstitialAd());
  }
}
